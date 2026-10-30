import 'package:dio/dio.dart';
import 'package:vine_butler/data/mapper/dio_exception_mapper.dart';
import 'package:vine_butler/data/mapper/juso_mapper.dart';
import 'package:vine_butler/data/remote/juso/dto/juso_response_dto.dart';
import 'package:vine_butler/data/remote/juso/juso_api.dart';
import 'package:vine_butler/data/remote/naver/geocode_api.dart';
import 'package:vine_butler/domain/exception/api_exception.dart';
import 'package:vine_butler/domain/model/address_page.dart';
import 'package:vine_butler/domain/repository/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  const AddressRepositoryImpl(this._jusoApi, this._geocodeApi);

  final JusoApi _jusoApi;
  final GeocodeApi _geocodeApi;

  static const _emptyPage = AddressPage(addresses: [], totalCount: 0);

  @override
  Future<AddressPage> search(String query, {int page = 1}) async {
    final keyword = _filterKeyword(query);

    if (keyword.isEmpty) { return _emptyPage; }

    try {
      final response = await _jusoApi.search(keyword: keyword, page: page);

      if (!response.isOk) { return _handleError(response); }

      return AddressPage(
        addresses: [for (final address in response.addresses) address.toDomain()],
        totalCount: response.totalCount,
      );
    } on DioException catch (e) {
      throw e.toDomain();
    }
  }

  @override
  Future<({double latitude, double longitude})?> locate(String roadAddress) async {
    try {
      final response = await _geocodeApi.geocode(query: roadAddress, count: 1);

      if (!response.isOk) { throw ApiException.badRequest(response.errorMessage); }
      if (response.addresses.isEmpty) { return null; }

      final address = response.addresses.first;
      final latitude = double.tryParse(address.y);
      final longitude = double.tryParse(address.x);

      if (latitude == null || longitude == null) { return null; }

      return (latitude: latitude, longitude: longitude);
    } on DioException catch (e) {
      throw e.toDomain();
    }
  }

  static String _filterKeyword(String query) {
    final blockedCharacters = RegExp(r'[%=><\[\]]');
    final sqlKeywords = RegExp(
      r'\b(OR|SELECT|INSERT|DELETE|UPDATE|CREATE|DROP|EXEC|UNION|FETCH|DECLARE|TRUNCATE)\b',
      caseSensitive: false,
    );

    return query.replaceAll(blockedCharacters, '').replaceAll(sqlKeywords, '').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// 도로명주소 API의 errorCode 처리 함수
  ///
  /// - `E0001`: 승인되지 않은 키
  /// - `E0005`: 검색어가 입력되지 않음
  /// - `E0006`: 시도명만으로 검색
  /// - `E0007`: 짧은 시간에 요청이 몰림 (좌표제공 API 문서 기준)
  /// - `E0008`: 검색어가 한 글자
  /// - `E0009`: 숫자만 입력
  /// - `E0010`: 검색어가 너무 김 (한글 40자, 영문·숫자 80자 초과)
  /// - `E0011`: 10자리를 넘는 숫자 포함
  /// - `E0012`: 특수문자와 숫자만 입력
  /// - `E0013`: SQL 예약어 또는 특수문자(`% = > < [ ]`) 포함
  /// - `E0014`: 개발 승인키 기간 만료
  /// - `E0015`: 검색 결과가 9천 건 초과
  /// - `-999`: 시스템 에러
  AddressPage _handleError(JusoResponseDto response) {
    const invalidKeywordCodes = {'E0005', 'E0006', 'E0008', 'E0009', 'E0010', 'E0011', 'E0012', 'E0013', 'E0015'};
    final message = response.errorMessage;

    return switch (response.errorCode) {
      final code when invalidKeywordCodes.contains(code) => _emptyPage,
      'E0001' || 'E0014' => throw ApiException.unauthorized(message),
      'E0007' => throw ApiException.quotaExceeded(message),
      '-999' => throw ApiException.server(message),
      _ => throw ApiException.unknown(message),
    };
  }
}
