import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/core/network/adapters/background_transfer_adapter.dart';

class _FallbackAdapter implements HttpClientAdapter {
  final List<Uint8List> bodies = [];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    bodies.add(Uint8List.fromList([...?await requestStream?.expand((chunk) => chunk).toList()]));
    return ResponseBody.fromString(
      jsonEncode({'from': 'fallback'}),
      200,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('vine_butler/background_transfer');
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late _FallbackAdapter fallback;
  late Dio dio;
  late List<MethodCall> calls;

  void mockChannel(Future<Object?> Function(MethodCall call) handler) {
    messenger.setMockMethodCallHandler(channel, (call) {
      calls.add(call);
      return handler(call);
    });
  }

  setUp(() {
    calls = [];
    fallback = _FallbackAdapter();
    dio = Dio(BaseOptions(baseUrl: 'https://example.com', receiveTimeout: const Duration(seconds: 180)))
      ..httpClientAdapter = BackgroundTransferAdapter(fallback);
  });

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('네이티브 응답을 Dio 응답으로 바꾸고 요청 정보를 그대로 넘긴다', () async {
    mockChannel((_) async => {
      'statusCode': 200,
      'headers': {'content-type': 'application/json'},
      'body': Uint8List.fromList(utf8.encode(jsonEncode({'from': 'native'}))),
    });

    final response = await dio.post<Map<String, dynamic>>('/chat', data: {'text': '안녕'});
    final arguments = calls.single.arguments as Map<Object?, Object?>;

    expect(response.data, {'from': 'native'});
    expect(arguments['url'], 'https://example.com/chat');
    expect(arguments['method'], 'POST');
    expect(utf8.decode(arguments['body']! as Uint8List), jsonEncode({'text': '안녕'}));
    expect(arguments['receiveTimeoutMs'], 180000);
    expect(fallback.bodies, isEmpty);
  });

  test('UNAVAILABLE이면 같은 본문으로 기본 어댑터를 통해 전송한다', () async {
    mockChannel((_) async => throw PlatformException(code: 'UNAVAILABLE'));

    final response = await dio.post<Map<String, dynamic>>('/chat', data: {'text': '안녕'});

    expect(response.data, {'from': 'fallback'});
    expect(utf8.decode(fallback.bodies.single), jsonEncode({'text': '안녕'}));
  });

  test('채널이 없는 플랫폼이면 기본 어댑터를 통해 전송한다', () async {
    final response = await dio.post<Map<String, dynamic>>('/chat', data: {'text': '안녕'});

    expect(response.data, {'from': 'fallback'});
  });

  test('TIMEOUT이면 receiveTimeout 오류를 던진다', () async {
    mockChannel((_) async => throw PlatformException(code: 'TIMEOUT'));

    await expectLater(
      dio.post<void>('/chat', data: {'text': '안녕'}),
      throwsA(isA<DioException>().having((e) => e.type, 'type', DioExceptionType.receiveTimeout)),
    );
  });

  test('NETWORK·STOPPED이면 connectionError 오류를 던진다', () async {
    for (final code in ['NETWORK', 'STOPPED']) {
      mockChannel((_) async => throw PlatformException(code: code));

      await expectLater(
        dio.post<void>('/chat', data: {'text': '안녕'}),
        throwsA(isA<DioException>().having((e) => e.type, 'type', DioExceptionType.connectionError)),
      );
    }
  });
}
