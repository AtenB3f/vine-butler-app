import 'package:vine_butler/domain/model/address.dart';

class AddressCandidate {
  const AddressCandidate({
    required this.zipCode,
    required this.roadAddress,
    required this.baseRoadAddress,
    required this.lotAddress,
    required this.sido,
    required this.sigungu,
    required this.dongMyeon,
  });

  final String zipCode;
  final String roadAddress;
  final String baseRoadAddress;
  final String lotAddress;
  final String sido;
  final String sigungu;
  final String dongMyeon;

  Address toAddress({required double latitude, required double longitude}) {
    return Address(
      zipCode: zipCode,
      roadAddress: roadAddress,
      lotAddress: lotAddress,
      sido: sido,
      sigungu: sigungu,
      dongMyeon: dongMyeon,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
