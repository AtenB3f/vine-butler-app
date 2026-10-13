import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';

@freezed
abstract class Address with _$Address {
  const factory Address({
    required String zipCode,
    required String roadAddress,
    required String lotAddress,
    required String sido,
    required String sigungu,
    required String dongMyeon,
    String? buildingName,
    required double latitude,
    required double longitude,
  }) = _Address;
}
