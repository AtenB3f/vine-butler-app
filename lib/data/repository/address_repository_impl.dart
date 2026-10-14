import 'package:dio/dio.dart';
import 'package:vine_butler/core/network/api_exception.dart';
import 'package:vine_butler/data/mapper/geocode_mapper.dart';
import 'package:vine_butler/data/remote/naver/geocode_api.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/repository/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  const AddressRepositoryImpl(this._api);

  final GeocodeApi _api;

  @override
  Future<List<Address>> search(String query, {({double latitude, double longitude})? coordinate}) async {
    try {
      final response = await _api.geocode(query: query, coordinate: coordinate);
      if (!response.isOk) {
        throw ApiException.badRequest(response.errorMessage);
      }
      return [for (final address in response.addresses) address.toDomain()];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
