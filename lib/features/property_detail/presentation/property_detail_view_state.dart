import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/shared/utils/utils.dart';

class PropertyDetailViewState {
  final PropertyDetailData? data;
  final PropertyDetailStatus status;
  final PropertyDetailEvent? event;
  final String? navigateTo;
  final bool isMapVisible;
  final bool canWrite;

  const PropertyDetailViewState({
    this.data,
    this.status = PropertyDetailStatus.loading,
    this.event,
    this.navigateTo,
    this.isMapVisible = false,
    this.canWrite = false,
  });

  PropertyDetailViewState copyWith({
    PropertyDetailData? data,
    PropertyDetailStatus? status,
    PropertyDetailEvent? Function()? event,
    String? Function()? navigateTo,
    bool? isMapVisible,
    bool? canWrite,
  }) {
    return PropertyDetailViewState(
      data: data ?? this.data,
      status: status ?? this.status,
      event: event != null ? event() : this.event,
      navigateTo: navigateTo != null ? navigateTo() : this.navigateTo,
      isMapVisible: isMapVisible ?? this.isMapVisible,
      canWrite: canWrite ?? this.canWrite,
    );
  }
}

enum PropertyDetailStatus {
  loading,
  loaded,
  notFound,
}

enum PropertyDetailEvent {
  delete,
  failDelete,
}

enum PropertyDetailAction {
  fetch,
  toggleMap,
  delete,
}

class PropertyDetailData {
  final List<String> imagePaths;
  final String unitAddress; // 상세주소
  final String address; // 도로명 or 지번 주소
  final PropertyTransactionType transactionType;
  final int amount; // 보증금 or 매매가
  final int? monthlyAmount; // 월세
  final int? maintenanceCost;  // 관리비
  final double? areaExclusive; // 전용면적
  final int? roomCount; // 방 개수
  final String ownerPhone;  // 집주인 핸드폰 번호
  final String? agentCompany;  // 공인중개사무소
  final String? agentName;  // 공인중개사 이름
  final String? agentPhone; // 공인중개사 핸드폰 번호
  final List<String> vicinity;  // 인근 교통편
  final bool isAvailableParking;  // 주차 가능 여부
  final bool? isAvailableLoan; // 융자 여부
  final bool isAvailableSuretyInsurance; // 보증보험 가입 가능 여부
  final DateTime? moveInDate; // 입주일
  final bool isFlexibleMoveInDate; // 입주일 협의 가능 여부
  final List<String> furnitureOptions;  // 가구 옵션
  final String? memo; // 메모
  final double latitude;
  final double longitude;

  const PropertyDetailData({
    required this.imagePaths,
    required this.unitAddress,
    required this.address,
    required this.transactionType,
    required this.amount,
    this.monthlyAmount,
    this.maintenanceCost,
    this.areaExclusive,
    this.roomCount,
    required this.ownerPhone,
    this.agentCompany,
    this.agentName,
    this.agentPhone,
    required this.vicinity,
    required this.isAvailableParking,
    this.isAvailableLoan,
    required this.isAvailableSuretyInsurance,
    this.moveInDate,
    required this.isFlexibleMoveInDate,
    required this.furnitureOptions,
    this.memo,
    required this.latitude,
    required this.longitude,
  });

  bool get hasImages => imagePaths.isNotEmpty;

  factory PropertyDetailData.fromDomain(Property property, {required String Function(String fileName) imagePath}) {
    final address = property.address;

    return PropertyDetailData(
      imagePaths: [for (final image in property.images) imagePath(image.fileName)],
      unitAddress: lotUnitAddress(address),
      address: [address.sido, address.sigungu].where((part) => part.isNotEmpty).join(' '),
      transactionType: property.deal.transactionType,
      amount: property.deal.price,
      monthlyAmount: property.deal.monthlyRent,
      maintenanceCost: property.maintenanceCost,
      roomCount: property.roomCount,
      ownerPhone: property.owner.phone,
      vicinity: const [],
      isAvailableParking: property.isParkingAvailable == true,
      isAvailableLoan: property.hasLoan,
      isAvailableSuretyInsurance: property.isSuretyInsuranceAvailable == true,
      moveInDate: property.moveInDate,
      isFlexibleMoveInDate: property.isFlexibleMoveInDate,
      furnitureOptions: property.furnitureOptions,
      memo: property.memo.isEmpty ? null : property.memo,
      latitude: address.latitude,
      longitude: address.longitude,
    );
  }
}
