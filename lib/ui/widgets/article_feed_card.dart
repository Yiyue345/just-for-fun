import 'package:flutter/material.dart';
import 'package:go_deeper/core/utils/datetime_utils.dart';
import 'package:go_deeper/data/model/feeditem.dart';

class ArticleFeedCard extends StatelessWidget {
  final FeedItem item;
  final VoidCallback onTap;
  final bool showAuthor;

  const ArticleFeedCard({
    super.key,
    required this.item,
    required this.onTap,
    this.showAuthor = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final article = item is ArticleFeed ? item as ArticleFeed : null;
    final articleAuthorName = article?.authorName?.trim();
    final authorName = articleAuthorName != null && articleAuthorName.isNotEmpty
        ? articleAuthorName
        : item.author;
    final coverUrl = item.coverUrl?.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (coverUrl != null && coverUrl.isNotEmpty)
                  _FeedLeadingVisual(
                    title: item.title,
                    coverUrl: coverUrl,
                  ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _FeedTypePill(type: item.type),
                          Text(
                            howLongTimeAgo(item.publishedTime.toLocal()),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.summary,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (showAuthor)
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_outline_rounded,
                                    size: 16,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      authorName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            const Spacer(),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedLeadingVisual extends StatelessWidget {
  final String title;
  final String? coverUrl;

  const _FeedLeadingVisual({
    required this.title,
    required this.coverUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasCover = coverUrl != null && coverUrl!.isNotEmpty;

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasCover
          ? Image.network(
              coverUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _FeedTitleMark(title: title);
              },
            )
          : _FeedTitleMark(title: title),
    );
  }
}

class _FeedTitleMark extends StatelessWidget {
  final String title;

  const _FeedTitleMark({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final trimmedTitle = title.trim();
    final mark = trimmedTitle.isEmpty
        ? '?'
        : String.fromCharCode(trimmedTitle.runes.first);

    return Center(
      child: Text(
        mark,
        style: theme.textTheme.headlineSmall?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _FeedTypePill extends StatelessWidget {
  final FeedType type;

  const _FeedTypePill({required this.type});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Icon(
        _iconForType(type),
        size: 15,
        color: colorScheme.onPrimaryContainer,
      ),
    );
  }

  IconData _iconForType(FeedType type) {
    switch (type) {
      case FeedType.article:
        return Icons.article_outlined;
      case FeedType.video:
        return Icons.play_circle_outline_rounded;
      case FeedType.question:
        return Icons.help_outline_rounded;
    }
  }
}
