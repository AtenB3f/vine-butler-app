import 'package:vine_butler/domain/property_type.dart';

class PropertyListItemViewState {
  final int id;
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
}
