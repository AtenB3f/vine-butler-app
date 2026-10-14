import 'package:dio/dio.dart';
import 'package:vine_butler/core/network/api_exception.dart';
import 'package:vine_butler/data/mapper/juso_mapper.dart';
import 'package:vine_butler/data/remote/juso/dto/juso_response_dto.dart';
import 'package:vine_butler/data/remote/juso/juso_api.dart';
import 'package:vine_butler/data/remote/naver/geocode_api.dart';
import 'package:vine_butler/domain/model/address_page.dart';
import 'package:vine_butler/domain/repository/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  const AddressRepositoryImpl(this._jusoApi, this._geocodeApi);

  final JusoApi _jusoApi;
  final GeocodeApi _geocodeApi;

  static const _emptyPage = AddressPage(addresses: [], totalCount: 0);
  static const _invalidKeywordCodes = {'E0005', 'E0006', 'E0008', 'E0009', 'E0010', 'E0011', 'E0012', 'E0013', 'E0015'};
  static final _blockedCharacters = RegExp(r'[%=><\[\]]');
  static final _sqlKeywords = RegExp(
    r'\b(OR|SELECT|INSERT|DELETE|UPDATE|CREATE|DROP|EXEC|UNION|FETCH|DECLARE|TRUNCATE)\b',
    caseSensitive: false,
  );

  @override
  Future<AddressPage> search(String query, {int page = 1}) async {
    final keyword = sanitizeKeyword(query);
    if (keyword.isEmpty) {
      return _emptyPage;
    }
    try {
      final response = await _jusoApi.search(keyword: keyword, page: page);
      if (!response.isOk) {
        return _handleError(response);
      }
      return AddressPage(
        addresses: [for (final address in response.addresses) address.toDomain()],
        totalCount: response.totalCount,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<({double latitude, double longitude})?> locate(String roadAddress) async {
    try {
      final response = await _geocodeApi.geocode(query: roadAddress, count: 1);
      if (!response.isOk) {
        throw ApiException.badRequest(response.errorMessage);
      }
      if (response.addresses.isEmpty) {
        return null;
      }
      final address = response.addresses.first;
      final latitude = double.tryParse(address.y);
      final longitude = double.tryParse(address.x);
      if (latitude == null || longitude == null) {
        return null;
      }
      return (latitude: latitude, longitude: longitude);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  static String sanitizeKeyword(String query) {
    return query.replaceAll(_blockedCharacters, '').replaceAll(_sqlKeywords, '').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  AddressPage _handleError(JusoResponseDto response) {
    final message = response.errorMessage;
    return switch (response.errorCode) {
      final code when _invalidKeywordCodes.contains(code) => _emptyPage,
      'E0001' || 'E0014' => throw ApiException.unauthorized(message),
      'E0007' => throw ApiException.quotaExceeded(message),
      '-999' => throw ApiException.server(message),
      _ => throw ApiException.unknown(message),
    };
  }
}
