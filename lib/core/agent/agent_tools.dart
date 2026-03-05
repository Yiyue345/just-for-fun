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
];