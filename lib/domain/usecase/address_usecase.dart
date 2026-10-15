import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/address_candidate.dart';
import 'package:vine_butler/domain/model/address_page.dart';
import 'package:vine_butler/domain/repository/address_repository.dart';

class AddressUseCase {
  const AddressUseCase(this._repository);

  final AddressRepository _repository;

  Future<AddressPage> search(String query, {int page = 1}) async {
    final keyword = query.trim();

    if (keyword.isEmpty) { return const AddressPage(addresses: [], totalCount: 0); }

    return _repository.search(keyword, page: page);
  }

  Future<Address?> locate(AddressCandidate candidate) async {
    final coordinate = await _repository.locate(candidate.baseRoadAddress);

    if (coordinate == null) { return null; }

    return candidate.toAddress(latitude: coordinate.latitude, longitude: coordinate.longitude);
  }
}
