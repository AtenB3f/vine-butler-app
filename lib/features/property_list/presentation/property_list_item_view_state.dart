import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/shared/utils/utils.dart';

class PropertyListItemViewState {
  final String id;
  final int amount;
  final int? monthlyAmount;
  final String address;
  final PropertyTransactionType transactionType;
  final PropertyType propertyType;
  final List<String> tag;

  PropertyListItemViewState({
    required this.id,
    required this.amount,
    this.monthlyAmount,
    required this.address,
    required this.transactionType,
    required this.propertyType,
    required this.tag,
  });

  factory PropertyListItemViewState.fromDomain(Property property) {
    final roomCount = property.roomCount;

    return PropertyListItemViewState(
      id: property.id,
      amount: property.deal.price,
      monthlyAmount: property.deal.monthlyRent,
      address: fullLotAddress(property.address),
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
