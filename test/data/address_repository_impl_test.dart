import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/core/network/api_exception.dart';
import 'package:vine_butler/core/network/dio_factory.dart';
import 'package:vine_butler/data/remote/naver/geocode_api.dart';
import 'package:vine_butler/data/repository/address_repository_impl.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._respond);

  final ResponseBody Function(RequestOptions options) _respond;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return _respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, int statusCode) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

const _okBody = {
  'status': 'OK',
  'meta': {'totalCount': 1, 'page': 1, 'count': 1},
  'addresses': [
    {
      'roadAddress': '경기도 성남시 분당구 불정로 6',
      'jibunAddress': '경기도 성남시 분당구 정자동 178-1',
      'addressElements': [
        {
          'types': ['SIDO'],
          'longName': '경기도',
        },
      ],
      'x': '127.1054328',
      'y': '37.3595963',
    },
  ],
  'errorMessage': '',
};

void main() {
  late _FakeAdapter adapter;

  AddressRepositoryImpl repository(ResponseBody Function(RequestOptions options) respond) {
    adapter = _FakeAdapter(respond);
    final dio = createNaverMapsDio(clientId: 'id', clientSecret: 'secret')..httpClientAdapter = adapter;
    return AddressRepositoryImpl(GeocodeApi(dio));
  }

  test('Geocoding 경로, 쿼리, 인증 헤더로 요청한다', () async {
    await repository((_) => _json(_okBody, 200)).search('불정로 6');

    final request = adapter.lastRequest!;
    expect(request.uri.toString(), startsWith('https://maps.apigw.ntruss.com/map-geocode/v2/geocode'));
    expect(request.queryParameters['query'], '불정로 6');
    expect(request.headers['x-ncp-apigw-api-key-id'], 'id');
    expect(request.headers['x-ncp-apigw-api-key'], 'secret');
    expect(request.headers['Accept'], 'application/json');
  });

  test('coordinate는 경도,위도 순서로 보내고 없으면 생략한다', () async {
    adapter = _FakeAdapter((_) => _json(_okBody, 200));
    final api = GeocodeApi(createNaverMapsDio(clientId: 'id', clientSecret: 'secret')..httpClientAdapter = adapter);

    await api.geocode(query: '불정로 6', coordinate: (latitude: 37.3595963, longitude: 127.1054328));
    expect(adapter.lastRequest!.queryParameters['coordinate'], '127.1054328,37.3595963');

    await api.geocode(query: '불정로 6');
    expect(adapter.lastRequest!.queryParameters.containsKey('coordinate'), isFalse);
  });

  test('search에 넘긴 coordinate가 요청에 포함된다', () async {
    await repository((_) => _json(_okBody, 200)).search(
      '불정로 6',
      coordinate: (latitude: 37.3595963, longitude: 127.1054328),
    );

    expect(adapter.lastRequest!.queryParameters['coordinate'], '127.1054328,37.3595963');
  });

  test('성공 응답은 Address 목록으로 반환한다', () async {
    final result = await repository((_) => _json(_okBody, 200)).search('불정로 6');

    expect(result.single.roadAddress, '경기도 성남시 분당구 불정로 6');
    expect(result.single.sido, '경기도');
    expect(result.single.latitude, 37.3595963);
  });

  test('status가 OK가 아니면 badRequest를 던진다', () async {
    final repo = repository((_) => _json({'status': 'INVALID_REQUEST', 'errorMessage': 'query is invalid'}, 200));

    await expectLater(repo.search('x'), throwsA(isA<BadRequestApiException>()));
  });

  for (final (statusCode, matcher) in [
    (400, isA<BadRequestApiException>()),
    (401, isA<UnauthorizedApiException>()),
    (429, isA<QuotaExceededApiException>()),
    (500, isA<ServerApiException>()),
    (504, isA<ServerApiException>()),
  ]) {
    test('HTTP $statusCode는 대응하는 ApiException으로 변환한다', () async {
      final repo = repository(
        (_) => _json({
          'error': {'errorCode': '000', 'message': 'error'},
        }, statusCode),
      );

      await expectLater(repo.search('x'), throwsA(matcher));
    });
  }

  test('타임아웃은 network 예외로 변환한다', () async {
    final repo = repository(
      (options) => throw DioException.connectionTimeout(timeout: const Duration(seconds: 10), requestOptions: options),
    );

    await expectLater(repo.search('x'), throwsA(isA<NetworkApiException>()));
  });
}
