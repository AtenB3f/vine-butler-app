import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

/// 진행 중인 같은 요청을 하나로 합치는 인터셉터
///
/// - `method + uri(쿼리 포함) + body`를 기준으로 같은 요청을 식별함 (요청마다 달라지는 요청 ID 헤더가 있기 때문에 헤더는 제외)
/// - 같은 요청이 진행 중이면 전송하지 않고 앞선 요청의 응답·오류를 함께 받음
/// - 요청이 끝나면 목록에서 지우므로 응답을 캐시하지 않음
/// - 결과가 같아도 되는 요청에만 사용. 호출마다 데이터가 새로 생겨야 하는 등록 API에는 붙이지 않음
/// - 다른 인터셉터보다 앞에 붙여 합쳐진 요청이 인증·백그라운드 처리까지 가지 않게 함
class InFlightRequestInterceptor extends Interceptor {
  static const _extraKey = 'inFlightRequestKey';

  final _inFlight = <String, Completer<Response<dynamic>>>{};

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final key = _key(options);

    if (key == null) {
      handler.next(options);
      return;
    }

    final inFlight = _inFlight[key];

    if (inFlight != null) {
      try {
        handler.resolve(await inFlight.future);
      } on DioException catch (e) {
        handler.reject(e);
      }
      return;
    }

    _inFlight[key] = Completer<Response<dynamic>>()..future.ignore();
    options.extra[_extraKey] = key;
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _remove(response.requestOptions)?.complete(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _remove(err.requestOptions)?.completeError(err);
    handler.next(err);
  }

  /// 요청을 구분하는 키
  ///
  /// - `null`: JSON으로 바꿀 수 없는 body (합치지 않고 그대로 전송)
  String? _key(RequestOptions options) {
    final body = switch (options.data) {
      null => '',
      final String text => text,
      Map() || List() => jsonEncode(options.data),
      _ => null,
    };

    if (body == null) { return null; }

    return '${options.method} ${options.uri} $body';
  }

  Completer<Response<dynamic>>? _remove(RequestOptions options) => _inFlight.remove(options.extra[_extraKey]);
}
