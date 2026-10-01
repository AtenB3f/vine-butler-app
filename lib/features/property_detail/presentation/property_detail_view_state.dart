import 'package:vine_butler/domain/property_type.dart';

class PropertyDetailViewState {
  final PropertyDetailData? data;
  final String? navigateTo;

  const PropertyDetailViewState({this.data, this.navigateTo});
}

enum PropertyDetailAction {
  fetch,
}

class PropertyDetailData {
  final List<String> imageUrls;
  final String unitAddress; // 상세주소
  final String address; // 도로명 or 지번 주소
  final PropertyTransactionType transactionType;
  final int amount; // 보증금 or 매매가
  final int? monthlyAmount; // 월세
  final int? maintenanceCost;  // 관리비
  final double areaExclusive; // 전용면적
  final String ownerPhone;  // 집주인 핸드폰 번호
  final String? agentCompany;  // 공인중개사무소
  final String? agentName;  // 공인중개사 이름
  final String? agentPhone; // 공인중개사 핸드폰 번호
  final List<String> vicinity;  // 인근 교통편
  final bool isAvailableParking;  // 주차 가능 여부 
  final bool isAvailableLoan; // 융자 여부
  final bool isAvailableSuretyInsurance; // 보증보험 가입 가능 여부
  final DateTime? moveInDate; // 입주일
  final bool isAvailableMoveInDate; // 입주일 협의 가능 여부
  final List<String> furnitureOptions;  // 가구 옵션
  final String? memo; // 메모

  const PropertyDetailData({
    required this.imageUrls,
    required this.unitAddress,
    required this.address,
    required this.transactionType,
    required this.amount,
    this.monthlyAmount,
    this.maintenanceCost,
    required this.areaExclusive,
    required this.ownerPhone,
    this.agentCompany,
    this.agentName,
    this.agentPhone,
    required this.vicinity,
    required this.isAvailableParking,
    required this.isAvailableLoan,
    required this.isAvailableSuretyInsurance,
    this.moveInDate,
    required this.isAvailableMoveInDate,
    required this.furnitureOptions,
    this.memo,
  });
}
