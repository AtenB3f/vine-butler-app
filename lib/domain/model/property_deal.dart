import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vine_butler/domain/property_type.dart';

part 'property_deal.freezed.dart';

@freezed
abstract class PropertyDeal with _$PropertyDeal {
  const factory PropertyDeal({
    required PropertyTransactionType transactionType,
    required int price,
    int? monthlyRent,
  }) = _PropertyDeal;
}
