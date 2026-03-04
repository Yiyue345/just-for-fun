import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:go_deeper/core/network/article.dart';
import 'package:go_deeper/core/network/comment.dart' as comment_api;
import 'package:go_deeper/core/network/dio_client.dart';
import 'package:go_deeper/data/model/chat_message.dart';
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

  final response = await client.dio.post<ResponseBody>(
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

/// 工具定义 ─ 传给 DeepSeek 的 function schema
const List<Map<String, dynamic>> _agentTools = [
  {
    'type': 'function',
    'function': {
      'name': 'write_article',
      'description': '撰写并发布一篇新文章。返回新文章的 ID。',
      'parameters': {
        'type': 'object',
        'properties': {
          'title': {
            'type': 'string',
            'description': '文章标题',
          },
          'content': {
            'type': 'string',
            'description': '文章正文内容',
          },
          'summary': {
            'type': 'string',
            'description': '文章摘要（可选）',
          },
          'public': {
            'type': 'boolean',
            'description': '是否公开，默认 true',
          },
        },
        'required': ['title', 'content'],
      },
    },
  },
  {
    'type': 'function',
    'function': {
      'name': 'edit_article',
      'description': '修改一篇已有的文章。需要提供文章 ID 和要修改的字段。',
      'parameters': {
        'type': 'object',
        'properties': {
          'article_id': {
            'type': 'integer',
            'description': '要修改的文章 ID',
          },
          'title': {
            'type': 'string',
            'description': '新标题（可选）',
          },
          'content': {
            'type': 'string',
            'description': '新正文（可选）',
          },
          'summary': {
            'type': 'string',
            'description': '新摘要（可选）',
          },
          'public': {
            'type': 'boolean',
            'description': '是否公开（可选）',
          },
        },
        'required': ['article_id'],
      },
    },
  },
  {
    'type': 'function',
    'function': {
      'name': 'write_comment',
      'description': '在指定文章下发布一条评论。',
      'parameters': {
        'type': 'object',
        'properties': {
          'article_id': {
            'type': 'integer',
            'description': '目标文章 ID',
          },
          'content': {
            'type': 'string',
            'description': '评论内容',
          },
          'parent_id': {
            'type': 'integer',
            'description': '要回复的评论 ID（可选，不填则为顶级评论）',
          },
        },
        'required': ['article_id', 'content'],
      },
    },
  },
];

/// 执行工具调用并返回结果字符串
Future<String> _executeTool(String name, Map<String, dynamic> args) async {
  final supabase = Supabase.instance.client;
  final userID = supabase.auth.currentUser?.id;
  if (userID == null) return '错误：用户未登录';

  try {
    switch (name) {
      case 'write_article':
        final article = await createArticle(
          authorUUID: userID,
          title: args['title'] as String,
          content: args['content'] as String,
          summary: args['summary'] as String?,
          public: args['public'] as bool? ?? true,
        );
        return '文章创建成功。ID: ${article.id}，标题: ${article.title}';

      case 'edit_article':
        final article = await updateArticle(
          articleID: args['article_id'] as int,
          title: args['title'] as String?,
          content: args['content'] as String?,
          summary: args['summary'] as String?,
          public: args['public'] as bool?,
        );
        return '文章修改成功。ID: ${article.id}，标题: ${article.title}';

      case 'write_comment':
        final comment = await comment_api.createComment(
          articleID: args['article_id'] as int,
          userID: userID,
          content: args['content'] as String,
          parentID: args['parent_id'] as int?,
        );
        return '评论发布成功。ID: ${comment.id}，内容: ${comment.content}';

      default:
        return '未知工具: $name';
    }
  } catch (e) {
    return '工具执行失败: $e';
  }
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
  int maxRounds = 5,
}) async* {
  // 系统提示
  final systemMsg = ChatMessage.system(
    '你是一个智能助手，可以帮助用户撰写文章、修改文章、发布评论。'
    '当用户要求你执行这些操作时，请调用对应的工具。'
    '当不需要调用工具时，直接用文字回复用户。',
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
      tools: _agentTools,
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
        final result = await _executeTool(tc.function.name, args);

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
  yield AgentDone('[Agent 达到最大工具调用轮次限制]');
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
      final line = part.trim();
      if (!line.startsWith('data: ')) continue;

      final data = line.substring(6);
      if (data == '[DONE]') return;

      try {
        final json = jsonDecode(data) as Map<String, dynamic>;
        yield SseEvent(
          content: json['content'] as String?,
          toolCallDeltas: (json['tool_calls'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList(),
          finishReason: json['finish_reason'] as String?,
        );
      } catch (_) {}
    }
  }
}
