import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:vine_butler/data/mapper/dio_exception_mapper.dart';
import 'package:vine_butler/data/remote/clova/clova_studio_api.dart';
import 'package:vine_butler/data/remote/clova/dto/chat_request_dto.dart';
import 'package:vine_butler/data/remote/clova/prompts/blog_prompt.dart';
import 'package:vine_butler/domain/exception/api_exception.dart';
import 'package:vine_butler/domain/model/blog_post.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/repository/blog_repository.dart';
import 'package:vine_butler/domain/repository/image_storage.dart';

/// 원본 사진을 전송용 PNG로 바꾸는 함수 (전송할 수 없는 사진이면 null)
typedef ImageResizer = Future<Uint8List?> Function(Uint8List bytes);

class BlogRepositoryImpl implements BlogRepository {
  const BlogRepositoryImpl(this._api, this._imageStorage, this._buildPrompt, [this._resize = _resizeToPng]);

  final ClovaStudioApi _api;
  final ImageStorage _imageStorage;
  final BlogPromptBuilder _buildPrompt;
  final ImageResizer _resize;

  /// 블로그 글 생성 요청 설정
  ///
  /// - `maxTokens`: 출력 토큰 최대값 (HCX-005 한도 4096)
  /// - `temperature`: 응답 다양성 (0.00 ~ 1.00)
  /// - `topP`: 누적 확률 상위 후보만 사용 (0.00 초과 ~ 1.00)
  /// - `topK`: 확률 상위 K개 후보만 사용 (0 ~ 128)
  /// - `repetitionPenalty`: 같은 표현 반복 억제 (0.0 초과 ~ 2.0)
  @override
  Future<BlogPost> write(Property property) async {
    const maxTokens = 800;
    const temperature = 0.6;
    const topP = 0.4;
    const topK = 0;
    const repetitionPenalty = 1.1;
    final prompt = _buildPrompt(property);
    final images = await _images(property);
    final request = ChatRequestDto(
      maxTokens: maxTokens,
      temperature: temperature,
      topP: topP,
      topK: topK,
      repetitionPenalty: repetitionPenalty,
      messages: [
        ChatMessageDto(role: ChatRole.system, contents: [ChatContentDto.text(prompt.system)]),
        ..._conversation(images, prompt),
      ],
    );

    try {
      final response = await _api.chatCompletions(request);

      if (!response.isOk) { throw ApiException.badRequest(response.message); }

      return prompt.parse(response.content).copyWith(isTruncated: response.isTruncated);
    } on DioException catch (e) {
      throw e.toDomain();
    }
  }

  /// 사진과 작성 요청을 user/assistant 교대로 구성한 대화 (user 메시지당 이미지 1개)
  ///
  /// - 사진 사이에는 assistant 응답을 넣어 user 메시지가 연속되지 않게 함
  /// - 마지막 user 메시지에는 마지막 사진과 작성 요청(`request`)을 함께 넣음
  List<ChatMessageDto> _conversation(List<String> images, BlogPrompt prompt) {
    final messages = <ChatMessageDto>[];

    for (final (index, image) in images.indexed) {
      final number = index + 1;
      final isLast = number == images.length;

      messages.add(
        ChatMessageDto(
          role: ChatRole.user,
          contents: [
            ChatContentDto.image(image),
            ChatContentDto.text(isLast ? prompt.request : prompt.imageCaption(number)),
          ],
        ),
      );

      if (!isLast) { messages.add(ChatMessageDto(role: ChatRole.assistant, contents: [ChatContentDto.text(prompt.imageReply(number))])); }
    }

    if (images.isEmpty) { messages.add(ChatMessageDto(role: ChatRole.user, contents: [ChatContentDto.text(prompt.request)])); }

    return messages;
  }

  /// 전송할 사진의 base64 PNG 목록 (order 순서, 요청당 최대 5개 제한)
  Future<List<String>> _images(Property property) async {
    const maxImageCount = 5;
    final images = [...property.images]..sort((a, b) => a.order.compareTo(b.order));
    final encoded = <String>[];

    for (final image in images) {
      if (encoded.length == maxImageCount) { break; }

      final Uint8List bytes;

      try {
        bytes = await File(_imageStorage.path(image.fileName)).readAsBytes();
      } on FileSystemException {
        continue;
      }

      final png = await _resize(bytes);

      if (png == null) { continue; }

      encoded.add(base64Encode(png));
    }
    return encoded;
  }
}

/// 사진을 HCX-005 이미지 규격에 맞춘 PNG로 변환하는 함수
///
/// - `maxLength`: 긴 변 1024px로 축소 (API 한도 2240px)
/// - `maxRatio`: 가로세로 비율 5:1 초과 사진은 전송 불가 (API 규격)
/// - `minLength`: 축소 후 짧은 변이 4px 미만이면 전송 불가 (API 규격)
Future<Uint8List?> _resizeToPng(Uint8List bytes) async {
  const maxLength = 1024;
  const maxRatio = 5;
  const minLength = 4;

  try {
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final longSide = math.max(descriptor.width, descriptor.height);
    final shortSide = math.min(descriptor.width, descriptor.height);
    final scale = math.min(1.0, maxLength / longSide);

    if (shortSide == 0 || longSide / shortSide > maxRatio || shortSide * scale < minLength) {
      descriptor.dispose();
      buffer.dispose();
      return null;
    }

    final codec = await descriptor.instantiateCodec(
      targetWidth: (descriptor.width * scale).round(),
      targetHeight: (descriptor.height * scale).round(),
    );
    final frame = await codec.getNextFrame();
    final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);

    frame.image.dispose();
    codec.dispose();
    descriptor.dispose();
    buffer.dispose();
    return data?.buffer.asUint8List();
  } on Exception {
    return null;
  }
}
