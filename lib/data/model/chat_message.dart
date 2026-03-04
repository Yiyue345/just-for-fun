/// AI 对话消息模型

enum ChatRole { system, user, assistant, tool }

class ChatMessage {
  final ChatRole role;
  final String? content;

  /// function calling 相关
  final List<ToolCall>? toolCalls;
  final String? toolCallId;
  final String? name;

  ChatMessage({
    required this.role,
    this.content,
    this.toolCalls,
    this.toolCallId,
    this.name,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'role': role.name,
    };
    if (content != null) map['content'] = content;
    if (toolCalls != null && toolCalls!.isNotEmpty) {
      map['tool_calls'] = toolCalls!.map((t) => t.toJson()).toList();
    }
    if (toolCallId != null) map['tool_call_id'] = toolCallId;
    if (name != null) map['name'] = name;
    return map;
  }

  factory ChatMessage.user(String content) =>
      ChatMessage(role: ChatRole.user, content: content);

  factory ChatMessage.assistant(String content) =>
      ChatMessage(role: ChatRole.assistant, content: content);

  factory ChatMessage.system(String content) =>
      ChatMessage(role: ChatRole.system, content: content);

  factory ChatMessage.toolResult({
    required String toolCallId,
    required String name,
    required String content,
  }) =>
      ChatMessage(
        role: ChatRole.tool,
        content: content,
        toolCallId: toolCallId,
        name: name,
      );

  factory ChatMessage.assistantWithToolCalls(List<ToolCall> toolCalls) =>
      ChatMessage(
        role: ChatRole.assistant,
        toolCalls: toolCalls,
      );
}

class ToolCall {
  final String id;
  final String type;
  final FunctionCall function;

  ToolCall({
    required this.id,
    required this.type,
    required this.function,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'function': function.toJson(),
  };

  factory ToolCall.fromJson(Map<String, dynamic> json) => ToolCall(
    id: json['id'] as String,
    type: json['type'] as String? ?? 'function',
    function: FunctionCall.fromJson(json['function'] as Map<String, dynamic>),
  );
}

class FunctionCall {
  final String name;
  final String arguments;

  FunctionCall({required this.name, required this.arguments});

  Map<String, dynamic> toJson() => {
    'name': name,
    'arguments': arguments,
  };

  factory FunctionCall.fromJson(Map<String, dynamic> json) => FunctionCall(
    name: json['name'] as String,
    arguments: json['arguments'] as String,
  );
}

