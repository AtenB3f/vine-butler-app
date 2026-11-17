import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vine_butler/data/remote/clova/dto/chat_request_dto.dart';
import 'package:vine_butler/data/remote/clova/dto/chat_response_dto.dart';

class ClovaStudioApi {
  const ClovaStudioApi(this._dio);

  final Dio _dio;

  Future<ChatResponseDto> chatCompletions(ChatRequestDto request) async {
    const path = '/v3/chat-completions/HCX-005';
    final startedAt = DateTime.now();

    if (kDebugMode) { debugPrint('[API] → POST $path $startedAt messages: ${request.messages.length}, images: ${request.imageCount}'); }

    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: request.toJson());

      if (kDebugMode) { debugPrint('[API] ← ${response.statusCode} $path ${_finished(startedAt)} ${response.data}'); }

      return ChatResponseDto.fromJson(response.data ?? const {});
    } on DioException catch (e) {
      if (kDebugMode) { debugPrint('[API] ✗ ${e.response?.statusCode ?? e.type.name} $path ${_finished(startedAt)} ${e.response?.data ?? e.message}'); }

      rethrow;
    }
  }

  String _finished(DateTime startedAt) {
    final finishedAt = DateTime.now();

    return '$finishedAt (${finishedAt.difference(startedAt).inMilliseconds}ms)';
  }
}
