import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/l10n/app_localizations.dart';

import '../../ui/pages/settings_page/change_language_page.dart';
import 'agent.dart';

/// 工具定义 ─ 传给 DeepSeek 的 function schema
List<Map<String, dynamic>> get agentTools {
  final l10n = Get.context != null ? AppLocalizations.of(Get.context!) : null;

  return [
    {
      'type': 'function',
      'function': {
        'name': 'draft_article',
        'description': l10n?.toolDraftArticleDescription ??
            'Generate an article draft and fill it into the editor for user review before publishing.',
        'parameters': {
          'type': 'object',
          'properties': {
            'title': {
              'type': 'string',
              'description': l10n?.toolDraftArticleTitleParam ?? 'Article title',
            },
            'content': {
              'type': 'string',
              'description': l10n?.toolDraftArticleContentParam ?? 'Article body content in Markdown format',
            },
            'summary': {
              'type': 'string',
              'description': l10n?.toolDraftArticleSummaryParam ?? 'Article summary (optional)',
            },
          },
          'required': ['title', 'content'],
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': 'draft_edit_article',
        'description': l10n?.toolDraftEditArticleDescription ??
            'Generate revised article content and fill it into the editor for user review before saving.',
        'parameters': {
          'type': 'object',
          'properties': {
            'title': {
              'type': 'string',
              'description': l10n?.toolDraftEditArticleTitleParam ??
                  'Updated title (optional; keep the current title if omitted)',
            },
            'content': {
              'type': 'string',
              'description': l10n?.toolDraftEditArticleContentParam ??
                  'Updated body content (optional; keep the current body if omitted)',
            },
            'summary': {
              'type': 'string',
              'description': l10n?.toolDraftEditArticleSummaryParam ??
                  'Updated summary (optional; keep the current summary if omitted)',
            },
          },
          'required': [],
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': 'draft_comment',
        'description': l10n?.toolDraftCommentDescription ??
            'Generate a comment draft and fill it into the input box for user review before posting.',
        'parameters': {
          'type': 'object',
          'properties': {
            'content': {
              'type': 'string',
              'description': l10n?.toolDraftCommentContentParam ?? 'Comment content',
            },
          },
          'required': ['content'],
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': 'change_localization',
        'description': l10n?.toolChangeLocalizationDescription ??
            'Switch the user interface language.',
        'parameters': {
          'type': 'object',
          'properties': {
            'language_code': {
              'type': 'string',
              'description': l10n?.toolChangeLocalizationLanguageCodeParam ??
                  'Target ISO 639-1 language code. Currently supports "en" and "zh". Use "follow_system" to follow system language.',
            },
          },
          'required': ['language_code'],
        },
      },
    },
  ];
}


/// 执行工具调用并返回结果字符串
Future<String> executeTool(
    String name,
    Map<String, dynamic> args, {
      AgentToolCallbacks callbacks = const AgentToolCallbacks(),
    }) async {
  final l10n = Get.context != null ? AppLocalizations.of(Get.context!) : null;
  try {
    switch (name) {
      case 'draft_article':
        final title = args['title'] as String;
        final content = args['content'] as String;
        final summary = args['summary'] as String?;
        if (callbacks.onFillArticle != null) {
          callbacks.onFillArticle!(title, content, summary);
          return l10n?.toolDraftArticleFilled(title) ??
              'The article draft has been filled into the editor. Title: $title. Please let the user review it before publishing.';
        }
        return l10n?.toolDraftArticleUnsupported(title) ??
            'The draft was generated, but the current page does not support filling articles. Title: $title';

      case 'draft_edit_article':
        final title = args['title'] as String?;
        final content = args['content'] as String?;
        final summary = args['summary'] as String?;
        if (callbacks.onFillArticle != null && (title != null || content != null)) {
          callbacks.onFillArticle!(title ?? '', content ?? '', summary);
          return l10n?.toolDraftEditArticleFilled ??
              'The revised content has been filled into the editor. Please let the user review it before saving.';
        }
        return l10n?.toolDraftEditArticleUnsupported ??
            'The draft was generated, but the current page does not support filling articles.';

      case 'draft_comment':
        final content = args['content'] as String;
        if (callbacks.onFillComment != null) {
          callbacks.onFillComment!(content);
          return l10n?.toolDraftCommentFilled(content) ??
              'The comment draft has been filled into the input box: "$content". Please let the user review it before posting.';
        }
        return l10n?.toolDraftCommentUnsupported(content) ??
            'The draft was generated, but the current page does not support filling comments. Content: $content';

      case 'change_localization':
        final code = args['language_code'] as String;
        final languageController = Get.put(LanguageController());
        if (code == 'follow_system') {
          languageController.followSystemLanguage();
          return l10n?.toolLanguageFollowSystem ??
              'The language has been switched to follow the system.';
        }

        try {
          languageController.changeLocale(code);
          return l10n?.toolLanguageChanged(code) ??
              'The interface language has been changed to $code.';
        } catch(e) {
          return l10n?.toolLanguageUnsupported(code) ??
              'Unsupported language code: $code';
        }

      default:
        return l10n?.toolUnknown(name) ?? 'Unknown tool: $name';
    }
  } catch (e) {
    return l10n?.toolExecutionFailed(e.toString()) ?? 'Tool execution failed: $e';
  }
}
