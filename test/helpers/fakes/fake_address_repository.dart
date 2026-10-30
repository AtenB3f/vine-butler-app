import 'package:vine_butler/domain/model/address_candidate.dart';
import 'package:vine_butler/domain/model/address_page.dart';
import 'package:vine_butler/domain/repository/address_repository.dart';

class FakeAddressRepository implements AddressRepository {
  FakeAddressRepository({List<AddressCandidate> addresses = const []}) : respond = ((_, _) async => addresses);

  final List<String> queries = [];
  final List<int> pages = [];
  final List<String> locatedAddresses = [];
  int? totalCount;
  Future<List<AddressCandidate>> Function(String query, int page) respond;
  Future<({double latitude, double longitude})?> Function(String roadAddress) respondLocate = (_) async =>
      (latitude: 37.3595033, longitude: 127.105216);

  @override
  Future<AddressPage> search(String query, {int page = 1}) async {
    queries.add(query);
    pages.add(page);
    final addresses = await respond(query, page);

    return AddressPage(addresses: addresses, totalCount: totalCount ?? addresses.length);
  }

  @override
  Future<({double latitude, double longitude})?> locate(String roadAddress) {
    locatedAddresses.add(roadAddress);
    return respondLocate(roadAddress);
  }
}
