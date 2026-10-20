import 'package:vine_butler/domain/model/address.dart';

/// 읍면동 + 번지 + 상세 주소 (예: `정자동 178-1 202호`)
String lotUnitAddress(Address address) =>
    [_lotNumberAddress(address), address.detailAddress].where((part) => part.isNotEmpty).join(' ');

/// 시/도 + 시/군/구 + 읍면동 + 번지 + 상세 주소 (예: `경기도 성남시 분당구 정자동 178-1 202호`)
String fullLotAddress(Address address) =>
    [address.sido, address.sigungu, lotUnitAddress(address)].where((part) => part.isNotEmpty).join(' ');

/// 지번 주소 -> 읍면동 + 번지
String _lotNumberAddress(Address address) {
  final lotNumber = RegExp(r'^.*?(?:^|\s)(?:산\s?)?\d+(?:-\d+)?(?=\s|$)');
  var rest = address.lotAddress.trim();

  for (final prefix in [address.sido, address.sigungu]) {
    if (prefix.isNotEmpty && rest.startsWith(prefix)) { rest = rest.substring(prefix.length).trim(); }
  }
  return lotNumber.firstMatch(rest)?.group(0)?.trim() ?? rest;
}
