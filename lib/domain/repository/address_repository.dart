import 'package:vine_butler/domain/model/address_page.dart';

abstract class AddressRepository {
  Future<AddressPage> search(String query, {int page = 1});

  Future<({double latitude, double longitude})?> locate(String roadAddress);
}
