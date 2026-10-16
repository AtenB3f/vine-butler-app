import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/property_type.dart';

class PropertyListItemViewState {
  final String id;
  final int amount;
  final int? monthlyAmount;
  final String roadAddress;
  final String jibunAddress;
  final PropertyTransactionType transactionType;
  final PropertyType propertyType;
  final List<String> tag;

  PropertyListItemViewState({
    required this.id,
    required this.amount,
    this.monthlyAmount,
    required this.roadAddress,
    required this.jibunAddress,
    required this.transactionType,
    required this.propertyType,
    required this.tag,
  });

  factory PropertyListItemViewState.fromDomain(Property property) {
    final address = property.address;
    final roomCount = property.roomCount;

    return PropertyListItemViewState(
      id: property.id,
      amount: property.deal.price,
      monthlyAmount: property.deal.monthlyRent,
      roadAddress: address.detailAddress.isEmpty ? address.roadAddress : '${address.roadAddress}, ${address.detailAddress}',
      jibunAddress: address.lotAddress,
      transactionType: property.deal.transactionType,
      propertyType: property.propertyType,
      tag: [
        if (roomCount != null) '방 $roomCount개',
        if (property.isParkingAvailable == true) '주차가능',
        if (property.isSuretyInsuranceAvailable == true) '보증보험가입',
      ],
    );
  }
}
