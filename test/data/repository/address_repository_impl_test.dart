import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/core/network/dio_factory.dart';
import 'package:vine_butler/data/remote/juso/juso_api.dart';
import 'package:vine_butler/data/remote/naver/geocode_api.dart';
import 'package:vine_butler/data/repository/address_repository_impl.dart';
import 'package:vine_butler/domain/exception/api_exception.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._respond);

  final ResponseBody Function(RequestOptions options) _respond;
  final List<RequestOptions> requests = [];

  RequestOptions get lastRequest => requests.last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return _respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, [int statusCode = 200]) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

Map<String, dynamic> _jusoBody({String errorCode = '0', String totalCount = '1', List<Object>? juso}) {
  return {
    'results': {
      'common': {
        'countPerPage': '10',
        'errorMessage': errorCode == '0' ? '정상' : 'error',
        'errorCode': errorCode,
        'totalCount': totalCount,
        'currentPage': '1',
      },
      'juso': errorCode == '0' ? (juso ?? [_jusoItem]) : null,
    },
  };
}

const _jusoItem = {
  'siNm': '경기도',
  'sggNm': '성남시 분당구',
  'emdNm': '정자동',
  'roadAddr': '경기도 성남시 분당구 불정로 6 (정자동)',
  'roadAddrPart1': '경기도 성남시 분당구 불정로 6',
  'roadAddrPart2': ' (정자동)',
  'jibunAddr': '경기도 성남시 분당구 정자동 178-1 NAVER그린팩토리',
  'zipNo': '13561',
  'bdNm': 'NAVER그린팩토리',
  'admCd': '4113510300',
  'rnMgtSn': '411353180007',
  'udrtYn': '0',
  'buldMnnm': '6',
  'buldSlno': '0',
};

Map<String, dynamic> _geocodeBody({List<Object>? addresses}) {
  return {
    'status': 'OK',
    'meta': {'totalCount': addresses?.length ?? 1, 'page': 1, 'count': addresses?.length ?? 1},
    'addresses':
        addresses ??
        [
          {
            'roadAddress': '경기도 성남시 분당구 불정로 6',
            'jibunAddress': '',
            'addressElements': [],
            'x': '127.105216',
            'y': '37.3595033',
          },
        ],
    'errorMessage': '',
  };
}

void main() {
  late _FakeAdapter jusoAdapter;
  late _FakeAdapter naverAdapter;

  AddressRepositoryImpl repository({
    ResponseBody Function(RequestOptions options)? juso,
    ResponseBody Function(RequestOptions options)? naver,
  }) {
    jusoAdapter = _FakeAdapter(juso ?? (_) => _json(_jusoBody()));
    naverAdapter = _FakeAdapter(naver ?? (_) => _json(_geocodeBody()));
    return AddressRepositoryImpl(
      JusoApi(createJusoDio(confmKey: 'juso-key')..httpClientAdapter = jusoAdapter),
      GeocodeApi(createNaverMapsDio(clientId: 'id', clientSecret: 'secret')..httpClientAdapter = naverAdapter),
    );
  }

  group('search', () {
    test('도로명주소 검색 경로와 승인키, 검색어, 페이지로 요청한다', () async {
      await repository().search('불정로 6', page: 3);

      final request = jusoAdapter.lastRequest;

      expect(request.uri.toString(), startsWith('https://business.juso.go.kr/addrlink/addrLinkApi.do'));
      expect(request.queryParameters['confmKey'], 'juso-key');
      expect(request.queryParameters['resultType'], 'json');
      expect(request.queryParameters['keyword'], '불정로 6');
      expect(request.queryParameters['currentPage'], 3);
      expect(request.queryParameters['countPerPage'], 10);
    });

    test('응답을 AddressCandidate로 매핑하고 문자열 totalCount를 숫자로 읽는다', () async {
      final result = await repository(juso: (_) => _json(_jusoBody(totalCount: '25'))).search('불정로 6');

      final candidate = result.addresses.single;

      expect(result.totalCount, 25);
      expect(candidate.zipCode, '13561');
      expect(candidate.roadAddress, '경기도 성남시 분당구 불정로 6 (정자동)');
      expect(candidate.baseRoadAddress, '경기도 성남시 분당구 불정로 6');
      expect(candidate.lotAddress, '경기도 성남시 분당구 정자동 178-1 NAVER그린팩토리');
      expect(candidate.sido, '경기도');
      expect(candidate.sigungu, '성남시 분당구');
      expect(candidate.dongMyeon, '정자동');
    });

    for (final code in ['E0005', 'E0006', 'E0008', 'E0009', 'E0010', 'E0011', 'E0012', 'E0013', 'E0015']) {
      test('검색어 오류 $code는 빈 결과로 돌려준다', () async {
        final result = await repository(
          juso: (_) => _json(_jusoBody(errorCode: code, totalCount: '0')),
        ).search('불');

        expect(result.addresses, isEmpty);
        expect(result.totalCount, 0);
      });
    }

    for (final (code, matcher) in [
      ('E0001', isA<UnauthorizedApiException>()),
      ('E0014', isA<UnauthorizedApiException>()),
      ('E0007', isA<QuotaExceededApiException>()),
      ('-999', isA<ServerApiException>()),
      ('E9999', isA<UnknownApiException>()),
    ]) {
      test('오류 코드 $code는 대응하는 ApiException을 던진다', () async {
        final repo = repository(
          juso: (_) => _json(_jusoBody(errorCode: code, totalCount: '0')),
        );

        await expectLater(repo.search('불정로 6'), throwsA(matcher));
      });
    }

    test('HTTP 오류는 ApiException으로 변환한다', () async {
      final repo = repository(juso: (_) => _json({}, 503));

      await expectLater(repo.search('불정로 6'), throwsA(isA<ServerApiException>()));
    });

    test('차단 대상 특수문자와 SQL 예약어 단어를 지우고 요청한다', () async {
      await repository().search('불정로 6 OR 1=1 [select] 100%');

      expect(jusoAdapter.lastRequest.queryParameters['keyword'], '불정로 6 11 100');
    });

    test('예약어가 다른 단어의 일부이면 지우지 않는다', () async {
      await repository().search('Orchard 로');

      expect(jusoAdapter.lastRequest.queryParameters['keyword'], 'Orchard 로');
    });

    test('정리 후 검색어가 비면 요청하지 않는다', () async {
      final result = await repository().search('<>%');

      expect(result.addresses, isEmpty);
      expect(jusoAdapter.requests, isEmpty);
    });
  });

  group('locate', () {
    test('네이버 Geocoding 첫 결과의 좌표를 돌려준다', () async {
      final coordinate = await repository().locate('경기도 성남시 분당구 불정로 6');

      expect(coordinate, (latitude: 37.3595033, longitude: 127.105216));
      expect(naverAdapter.lastRequest.queryParameters['query'], '경기도 성남시 분당구 불정로 6');
      expect(naverAdapter.lastRequest.queryParameters['count'], 1);
    });

    test('결과가 없으면 null이다', () async {
      final coordinate = await repository(naver: (_) => _json(_geocodeBody(addresses: []))).locate('없는 주소');

      expect(coordinate, isNull);
    });

    test('네이버 인증 실패는 unauthorized로 변환한다', () async {
      final repo = repository(
        naver: (_) => _json({
          'error': {'errorCode': '200', 'message': 'Authentication Failed'},
        }, 401),
      );

      await expectLater(repo.locate('경기도 성남시 분당구 불정로 6'), throwsA(isA<UnauthorizedApiException>()));
    });

    test('네이버 status가 OK가 아니면 badRequest를 던진다', () async {
      final repo = repository(naver: (_) => _json({'status': 'INVALID_REQUEST', 'errorMessage': 'query is INVALID'}));

      await expectLater(repo.locate(''), throwsA(isA<BadRequestApiException>()));
    });
  });
}
