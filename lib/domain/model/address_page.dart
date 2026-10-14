import 'package:vine_butler/domain/model/address_candidate.dart';

class AddressPage {
  const AddressPage({required this.addresses, required this.totalCount});

  final List<AddressCandidate> addresses;
  final int totalCount;
}
