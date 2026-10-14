import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/data/mapper/geocode_mapper.dart';
import 'package:vine_butler/data/remote/naver/dto/geocode_response_dto.dart';

Map<String, dynamic> _addressJson({
  String typesKey = 'types',
  String postalCode = '13561',
  String buildingName = '네이버그린팩토리',
}) {
  Map<String, dynamic> element(String type, String longName) => {
    typesKey: [type],
    'longName': longName,
    'shortName': longName,
    'code': '',
  };
  return {
    'roadAddress': '경기도 성남시 분당구 불정로 6 NAVER그린팩토리',
    'jibunAddress': '경기도 성남시 분당구 정자동 178-1 NAVER그린팩토리',
    'englishAddress': '6, Buljeong-ro, Bundang-gu, Seongnam-si, Gyeonggi-do, Republic of Korea',
    'addressElements': [
      element('SIDO', '경기도'),
      element('SIGUGUN', '성남시 분당구'),
      element('DONGMYUN', '정자동'),
      element('BUILDING_NAME', buildingName),
      element('POSTAL_CODE', postalCode),
    ],
    'x': '127.1054328',
    'y': '37.3595963',
    'distance': 0.0,
  };
}

void main() {
  test('Geocoding 응답을 Address로 매핑한다', () {
    final dto = GeocodeResponseDto.fromJson({
      'status': 'OK',
      'meta': {'totalCount': 1, 'page': 1, 'count': 1},
      'addresses': [_addressJson()],
      'errorMessage': '',
    });

    final address = dto.addresses.single.toDomain();

    expect(dto.isOk, isTrue);
    expect(dto.totalCount, 1);
    expect(address.roadAddress, '경기도 성남시 분당구 불정로 6 NAVER그린팩토리');
    expect(address.lotAddress, '경기도 성남시 분당구 정자동 178-1 NAVER그린팩토리');
    expect(address.sido, '경기도');
    expect(address.sigungu, '성남시 분당구');
    expect(address.dongMyeon, '정자동');
    expect(address.buildingName, '네이버그린팩토리');
    expect(address.zipCode, '13561');
    expect(address.longitude, 127.1054328);
    expect(address.latitude, 37.3595963);
  });

  test('addressElements의 type 키도 읽는다', () {
    final address = GeocodeAddressDto.fromJson(_addressJson(typesKey: 'type')).toDomain();

    expect(address.sido, '경기도');
    expect(address.zipCode, '13561');
  });

  test('우편번호와 건물명이 비어 있으면 빈 우편번호와 null 건물명이 된다', () {
    final address = GeocodeAddressDto.fromJson(_addressJson(postalCode: '', buildingName: '')).toDomain();

    expect(address.zipCode, '');
    expect(address.buildingName, isNull);
  });
}
