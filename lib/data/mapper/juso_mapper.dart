import 'package:vine_butler/data/remote/juso/dto/juso_response_dto.dart';
import 'package:vine_butler/domain/model/address_candidate.dart';

extension JusoAddressMapper on JusoAddressDto {
  AddressCandidate toDomain() {
    return AddressCandidate(
      zipCode: zipNo,
      roadAddress: roadAddr,
      baseRoadAddress: roadAddrPart1,
      lotAddress: jibunAddr,
      sido: siNm,
      sigungu: sggNm,
      dongMyeon: emdNm,
      buildingName: bdNm.isEmpty ? null : bdNm,
    );
  }
}
