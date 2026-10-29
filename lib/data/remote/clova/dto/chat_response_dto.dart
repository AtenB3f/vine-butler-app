class ChatResponseDto {
  const ChatResponseDto({
    required this.code,
    required this.message,
    required this.content,
    this.finishReason,
    this.totalTokens,
  });

  factory ChatResponseDto.fromJson(Map<String, dynamic> json) {
    final status = json['status'] as Map<String, dynamic>?;
    final result = json['result'] as Map<String, dynamic>?;
    final message = result?['message'] as Map<String, dynamic>?;
    final usage = result?['usage'] as Map<String, dynamic>?;

    return ChatResponseDto(
      code: status?['code'] as String? ?? '',
      message: status?['message'] as String? ?? '',
      content: message?['content'] as String? ?? '',
      finishReason: result?['finishReason'] as String?,
      totalTokens: (usage?['totalTokens'] as num?)?.toInt(),
    );
  }

  final String code;
  final String message;
  final String content;
  final String? finishReason;
  final int? totalTokens;

  /// CLOVA Studio 응답 상태 코드
  ///
  /// - `20000`: 성공
  bool get isOk => code == '20000';

  /// 출력 토큰 한도로 생성이 중단되었는지 여부
  ///
  /// - `length`: 길이 제한
  /// - `stop`: stop 문자 출현
  bool get isTruncated => finishReason == 'length';
}
