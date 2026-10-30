import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/blog_post.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/model/property_image.dart';
import 'package:vine_butler/domain/property_type.dart';

part 'property.freezed.dart';

@freezed
abstract class Property with _$Property {
  const Property._();

  const factory Property({
    required String id,
    required Owner owner,
    required PropertyType propertyType,
    required PropertyDeal deal,
    required Address address,
    int? maintenanceCost,
    bool? isSuretyInsuranceAvailable,
    bool? hasLoan,
    bool? isParkingAvailable,
    DateTime? moveInDate,
    @Default(false) bool isFlexibleMoveInDate,
    int? roomCount,
    @Default(<String>[]) List<String> furnitureOptions,
    @Default('') String memo,
    @Default(<PropertyImage>[]) List<PropertyImage> images,
    BlogPost? blogPost,
    required DateTime updatedAt,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) = _Property;

  bool get needsSync => syncedAt == null || updatedAt.isAfter(syncedAt!);
}
