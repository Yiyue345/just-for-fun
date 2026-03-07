import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../ui/pages/settings_page/change_language_page.dart';
import 'agent.dart';

/// 工具定义 ─ 传给 DeepSeek 的 function schema
const List<Map<String, dynamic>> agentTools = [
  {
    'type': 'function',
    'function': {
      'name': 'draft_article',
      'description': '生成文章草稿并填充到编辑器中，供用户审核后决定是否发布。',
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
        },
        'required': ['title', 'content'],
      },
    },
  },
  {
    'type': 'function',
    'function': {
      'name': 'draft_edit_article',
      'description': '生成修改后的文章内容并填充到编辑器中，供用户审核后决定是否保存。',
      'parameters': {
        'type': 'object',
        'properties': {
          'title': {
            'type': 'string',
            'description': '修改后的标题（可选，不提供则保持原标题）',
          },
          'content': {
            'type': 'string',
            'description': '修改后的正文（可选，不提供则保持原正文）',
          },
          'summary': {
            'type': 'string',
            'description': '修改后的摘要（可选，不提供则保持原摘要）',
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
      'description': '生成评论草稿并填充到评论输入框中，供用户审核后决定是否发布。',
      'parameters': {
        'type': 'object',
        'properties': {
          'content': {
            'type': 'string',
            'description': '评论内容',
          },
        },
        'required': ['content'],
      },
    },
  },
  // TODO: 可以根据需要添加更多工具，例如删除文章、回复评论、自动总结文章等
  {
    'type': 'function',
    'function': {
      'name': 'change_localization',
      'description': '切换用户界面语言。',
      'parameters': {
        'type': 'object',
        'properties': {
          'language_code': {
            'type': 'string',
            'description': '目标语言的 ISO 639-1 代码，目前支持 "en"、"zh"，若返回 "follow_system"，则切换为跟随系统',
          },
        },
        'required': ['language_code'],
      },
    },
  },
];


/// 执行工具调用并返回结果字符串
Future<String> executeTool(
    String name,
    Map<String, dynamic> args, {
      AgentToolCallbacks callbacks = const AgentToolCallbacks(),
    }) async {
  try {
    switch (name) {
      case 'draft_article':
        final title = args['title'] as String;
        final content = args['content'] as String;
        final summary = args['summary'] as String?;
        if (callbacks.onFillArticle != null) {
          callbacks.onFillArticle!(title, content, summary);
          return '已将文章草稿填充到编辑器，标题: $title。请用户审核后决定是否发布。';
        }
        return '草稿已生成，但当前页面不支持填充文章。标题: $title';

      case 'draft_edit_article':
        final title = args['title'] as String?;
        final content = args['content'] as String?;
        final summary = args['summary'] as String?;
        if (callbacks.onFillArticle != null && (title != null || content != null)) {
          callbacks.onFillArticle!(title ?? '', content ?? '', summary);
          return '已将修改后的内容填充到编辑器。请用户审核后决定是否保存。';
        }
        return '草稿已生成，但当前页面不支持填充文章。';

      case 'draft_comment':
        final content = args['content'] as String;
        if (callbacks.onFillComment != null) {
          callbacks.onFillComment!(content);
          return '已将评论草稿填充到输入框: "$content"。请用户审核后决定是否发布。';
        }
        return '草稿已生成，但当前页面不支持填充评论。内容: $content';

      case 'change_localization':
        final code = args['language_code'] as String;
        final languageController = Get.put(LanguageController());
        if (code == 'follow_system') {
          languageController.followSystemLanguage();
          return '已将语言切换为跟随系统';
        }

        try {
          languageController.changeLocale(code);
          return '已将界面语言切换为 $code';
        } catch(e) {
          return '不支持的语言代码: $code';
        }

      default:
        return '未知工具: $name';
    }
  } catch (e) {
    return '工具执行失败: $e';
  }
}