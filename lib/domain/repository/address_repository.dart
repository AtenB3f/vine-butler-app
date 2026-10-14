import 'package:vine_butler/domain/model/address.dart';

abstract class AddressRepository {
  Future<List<Address>> search(String query, {({double latitude, double longitude})? coordinate});
}
