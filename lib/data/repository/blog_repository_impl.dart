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

  /// HCX-005 요청 제한
  ///
  /// - `maxTokens`: 출력 토큰 최대값 4096
  @override
  Future<BlogPost> write(Property property) async {
    const maxTokens = 4096;
    final prompt = _buildPrompt(property);
    final imageMessages = await _imageMessages(property, prompt);
    final request = ChatRequestDto(
      maxTokens: maxTokens,
      messages: [
        ChatMessageDto(role: ChatRole.system, contents: [ChatContentDto.text(prompt.system)]),
        ...imageMessages,
        ChatMessageDto(role: ChatRole.user, contents: [ChatContentDto.text(prompt.request)]),
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

  /// 사진 메시지 목록 (턴당 이미지 1개, 요청당 최대 5개 제한)
  Future<List<ChatMessageDto>> _imageMessages(Property property, BlogPrompt prompt) async {
    const maxImageCount = 5;
    final images = [...property.images]..sort((a, b) => a.order.compareTo(b.order));
    final messages = <ChatMessageDto>[];

    for (final image in images) {
      if (messages.length == maxImageCount) { break; }

      final Uint8List bytes;

      try {
        bytes = await File(_imageStorage.path(image.fileName)).readAsBytes();
      } on FileSystemException {
        continue;
      }

      final png = await _resize(bytes);

      if (png == null) { continue; }

      messages.add(
        ChatMessageDto(
          role: ChatRole.user,
          contents: [
            ChatContentDto.image(base64Encode(png)),
            ChatContentDto.text(prompt.imageCaption(messages.length + 1)),
          ],
        ),
      );
    }
    return messages;
  }
}

/// 사진을 HCX-005 이미지 규격에 맞춘 PNG로 변환하는 함수
///
/// - `maxLength`: 긴 변 1024px로 축소 (API 한도 2240px)
/// - `maxRatio`: 가로세로 비율 5:1 초과 사진은 전송 불가 (API 규격)
Future<Uint8List?> _resizeToPng(Uint8List bytes) async {
  const maxLength = 1024;
  const maxRatio = 5;

  try {
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final longSide = math.max(descriptor.width, descriptor.height);
    final shortSide = math.min(descriptor.width, descriptor.height);

    if (shortSide == 0 || longSide / shortSide > maxRatio) {
      descriptor.dispose();
      buffer.dispose();
      return null;
    }

    final scale = math.min(1.0, maxLength / longSide);
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
