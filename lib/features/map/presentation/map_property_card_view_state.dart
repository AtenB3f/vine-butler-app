import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/property_type.dart';

class MapPropertyCardViewState {
  final String id;
  final String address;
  final PropertyTransactionType transactionType;
  final int amount;
  final int? monthlyAmount;

  const MapPropertyCardViewState({
    required this.id,
    required this.address,
    required this.transactionType,
    required this.amount,
    this.monthlyAmount,
  });

  factory MapPropertyCardViewState.fromDomain(Property property) {
    final address = property.address;
    final lotAddress = address.lotAddress.trim();
    final withoutSido = address.sido.isNotEmpty && lotAddress.startsWith(address.sido)
        ? lotAddress.substring(address.sido.length).trim()
        : lotAddress;

    return MapPropertyCardViewState(
      id: property.id,
      address: [withoutSido, address.detailAddress].where((part) => part.isNotEmpty).join(' '),
      transactionType: property.deal.transactionType,
      amount: property.deal.price,
      monthlyAmount: property.deal.monthlyRent,
    );
  }
}
