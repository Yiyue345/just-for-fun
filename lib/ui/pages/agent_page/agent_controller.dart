import 'package:get/get.dart';
import 'package:go_deeper/core/agent/agent.dart';
import 'package:go_deeper/data/model/chat_message.dart';
import 'package:go_deeper/l10n/app_localizations.dart';

/// Agent 对话中一条 UI 消息
class AgentChatItem {
  final String role; // 'user', 'assistant', 'tool_start', 'tool_result'
  final String content;
  final String? toolName;
  final DateTime timestamp;

  AgentChatItem({
    required this.role,
    required this.content,
    this.toolName,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// 管理 Agent 对话状态的控制器
/// 由父页面（ArticlePage / EditArticlePage）注入和销毁
class AgentController extends GetxController {
  /// 页面上下文类型
  final String contextType; // 'article_view' | 'article_edit' | 'comment'

  /// 当前文章 ID（查看页面时有值）
  final int? articleId;

  AgentController({
    required this.contextType,
    this.articleId,
  });

  /// UI 聊天记录
  final chatItems = <AgentChatItem>[].obs;

  /// 发给 AI 的多轮对话上下文
  final _messages = <ChatMessage>[];

  /// 是否正在生成中
  final isGenerating = false.obs;

  /// 当前流式文本缓冲（用于实时更新最后一条 assistant 消息）
  final currentStreamText = ''.obs;

  /// 获取父页面的文本上下文，供 Agent 理解当前内容
  /// 由父页面在打开 Agent 前设置
  String _pageContext = '';

  // ── 回调：将 Agent 生成的内容填充到对应 TextField ──

  /// 文章草稿回调：(title, content, summary)
  void Function(String title, String content, String? summary)? onFillArticle;

  /// 评论草稿回调：(content)
  void Function(String content)? onFillComment;

  void setPageContext(String context) {
    _pageContext = context;
  }

  /// 构建系统提示词，包含页面上下文
  String _buildSystemPrompt() {
    final l10n = Get.context != null ? AppLocalizations.of(Get.context!) : null;
    final sb = StringBuffer();
    sb.writeln(l10n?.agentSystemPromptLine1 ??
        'You are an intelligent assistant that helps users write articles, edit articles, and post comments.');
    sb.writeln(l10n?.agentSystemPromptLine2 ??
        'When the user asks for these actions, call the appropriate tools.');
    sb.writeln(l10n?.agentSystemPromptLine3 ??
        'When no tool is needed, reply directly in plain text.');

    if (_pageContext.isNotEmpty) {
      sb.writeln();
      sb.writeln(l10n?.agentContextHeader ?? 'Here is the context of what the user is currently working on:');
      sb.writeln(_pageContext);
    }

    return sb.toString();
  }

  /// 发送用户消息，调用 Agent
  Future<void> sendMessage(String text) async {
    final l10n = Get.context != null ? AppLocalizations.of(Get.context!) : null;
    if (text.trim().isEmpty || isGenerating.value) return;

    // 添加用户消息到 UI
    chatItems.add(AgentChatItem(role: 'user', content: text));

    // 添加到多轮对话上下文
    _messages.add(ChatMessage.user(text));

    isGenerating.value = true;
    currentStreamText.value = '';

    // 添加一条占位 assistant 消息用于流式更新
    chatItems.add(AgentChatItem(role: 'assistant', content: ''));
    var assistantIndex = chatItems.length - 1;

    try {
      final stream = runAgent(
        messages: List.of(_messages),
        systemPrompt: _buildSystemPrompt(),
        callbacks: AgentToolCallbacks(
          onFillArticle: onFillArticle,
          onFillComment: onFillComment,
        ),
      );
      final textBuffer = StringBuffer();

      await for (final event in stream) {
        switch (event) {
          case AgentTextDelta(:final text):
            textBuffer.write(text);
            currentStreamText.value = textBuffer.toString();
            // 更新占位消息
            chatItems[assistantIndex] = AgentChatItem(
              role: 'assistant',
              content: textBuffer.toString(),
            );
            chatItems.refresh();
            break;

          case AgentToolCallStart(:final toolName):
            chatItems.add(AgentChatItem(
              role: 'tool_start',
              content: l10n?.agentToolCalling ?? 'Calling tool...',
              toolName: toolName,
            ));
            break;

          case AgentToolCallResult(:final toolName, :final result):
            chatItems.add(AgentChatItem(
              role: 'tool_result',
              content: result,
              toolName: toolName,
            ));
            chatItems.add(AgentChatItem(role: 'assistant', content: ''));
            assistantIndex = chatItems.length - 1; // 更新占位消息索引
            textBuffer.clear();
            break;

          case AgentDone(:final fullText):
            // 确保最终文本完整
            if (fullText.isNotEmpty) {
              // 你怎么说也要把总结输出放到后面来吧
              // chatItems.removeAt(assistantIndex);
              chatItems[assistantIndex] = AgentChatItem(
                role: 'assistant',
                content: fullText,
              );
              chatItems.refresh();
              _messages.add(ChatMessage.assistant(fullText));
            } else if (textBuffer.isEmpty) {
              // 没有文本输出（纯工具调用），移除占位消息
              chatItems.removeAt(assistantIndex);
            }
            break;
        }
      }
    } catch (e) {
      // 移除占位消息
      if (chatItems[assistantIndex].content.isEmpty) {
        chatItems.removeAt(assistantIndex);
      }
      chatItems.add(AgentChatItem(
        role: 'assistant',
        content: (l10n?.agentError(e.toString())) ?? 'Something went wrong: $e',
      ));
    } finally {
      isGenerating.value = false;
      currentStreamText.value = '';
    }
  }

  /// 清空对话
  void clearChat() {
    chatItems.clear();
    _messages.clear();
    currentStreamText.value = '';
  }
}


