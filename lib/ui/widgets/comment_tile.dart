import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/utils/datetime_utils.dart';
import 'package:go_deeper/core/utils/user_utils.dart';
import 'package:go_deeper/data/model/comment.dart';
import 'package:go_deeper/ui/pages/article_pages/article_controller.dart';

import '../../l10n/app_localizations.dart';
import '../pages/article_pages/comment_page.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final bool showTrailingButton;
  final bool isTopLevelComment;
  final Future<void> Function()? onReply;
  final VoidCallback? onLike;

  CommentTile({
    required this.comment,
    this.showTrailingButton = true,
    required this.isTopLevelComment,
    this.onReply,
    this.onLike,
  });

  Future<void> _openCommentThread(
    BuildContext context,
    ArticleController articleController,
  ) async {
    articleController.currentComment.value = comment;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Material(
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: CommentPage(articleID: comment.articleId),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final articleController = Get.find<ArticleController>(
      tag: comment.articleId.toString(),
    );
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canOpenThread = isTopLevelComment && comment.replies.isNotEmpty;
    final showThreadAction = showTrailingButton && canOpenThread;
    final avatarText = comment.userName.trim().isEmpty
        ? '?'
        : comment.userName.trim().substring(0, 1).toUpperCase();

    return Padding(
      padding: EdgeInsets.only(
        left: isTopLevelComment ? 12 : 24,
        right: 12,
        top: 6,
        bottom: 6,
      ),
      child: Material(
        color: isTopLevelComment
            ? colorScheme.surfaceContainerLow
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: showThreadAction
              ? () => _openCommentThread(context, articleController)
              : null,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    goToOtherUserPage(userUUID: comment.userId);
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
                    child: Text(
                      avatarText,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              goToOtherUserPage(userUUID: comment.userId);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Text(
                              comment.userName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            howLongTimeAgo(comment.createdAt.toLocal()),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      if (comment.parentUserName != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.replyTo(comment.parentUserName!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Text(
                        comment.content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (onReply != null)
                            _CommentActionChip(
                              icon: Icons.reply_rounded,
                              onTap: () {
                                onReply!();
                              },
                            ),
                          // Placeholder for future like support.
                          _CommentActionChip(
                            icon: Icons.favorite_border_rounded,
                            onTap: onLike,
                            isPlaceholder: onLike == null,
                          ),
                          if (showThreadAction)
                            _CommentActionChip(
                              icon: Icons.forum_outlined,
                              label: '${comment.replies.length}',
                              onTap: () {
                                _openCommentThread(context, articleController);
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (showThreadAction) ...[
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CommentActionChip extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback? onTap;
  final bool isPlaceholder;

  const _CommentActionChip({
    required this.icon,
    this.label,
    this.onTap,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: isPlaceholder
          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.55)
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isPlaceholder
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onSurface,
              ),
              if (label != null) ...[
                const SizedBox(width: 6),
                Text(
                  label!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
