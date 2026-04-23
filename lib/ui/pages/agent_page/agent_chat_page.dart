import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/pages/agent_page/agent_controller.dart';

/// Agent 对话页面，嵌入 ModalBottomSheet 中使用
class AgentChatPage extends StatefulWidget {
  final String controllerTag;

  const AgentChatPage({super.key, required this.controllerTag});

  @override
  State<AgentChatPage> createState() => _AgentChatPageState();
}

class _AgentChatPageState extends State<AgentChatPage> {
  late final TextEditingController _inputController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AgentController>(tag: widget.controllerTag);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // ── 拖拽指示条 ──
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // ── 标题栏 ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.agentTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                tooltip: l10n.agentClearChatTooltip,
                onPressed: () {
                  controller.clearChat();
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // ── 聊天消息列表 ──
        Expanded(
          child: Obx(() {
            final items = controller.chatItems;
            _scrollToBottom();
            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_outlined,
                      size: 48,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.agentEmptyTitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.agentEmptySubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildChatBubble(context, items[index]);
              },
            );
          }),
        ),

        // ── 输入区域 ──
        const Divider(height: 1),
        Padding(
          padding: EdgeInsets.only(
            left: 12,
            right: 8,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: l10n.agentInputHint,
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Obx(() => IconButton(
                icon: controller.isGenerating.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      )
                    : Icon(Icons.send, color: colorScheme.primary),
                onPressed: controller.isGenerating.value
                    ? null
                    : () {
                        final text = _inputController.text.trim();
                        if (text.isNotEmpty) {
                          _inputController.clear();
                          controller.sendMessage(text);
                        }
                      },
              )),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建单条聊天气泡
  Widget _buildChatBubble(BuildContext context, AgentChatItem item) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = theme.colorScheme;

    switch (item.role) {
      case 'user':
        return _UserBubble(content: item.content, colorScheme: colorScheme);
      case 'assistant':
        return _AssistantBubble(content: item.content, colorScheme: colorScheme);
      case 'tool_start':
        return _ToolStatusTile(
          icon: Icons.hourglass_top,
          iconColor: Colors.orange,
          title: l10n.agentToolCallingTitle(item.toolName ?? ''),
          subtitle: item.content,
        );
      case 'tool_result':
        return _ToolStatusTile(
          icon: Icons.check_circle,
          iconColor: Colors.green,
          title: l10n.agentToolCompletedTitle(item.toolName ?? ''),
          subtitle: item.content,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ═══════════════════════════════════════════════
// 子组件
// ═══════════════════════════════════════════════

class _UserBubble extends StatelessWidget {
  final String content;
  final ColorScheme colorScheme;

  const _UserBubble({required this.content, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, left: 48),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          content,
          style: TextStyle(color: colorScheme.onPrimary, fontSize: 15),
        ),
      ),
    );
  }
}

class _AssistantBubble extends StatelessWidget {
  final String content;
  final ColorScheme colorScheme;

  const _AssistantBubble({required this.content, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, right: 48),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: content.isEmpty
            ? _TypingIndicator(color: colorScheme.onSurfaceVariant)
            : SelectableText(
                content,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
      ),
    );
  }
}

/// 工具调用状态行
class _ToolStatusTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _ToolStatusTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 打字中指示器
class _TypingIndicator extends StatefulWidget {
  final Color color;
  const _TypingIndicator({required this.color});

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = ((_controller.value + delay) % 1.0);
            final opacity = (value < 0.5) ? value * 2 : (1.0 - value) * 2;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: opacity.clamp(0.2, 1.0)),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}








