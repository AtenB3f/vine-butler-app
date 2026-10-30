class ChatRequestDto {
  const ChatRequestDto({
    required this.messages,
    required this.maxTokens,
    this.temperature = 0.4,
    this.topP,
    this.topK,
    this.repetitionPenalty,
  });

  final List<ChatMessageDto> messages;
  final int maxTokens;
  final double temperature;
  final double? topP;
  final int? topK;
  final double? repetitionPenalty;

  int get imageCount => messages.expand((message) => message.contents).where((content) => content.isImage).length;

  Map<String, dynamic> toJson() {
    return {
      'messages': [for (final message in messages) message.toJson()],
      'maxTokens': maxTokens,
      'temperature': temperature,
      'topP': ?topP,
      'topK': ?topK,
      'repetitionPenalty': ?repetitionPenalty,
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

/// 메시지 내용 (텍스트 또는 이미지)
///
/// - `dataUri.data`: `data:image/png;base64,` 접두사를 붙인 data URL (이미지는 리사이저가 항상 PNG로 변환)
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
        'dataUri': {'data': 'data:image/png;base64,$data'},
      };
    }

    return {'type': 'text', 'text': text};
  }
}
