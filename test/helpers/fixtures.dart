import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/address_candidate.dart';

/// 주소 검색 debounce가 끝날 때까지 기다리는 시간
///
/// - `600ms`: 주소 VM의 debounce `500ms`보다 길게 (apply·edit 주소 VM 기준)
const afterDebounce = Duration(milliseconds: 600);

const bundangCandidate = AddressCandidate(
  zipCode: '13561',
  roadAddress: '경기도 성남시 분당구 불정로 6 (정자동)',
  baseRoadAddress: '경기도 성남시 분당구 불정로 6',
  lotAddress: '경기도 성남시 분당구 정자동 178-1',
  sido: '경기도',
  sigungu: '성남시 분당구',
  dongMyeon: '정자동',
);

const gangnamAddress = Address(
  zipCode: '06236',
  roadAddress: '서울 강남구 테헤란로 1',
  lotAddress: '서울특별시 강남구 역삼동 1-1',
  sido: '서울특별시',
  sigungu: '강남구',
  dongMyeon: '역삼동',
  detailAddress: '202호',
  latitude: 37.5006,
  longitude: 127.0364,
);
