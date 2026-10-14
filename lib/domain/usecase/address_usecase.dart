import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/repository/address_repository.dart';

class AddressUseCase {
  const AddressUseCase(this._repository);

  final AddressRepository _repository;

  Future<List<Address>> search(String query, {({double latitude, double longitude})? coordinate}) async {
    final keyword = query.trim();
    if (keyword.isEmpty) {
      return const [];
    }
    return _repository.search(keyword, coordinate: coordinate);
  }
}
