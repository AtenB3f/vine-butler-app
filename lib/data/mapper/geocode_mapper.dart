import 'package:vine_butler/data/remote/naver/dto/geocode_response_dto.dart';
import 'package:vine_butler/domain/model/address.dart';

extension GeocodeAddressMapper on GeocodeAddressDto {
  Address toDomain() {
    final buildingName = _element('BUILDING_NAME');
    return Address(
      zipCode: _element('POSTAL_CODE'),
      roadAddress: roadAddress,
      lotAddress: jibunAddress,
      sido: _element('SIDO'),
      sigungu: _element('SIGUGUN'),
      dongMyeon: _element('DONGMYUN'),
      buildingName: buildingName.isEmpty ? null : buildingName,
      latitude: double.tryParse(y) ?? 0,
      longitude: double.tryParse(x) ?? 0,
    );
  }

  String _element(String type) {
    for (final element in addressElements) {
      if (element.types.contains(type)) {
        return element.longName;
      }
    }
    return '';
  }
}
