import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:go_deeper/core/agent/agent_tools.dart';
import 'package:go_deeper/core/network/dio_client.dart';
import 'package:go_deeper/data/model/chat_message.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ╔═══════════════════════════════════════════════════════════╗
// ║  1. 基础 API                                              ║
// ╚═══════════════════════════════════════════════════════════╝

/// 非流式获取 AI 回复（保留旧接口兼容）
Future<String> getReply(String prompt) async {
  final supabase = Supabase.instance.client;
  final res = await supabase.functions.invoke(
    'generate-ai-response',
    body: {'prompt': prompt},
  );
  return res.data['reply'] as String;
}

// ╔═══════════════════════════════════════════════════════════╗
// ║  2. 多轮对话（流式）                                       ║
// ╚═══════════════════════════════════════════════════════════╝

/// SSE 解析后的单个事件
class SseEvent {
  final String? content;
  final List<Map<String, dynamic>>? toolCallDeltas;
  final String? finishReason;

  SseEvent({this.content, this.toolCallDeltas, this.finishReason});
}

/// 底层：向 Edge Function 发送多轮消息，返回原始 SSE 事件流。
/// [messages] 完整的多轮对话列表
/// [tools]    可选，function calling 的工具定义 JSON
Stream<SseEvent> _chatCompletionStream({
  required List<ChatMessage> messages,
  List<Map<String, dynamic>>? tools,
}) async* {
  final client = DioClient.instance;
  final url = '${client.functionsBaseUrl}/generate-ai-response-stream';

  final body = <String, dynamic>{
    'messages': messages.map((m) => m.toJson()).toList(),
  };
  if (tools != null && tools.isNotEmpty) {
    body['tools'] = tools;
  }

  final response = await client.streamDio.post<ResponseBody>(
    url,
    data: body,
    options: Options(
      headers: client.authHeaders,
      responseType: ResponseType.stream,
    ),
  );

  yield* _parseSseStream(response.data!.stream);
}

/// 简单的多轮对话流式接口，逐 token 返回文本。
/// 传入完整的 [messages] 历史即可。
Stream<String> chatStream(List<ChatMessage> messages) async* {
  await for (final event in _chatCompletionStream(messages: messages)) {
    if (event.content != null) {
      yield event.content!;
    }
  }
}

/// 单轮快捷方法（兼容旧的 getReplyStream）
Stream<String> getReplyStream(String prompt) async* {
  yield* chatStream([ChatMessage.user(prompt)]);
}

// ╔═══════════════════════════════════════════════════════════╗
// ║  3. Function-Calling Agent                                ║
// ╚═══════════════════════════════════════════════════════════╝

/// Agent 执行过程中通过此回调向 UI 报告状态。
/// [AgentEvent] 可以是文本 token、工具调用信息、或最终结果。
sealed class AgentEvent {}

/// AI 正在输出文本 token
class AgentTextDelta extends AgentEvent {
  final String text;
  AgentTextDelta(this.text);
}

/// AI 正在调用工具
class AgentToolCallStart extends AgentEvent {
  final String toolName;
  AgentToolCallStart(this.toolName);
}

/// 工具调用完成，附带结果摘要
class AgentToolCallResult extends AgentEvent {
  final String toolName;
  final String result;
  AgentToolCallResult(this.toolName, this.result);
}

/// Agent 完全结束
class AgentDone extends AgentEvent {
  final String fullText;
  AgentDone(this.fullText);
}

/// 工具执行回调集合
class AgentToolCallbacks {
  /// 文章草稿回调：(title, content, summary) → 填充到编辑器
  final void Function(String title, String content, String? summary)? onFillArticle;

  /// 评论草稿回调：(content) → 填充到评论输入框
  final void Function(String content)? onFillComment;

  const AgentToolCallbacks({this.onFillArticle, this.onFillComment});
}

/// 带 function calling 的 Agent 入口。
///
/// 传入完整的多轮 [messages]，Agent 会自动：
/// 1. 向 AI 发送请求
/// 2. 如果 AI 返回 tool_calls → 执行工具 → 将结果追加到消息 → 再次请求
/// 3. 循环直到 AI 返回纯文本回复
///
/// 通过 yield [AgentEvent] 实时报告进度，UI 层 `await for` 即可。
///
/// [maxRounds] 限制最大工具调用轮次，防止无限循环。
Stream<AgentEvent> runAgent({
  required List<ChatMessage> messages,
  String? systemPrompt,
  AgentToolCallbacks callbacks = const AgentToolCallbacks(),
  int maxRounds = 5,
}) async* {
  // 系统提示
  final systemMsg = ChatMessage.system(
    systemPrompt ??
        '你是一个智能助手，可以帮助用户撰写文章、修改文章、发布评论、以及帮忙用户进行一些应用设置。'
        '当用户要求你执行这些操作时，请调用对应的工具。'
        '当不需要调用工具时，直接用文字回复用户。'
        '除非用户额外要求，否则在直接使用文字回复用户时，不要使用 Markdown 语法，也不要添加任何格式，只需要回复纯文本内容。',
  );

  // 完整消息历史（内部维护，不修改外部传入的 list）
  final history = <ChatMessage>[systemMsg, ...messages];

  for (var round = 0; round < maxRounds; round++) {
    // ── 收集本轮流式响应 ──
    final textBuffer = StringBuffer();

    // 累积 tool_calls（流式中是增量到达的）
    final toolCallsMap = <int, _ToolCallAccumulator>{};
    String? finishReason;

    await for (final event in _chatCompletionStream(
      messages: history,
      tools: agentTools,
    )) {
      // 文本 token → 直接转发给 UI
      if (event.content != null) {
        textBuffer.write(event.content);
        yield AgentTextDelta(event.content!);
      }

      // tool_calls 增量
      if (event.toolCallDeltas != null) {
        for (final delta in event.toolCallDeltas!) {
          final index = delta['index'] as int;
          final acc = toolCallsMap.putIfAbsent(
            index,
            () => _ToolCallAccumulator(),
          );
          if (delta.containsKey('id')) acc.id = delta['id'] as String;
          if (delta.containsKey('type')) acc.type = delta['type'] as String;
          if (delta['function'] != null) {
            final fn = delta['function'] as Map<String, dynamic>;
            if (fn.containsKey('name')) acc.name = fn['name'] as String;
            if (fn.containsKey('arguments')) {
              acc.argumentsBuffer.write(fn['arguments'] as String);
            }
          }
        }
      }

      if (event.finishReason != null) {
        finishReason = event.finishReason;
      }
    }

    // ── 本轮流结束，判断是否有 tool_calls ──
    if (finishReason == 'tool_calls' && toolCallsMap.isNotEmpty) {
      // 构建完整的 ToolCall 列表
      final toolCalls = toolCallsMap.entries.map((e) {
        final acc = e.value;
        return ToolCall(
          id: acc.id ?? 'call_${e.key}',
          type: acc.type ?? 'function',
          function: FunctionCall(
            name: acc.name ?? '',
            arguments: acc.argumentsBuffer.toString(),
          ),
        );
      }).toList();

      // 把 assistant 的 tool_calls 消息加入历史
      history.add(ChatMessage.assistantWithToolCalls(toolCalls));

      // 逐个执行工具
      for (final tc in toolCalls) {
        yield AgentToolCallStart(tc.function.name);

        final args = jsonDecode(tc.function.arguments) as Map<String, dynamic>;
        final result = await executeTool(tc.function.name, args, callbacks: callbacks);

        yield AgentToolCallResult(tc.function.name, result);

        // 把工具结果加入历史
        history.add(ChatMessage.toolResult(
          toolCallId: tc.id,
          name: tc.function.name,
          content: result,
        ));
      }

      // 继续下一轮，让 AI 基于工具结果生成回复
      continue;
    }

    // ── 纯文本回复，Agent 结束 ──
    final fullText = textBuffer.toString();
    if (fullText.isNotEmpty) {
      history.add(ChatMessage.assistant(fullText));
    }
    yield AgentDone(fullText);
    return;
  }

  // 超出最大轮次
  final l10n = Get.context != null ? AppLocalizations.of(Get.context!) : null;
  yield AgentDone(l10n?.agentMaxRoundsReached ?? '[Agent reached the maximum tool-calling rounds]');
}

// ╔═══════════════════════════════════════════════════════════╗
// ║  4. 便捷单功能流式方法（保留，可直接用）                      ║
// ╚═══════════════════════════════════════════════════════════╝

/// AI 撰写文章（纯文本流，不自动发布）
Stream<String> aiWriteArticleStream({
  required String topic,
  String? requirements,
}) async* {
  final prompt = StringBuffer();
  prompt.write('请为我撰写一篇关于"$topic"的文章。');
  if (requirements != null && requirements.isNotEmpty) {
    prompt.write(' 额外要求：$requirements');
  }
  prompt.write(' 请直接输出文章内容，不需要额外解释。');
  yield* getReplyStream(prompt.toString());
}

/// AI 修改/润色文章（纯文本流）
Stream<String> aiEditArticleStream({
  required String originalContent,
  required String instruction,
}) async* {
  yield* getReplyStream(
    '请根据以下指令修改文章，直接输出修改后的完整文章内容，不需要额外解释。\n\n'
    '修改指令：$instruction\n\n原文：\n$originalContent',
  );
}

/// AI 撰写评论（纯文本流，不自动发布）
Stream<String> aiWriteCommentStream({
  required String articleTitle,
  required String articleContent,
  String? tone,
}) async* {
  final prompt = StringBuffer();
  prompt.write('请针对以下文章撰写一条简短的评论。');
  if (tone != null && tone.isNotEmpty) prompt.write(' 语气要求：$tone。');
  prompt.write(' 直接输出评论内容，不需要额外解释。\n\n');
  prompt.write('文章标题：$articleTitle\n文章内容：$articleContent');
  yield* getReplyStream(prompt.toString());
}

// ╔═══════════════════════════════════════════════════════════╗
// ║  内部：SSE 流解析                                          ║
// ╚═══════════════════════════════════════════════════════════╝

/// 累积器：流式 tool_call 是分批到达的，需要拼接
class _ToolCallAccumulator {
  String? id;
  String? type;
  String? name;
  final StringBuffer argumentsBuffer = StringBuffer();
}

/// 将字节流解析为 [SseEvent] 序列
Stream<SseEvent> _parseSseStream(Stream<List<int>> byteStream) async* {
  String buffer = '';

  await for (final chunk in byteStream) {
    buffer += utf8.decode(chunk);

    final parts = buffer.split('\n\n');
    buffer = parts.removeLast();

    for (final part in parts) {
      final event = _parseSsePart(part);
      if (event == null) continue; // [DONE] 或空
      if (event == _doneSignal) return;
      yield event;
    }
  }

  // 处理流关闭后 buffer 中残留的数据
  if (buffer.trim().isNotEmpty) {
    final event = _parseSsePart(buffer);
    if (event != null && event != _doneSignal) {
      yield event;
    }
  }
}

/// 哨兵对象，表示收到 [DONE]
final _doneSignal = SseEvent();

/// 解析单个 SSE 段落，返回 null 表示跳过，返回 _doneSignal 表示结束
SseEvent? _parseSsePart(String part) {
  final line = part.trim();
  if (!line.startsWith('data: ')) return null;

  final data = line.substring(6);
  if (data == '[DONE]') return _doneSignal;

  try {
    final json = jsonDecode(data) as Map<String, dynamic>;
    return SseEvent(
      content: json['content'] as String?,
      toolCallDeltas: (json['tool_calls'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      finishReason: json['finish_reason'] as String?,
    );
  } catch (_) {
    return null;
  }
}
