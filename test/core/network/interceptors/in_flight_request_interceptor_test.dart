import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/core/network/interceptors/in_flight_request_interceptor.dart';

class _CountingAdapter implements HttpClientAdapter {
  int fetchCount = 0;
  int statusCode = 200;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    fetchCount++;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return ResponseBody.fromString(
      jsonEncode({'count': fetchCount}),
      statusCode,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _CountingAdapter adapter;
  late Dio dio;

  setUp(() {
    adapter = _CountingAdapter();
    dio = Dio(BaseOptions(baseUrl: 'https://example.com'))
      ..httpClientAdapter = adapter
      ..interceptors.add(InFlightRequestInterceptor());
  });

  test('같은 요청이 진행 중이면 한 번만 전송하고 같은 응답을 돌려준다', () async {
    final responses = await Future.wait([
      dio.post<Map<String, dynamic>>('/chat', data: {'text': '안녕'}),
      dio.post<Map<String, dynamic>>('/chat', data: {'text': '안녕'}),
    ]);

    expect(adapter.fetchCount, 1);
    expect(responses.first.data, responses.last.data);
  });

  test('앞선 요청이 끝난 뒤 같은 요청은 다시 전송한다', () async {
    await dio.post<void>('/chat', data: {'text': '안녕'});
    await dio.post<void>('/chat', data: {'text': '안녕'});

    expect(adapter.fetchCount, 2);
  });

  test('body나 쿼리가 다르면 각각 전송한다', () async {
    await Future.wait([
      dio.post<void>('/chat', data: {'text': '안녕'}),
      dio.post<void>('/chat', data: {'text': '반가워'}),
      dio.get<void>('/search', queryParameters: {'keyword': '역삼동'}),
      dio.get<void>('/search', queryParameters: {'keyword': '삼성동'}),
    ]);

    expect(adapter.fetchCount, 4);
  });

  test('요청이 실패하면 함께 기다린 요청도 같은 오류를 받는다', () async {
    adapter.statusCode = 500;

    final results = await Future.wait([
      for (var i = 0; i < 2; i++) dio.post<void>('/chat', data: {'text': '안녕'}).then<Object>((response) => response, onError: (Object error) => error),
    ]);

    expect(adapter.fetchCount, 1);
    expect(results, everyElement(isA<DioException>()));
  });
}
