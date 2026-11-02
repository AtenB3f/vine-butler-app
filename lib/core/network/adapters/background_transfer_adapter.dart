import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

/// 앱이 백그라운드로 전환 시 OS 전송 요청을 보내는 어댑터
///
/// - `vine_butler/background_transfer`: 네이티브 채널에 구현
/// - OS 전송을 쓸 수 없으면 기본 어댑터로 그대로 전송
class BackgroundTransferAdapter implements HttpClientAdapter {
  BackgroundTransferAdapter([HttpClientAdapter? fallback]) : _fallback = fallback ?? HttpClientAdapter();

  static const _channel = MethodChannel('vine_butler/background_transfer');

  final HttpClientAdapter _fallback;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final body = await _bytes(requestStream);
    final response = await _request(options, body);

    if (response != null) { return response; }

    return _fallback.fetch(options, requestStream == null ? null : Stream.value(body), cancelFuture);
  }

  @override
  void close({bool force = false}) => _fallback.close(force: force);

  /// 네이티브 채널 `request` 호출 함수
  ///
  /// - 인자: `url`, `method`, `headers`, `body`, `connectTimeoutMs`, `receiveTimeoutMs`
  /// - returns: `statusCode`, `headers`, `body`로 만든 응답 (OS 전송을 쓸 수 없으면 `null`)
  /// - 오류 코드 (`PlatformException.code`)
  ///   - `UNAVAILABLE`: OS 전송을 쓸 수 없음 (Android 14 미만, 작업 예약 실패, iOS 본문 없는 요청)
  ///   - `TIMEOUT`: 연결·응답 시간 초과
  ///   - `NETWORK`: 네트워크 오류
  ///   - `STOPPED`: 시스템이 전송 작업을 중지
  Future<ResponseBody?> _request(RequestOptions options, Uint8List body) async {
    try {
      final result = await _channel.invokeMapMethod<String, Object?>('request', {
        'url': options.uri.toString(),
        'method': options.method,
        'headers': {for (final MapEntry(:key, :value) in options.headers.entries) key: '$value'},
        'body': body,
        'connectTimeoutMs': options.connectTimeout?.inMilliseconds,
        'receiveTimeoutMs': options.receiveTimeout?.inMilliseconds,
      });
      final headers = (result?['headers'] as Map<Object?, Object?>?) ?? const {};

      return ResponseBody.fromBytes(
        result?['body'] as Uint8List? ?? Uint8List(0),
        result?['statusCode'] as int? ?? 0,
        headers: {for (final MapEntry(:key, :value) in headers.entries) '$key': ['$value']},
      );
    } on MissingPluginException {
      return null;
    } on PlatformException catch (e) {
      if (e.code == 'UNAVAILABLE') { return null; }
      if (e.code == 'TIMEOUT') { throw DioException(requestOptions: options, type: DioExceptionType.receiveTimeout, message: e.message); }

      throw DioException.connectionError(requestOptions: options, reason: '${e.code}: ${e.message ?? '-'}');
    }
  }

  Future<Uint8List> _bytes(Stream<Uint8List>? stream) async {
    final builder = BytesBuilder(copy: false);

    if (stream != null) {
      await for (final chunk in stream) {
        builder.add(chunk);
      }
    }

    return builder.takeBytes();
  }
}
