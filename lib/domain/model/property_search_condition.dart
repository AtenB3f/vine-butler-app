import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vine_butler/domain/property_type.dart';

part 'property_search_condition.freezed.dart';

@freezed
abstract class PropertySearchCondition with _$PropertySearchCondition {
  const factory PropertySearchCondition({
    PropertyTransactionType? transactionType,
    @Default({}) Set<PropertyType> propertyTypes,
    int? price,
    @Default('') String keyword,
  }) = _PropertySearchCondition;
}
