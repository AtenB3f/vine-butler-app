class ChatRequestDto {
  const ChatRequestDto({required this.messages, required this.maxTokens, this.temperature = 0.5});

  final List<ChatMessageDto> messages;
  final int maxTokens;
  final double temperature;

  int get imageCount => messages.expand((message) => message.contents).where((content) => content.isImage).length;

  Map<String, dynamic> toJson() {
    return {
      'messages': [for (final message in messages) message.toJson()],
      'maxTokens': maxTokens,
      'temperature': temperature,
    };
  }
}

/// 대화 메시지 역할
/// - system: 역할을 규정하는 지시문
/// - user: 사용자의 발화 또는 질문
/// - assistant: 사용자의 발화 또는 질문에 대한 답변
enum ChatRole { 
  system,
  user,
  assistant
}

class ChatMessageDto {
  const ChatMessageDto({required this.role, required this.contents});

  final ChatRole role;
  final List<ChatContentDto> contents;

  Map<String, dynamic> toJson() {
    return {
      'role': role.name,
      'content': [for (final content in contents) content.toJson()],
    };
  }
}

class ChatContentDto {
  const ChatContentDto.text(String this.text) : base64Image = null;

  const ChatContentDto.image(String this.base64Image) : text = null;

  final String? text;
  final String? base64Image;

  bool get isImage => base64Image != null;

  Map<String, dynamic> toJson() {
    if (base64Image case final data?) {
      return {
        'type': 'image_url',
        'dataUri': {'data': data},
      };
    }

    return {'type': 'text', 'text': text};
  }
}
