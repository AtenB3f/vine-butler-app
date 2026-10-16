// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Property {

 String get id; Owner get owner; PropertyType get propertyType; PropertyDeal get deal; Address get address; int? get maintenanceCost; bool? get isSuretyInsuranceAvailable; bool? get hasLoan; bool? get isParkingAvailable; DateTime? get moveInDate; bool get isFlexibleMoveInDate; int? get roomCount; List<String> get furnitureOptions; String get memo; List<PropertyImage> get images; DateTime get updatedAt; DateTime? get deletedAt; DateTime? get syncedAt;
/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyCopyWith<Property> get copyWith => _$PropertyCopyWithImpl<Property>(this as Property, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Property;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Property&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.owner, _this.owner) || other.owner == _this.owner)&&(identical(other.propertyType, _this.propertyType) || other.propertyType == _this.propertyType)&&(identical(other.deal, _this.deal) || other.deal == _this.deal)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.maintenanceCost, _this.maintenanceCost) || other.maintenanceCost == _this.maintenanceCost)&&(identical(other.isSuretyInsuranceAvailable, _this.isSuretyInsuranceAvailable) || other.isSuretyInsuranceAvailable == _this.isSuretyInsuranceAvailable)&&(identical(other.hasLoan, _this.hasLoan) || other.hasLoan == _this.hasLoan)&&(identical(other.isParkingAvailable, _this.isParkingAvailable) || other.isParkingAvailable == _this.isParkingAvailable)&&(identical(other.moveInDate, _this.moveInDate) || other.moveInDate == _this.moveInDate)&&(identical(other.isFlexibleMoveInDate, _this.isFlexibleMoveInDate) || other.isFlexibleMoveInDate == _this.isFlexibleMoveInDate)&&(identical(other.roomCount, _this.roomCount) || other.roomCount == _this.roomCount)&&const DeepCollectionEquality().equals(other.furnitureOptions, _this.furnitureOptions)&&(identical(other.memo, _this.memo) || other.memo == _this.memo)&&const DeepCollectionEquality().equals(other.images, _this.images)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.syncedAt, _this.syncedAt) || other.syncedAt == _this.syncedAt));
}


@override
int get hashCode {
  final _this = this as Property;
  return Object.hash(runtimeType,_this.id,_this.owner,_this.propertyType,_this.deal,_this.address,_this.maintenanceCost,_this.isSuretyInsuranceAvailable,_this.hasLoan,_this.isParkingAvailable,_this.moveInDate,_this.isFlexibleMoveInDate,_this.roomCount,const DeepCollectionEquality().hash(_this.furnitureOptions),_this.memo,const DeepCollectionEquality().hash(_this.images),_this.updatedAt,_this.deletedAt,_this.syncedAt);
}

@override
String toString() {
  final _this = this as Property;
  return 'Property(id: ${_this.id}, owner: ${_this.owner}, propertyType: ${_this.propertyType}, deal: ${_this.deal}, address: ${_this.address}, maintenanceCost: ${_this.maintenanceCost}, isSuretyInsuranceAvailable: ${_this.isSuretyInsuranceAvailable}, hasLoan: ${_this.hasLoan}, isParkingAvailable: ${_this.isParkingAvailable}, moveInDate: ${_this.moveInDate}, isFlexibleMoveInDate: ${_this.isFlexibleMoveInDate}, roomCount: ${_this.roomCount}, furnitureOptions: ${_this.furnitureOptions}, memo: ${_this.memo}, images: ${_this.images}, updatedAt: ${_this.updatedAt}, deletedAt: ${_this.deletedAt}, syncedAt: ${_this.syncedAt})';
}


}

/// @nodoc
abstract mixin class $PropertyCopyWith<$Res>  {
  factory $PropertyCopyWith(Property value, $Res Function(Property) _then) = _$PropertyCopyWithImpl;
@useResult
$Res call({
 String id, Owner owner, PropertyType propertyType, PropertyDeal deal, Address address, int? maintenanceCost, bool? isSuretyInsuranceAvailable, bool? hasLoan, bool? isParkingAvailable, DateTime? moveInDate, bool isFlexibleMoveInDate, int? roomCount, List<String> furnitureOptions, String memo, List<PropertyImage> images, DateTime updatedAt, DateTime? deletedAt, DateTime? syncedAt
});


$OwnerCopyWith<$Res> get owner;$PropertyDealCopyWith<$Res> get deal;$AddressCopyWith<$Res> get address;

}
/// @nodoc
class _$PropertyCopyWithImpl<$Res>
    implements $PropertyCopyWith<$Res> {
  _$PropertyCopyWithImpl(this._self, this._then);

  final Property _self;
  final $Res Function(Property) _then;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? owner = null,Object? propertyType = null,Object? deal = null,Object? address = null,Object? maintenanceCost = freezed,Object? isSuretyInsuranceAvailable = freezed,Object? hasLoan = freezed,Object? isParkingAvailable = freezed,Object? moveInDate = freezed,Object? isFlexibleMoveInDate = null,Object? roomCount = freezed,Object? furnitureOptions = null,Object? memo = null,Object? images = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncedAt = freezed,}) {
  return _then(Property(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as Owner,propertyType: null == propertyType ? _self.propertyType : propertyType // ignore: cast_nullable_to_non_nullable
as PropertyType,deal: null == deal ? _self.deal : deal // ignore: cast_nullable_to_non_nullable
as PropertyDeal,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address,maintenanceCost: freezed == maintenanceCost ? _self.maintenanceCost : maintenanceCost // ignore: cast_nullable_to_non_nullable
as int?,isSuretyInsuranceAvailable: freezed == isSuretyInsuranceAvailable ? _self.isSuretyInsuranceAvailable : isSuretyInsuranceAvailable // ignore: cast_nullable_to_non_nullable
as bool?,hasLoan: freezed == hasLoan ? _self.hasLoan : hasLoan // ignore: cast_nullable_to_non_nullable
as bool?,isParkingAvailable: freezed == isParkingAvailable ? _self.isParkingAvailable : isParkingAvailable // ignore: cast_nullable_to_non_nullable
as bool?,moveInDate: freezed == moveInDate ? _self.moveInDate : moveInDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isFlexibleMoveInDate: null == isFlexibleMoveInDate ? _self.isFlexibleMoveInDate : isFlexibleMoveInDate // ignore: cast_nullable_to_non_nullable
as bool,roomCount: freezed == roomCount ? _self.roomCount : roomCount // ignore: cast_nullable_to_non_nullable
as int?,furnitureOptions: null == furnitureOptions ? _self.furnitureOptions : furnitureOptions // ignore: cast_nullable_to_non_nullable
as List<String>,memo: null == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<PropertyImage>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncedAt: freezed == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerCopyWith<$Res> get owner {
  
  return $OwnerCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PropertyDealCopyWith<$Res> get deal {
  
  return $PropertyDealCopyWith<$Res>(_self.deal, (value) {
    return _then(_self.copyWith(deal: value));
  });
}/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get address {
  
  return $AddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}


/// Adds pattern-matching-related methods to [Property].
extension PropertyPatterns on Property {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Property value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Property() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Property value)  $default,){
final _that = this;
switch (_that) {
case _Property():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Property value)?  $default,){
final _that = this;
switch (_that) {
case _Property() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Owner owner,  PropertyType propertyType,  PropertyDeal deal,  Address address,  int? maintenanceCost,  bool? isSuretyInsuranceAvailable,  bool? hasLoan,  bool? isParkingAvailable,  DateTime? moveInDate,  bool isFlexibleMoveInDate,  int? roomCount,  List<String> furnitureOptions,  String memo,  List<PropertyImage> images,  DateTime updatedAt,  DateTime? deletedAt,  DateTime? syncedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Property() when $default != null:
return $default(_that.id,_that.owner,_that.propertyType,_that.deal,_that.address,_that.maintenanceCost,_that.isSuretyInsuranceAvailable,_that.hasLoan,_that.isParkingAvailable,_that.moveInDate,_that.isFlexibleMoveInDate,_that.roomCount,_that.furnitureOptions,_that.memo,_that.images,_that.updatedAt,_that.deletedAt,_that.syncedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Owner owner,  PropertyType propertyType,  PropertyDeal deal,  Address address,  int? maintenanceCost,  bool? isSuretyInsuranceAvailable,  bool? hasLoan,  bool? isParkingAvailable,  DateTime? moveInDate,  bool isFlexibleMoveInDate,  int? roomCount,  List<String> furnitureOptions,  String memo,  List<PropertyImage> images,  DateTime updatedAt,  DateTime? deletedAt,  DateTime? syncedAt)  $default,) {final _that = this;
switch (_that) {
case _Property():
return $default(_that.id,_that.owner,_that.propertyType,_that.deal,_that.address,_that.maintenanceCost,_that.isSuretyInsuranceAvailable,_that.hasLoan,_that.isParkingAvailable,_that.moveInDate,_that.isFlexibleMoveInDate,_that.roomCount,_that.furnitureOptions,_that.memo,_that.images,_that.updatedAt,_that.deletedAt,_that.syncedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Owner owner,  PropertyType propertyType,  PropertyDeal deal,  Address address,  int? maintenanceCost,  bool? isSuretyInsuranceAvailable,  bool? hasLoan,  bool? isParkingAvailable,  DateTime? moveInDate,  bool isFlexibleMoveInDate,  int? roomCount,  List<String> furnitureOptions,  String memo,  List<PropertyImage> images,  DateTime updatedAt,  DateTime? deletedAt,  DateTime? syncedAt)?  $default,) {final _that = this;
switch (_that) {
case _Property() when $default != null:
return $default(_that.id,_that.owner,_that.propertyType,_that.deal,_that.address,_that.maintenanceCost,_that.isSuretyInsuranceAvailable,_that.hasLoan,_that.isParkingAvailable,_that.moveInDate,_that.isFlexibleMoveInDate,_that.roomCount,_that.furnitureOptions,_that.memo,_that.images,_that.updatedAt,_that.deletedAt,_that.syncedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Property extends Property {
  const _Property({required this.id, required this.owner, required this.propertyType, required this.deal, required this.address, this.maintenanceCost, this.isSuretyInsuranceAvailable, this.hasLoan, this.isParkingAvailable, this.moveInDate, this.isFlexibleMoveInDate = false, this.roomCount,  List<String> furnitureOptions = const <String>[], this.memo = '',  List<PropertyImage> images = const <PropertyImage>[], required this.updatedAt, this.deletedAt, this.syncedAt}): _furnitureOptions = furnitureOptions,_images = images,super._();
  

@override final  String id;
@override final  Owner owner;
@override final  PropertyType propertyType;
@override final  PropertyDeal deal;
@override final  Address address;
@override final  int? maintenanceCost;
@override final  bool? isSuretyInsuranceAvailable;
@override final  bool? hasLoan;
@override final  bool? isParkingAvailable;
@override final  DateTime? moveInDate;
@override@JsonKey() final  bool isFlexibleMoveInDate;
@override final  int? roomCount;
 final  List<String> _furnitureOptions;
@override@JsonKey() List<String> get furnitureOptions {
  if (_furnitureOptions is EqualUnmodifiableListView) return _furnitureOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_furnitureOptions);
}

@override@JsonKey() final  String memo;
 final  List<PropertyImage> _images;
@override@JsonKey() List<PropertyImage> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  DateTime updatedAt;
@override final  DateTime? deletedAt;
@override final  DateTime? syncedAt;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyCopyWith<_Property> get copyWith => __$PropertyCopyWithImpl<_Property>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Property&&(identical(other.id, id) || other.id == id)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.propertyType, propertyType) || other.propertyType == propertyType)&&(identical(other.deal, deal) || other.deal == deal)&&(identical(other.address, address) || other.address == address)&&(identical(other.maintenanceCost, maintenanceCost) || other.maintenanceCost == maintenanceCost)&&(identical(other.isSuretyInsuranceAvailable, isSuretyInsuranceAvailable) || other.isSuretyInsuranceAvailable == isSuretyInsuranceAvailable)&&(identical(other.hasLoan, hasLoan) || other.hasLoan == hasLoan)&&(identical(other.isParkingAvailable, isParkingAvailable) || other.isParkingAvailable == isParkingAvailable)&&(identical(other.moveInDate, moveInDate) || other.moveInDate == moveInDate)&&(identical(other.isFlexibleMoveInDate, isFlexibleMoveInDate) || other.isFlexibleMoveInDate == isFlexibleMoveInDate)&&(identical(other.roomCount, roomCount) || other.roomCount == roomCount)&&const DeepCollectionEquality().equals(other.furnitureOptions, _furnitureOptions)&&(identical(other.memo, memo) || other.memo == memo)&&const DeepCollectionEquality().equals(other.images, _images)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncedAt, syncedAt) || other.syncedAt == syncedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,owner,propertyType,deal,address,maintenanceCost,isSuretyInsuranceAvailable,hasLoan,isParkingAvailable,moveInDate,isFlexibleMoveInDate,roomCount,const DeepCollectionEquality().hash(_furnitureOptions),memo,const DeepCollectionEquality().hash(_images),updatedAt,deletedAt,syncedAt);
}

@override
String toString() {
    return 'Property(id: $id, owner: $owner, propertyType: $propertyType, deal: $deal, address: $address, maintenanceCost: $maintenanceCost, isSuretyInsuranceAvailable: $isSuretyInsuranceAvailable, hasLoan: $hasLoan, isParkingAvailable: $isParkingAvailable, moveInDate: $moveInDate, isFlexibleMoveInDate: $isFlexibleMoveInDate, roomCount: $roomCount, furnitureOptions: $furnitureOptions, memo: $memo, images: $images, updatedAt: $updatedAt, deletedAt: $deletedAt, syncedAt: $syncedAt)';
}


}

/// @nodoc
abstract mixin class _$PropertyCopyWith<$Res> implements $PropertyCopyWith<$Res> {
  factory _$PropertyCopyWith(_Property value, $Res Function(_Property) _then) = __$PropertyCopyWithImpl;
@override @useResult
$Res call({
 String id, Owner owner, PropertyType propertyType, PropertyDeal deal, Address address, int? maintenanceCost, bool? isSuretyInsuranceAvailable, bool? hasLoan, bool? isParkingAvailable, DateTime? moveInDate, bool isFlexibleMoveInDate, int? roomCount, List<String> furnitureOptions, String memo, List<PropertyImage> images, DateTime updatedAt, DateTime? deletedAt, DateTime? syncedAt
});


@override $OwnerCopyWith<$Res> get owner;@override $PropertyDealCopyWith<$Res> get deal;@override $AddressCopyWith<$Res> get address;

}
/// @nodoc
class __$PropertyCopyWithImpl<$Res>
    implements _$PropertyCopyWith<$Res> {
  __$PropertyCopyWithImpl(this._self, this._then);

  final _Property _self;
  final $Res Function(_Property) _then;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? owner = null,Object? propertyType = null,Object? deal = null,Object? address = null,Object? maintenanceCost = freezed,Object? isSuretyInsuranceAvailable = freezed,Object? hasLoan = freezed,Object? isParkingAvailable = freezed,Object? moveInDate = freezed,Object? isFlexibleMoveInDate = null,Object? roomCount = freezed,Object? furnitureOptions = null,Object? memo = null,Object? images = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncedAt = freezed,}) {
  return _then(_Property(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as Owner,propertyType: null == propertyType ? _self.propertyType : propertyType // ignore: cast_nullable_to_non_nullable
as PropertyType,deal: null == deal ? _self.deal : deal // ignore: cast_nullable_to_non_nullable
as PropertyDeal,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address,maintenanceCost: freezed == maintenanceCost ? _self.maintenanceCost : maintenanceCost // ignore: cast_nullable_to_non_nullable
as int?,isSuretyInsuranceAvailable: freezed == isSuretyInsuranceAvailable ? _self.isSuretyInsuranceAvailable : isSuretyInsuranceAvailable // ignore: cast_nullable_to_non_nullable
as bool?,hasLoan: freezed == hasLoan ? _self.hasLoan : hasLoan // ignore: cast_nullable_to_non_nullable
as bool?,isParkingAvailable: freezed == isParkingAvailable ? _self.isParkingAvailable : isParkingAvailable // ignore: cast_nullable_to_non_nullable
as bool?,moveInDate: freezed == moveInDate ? _self.moveInDate : moveInDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isFlexibleMoveInDate: null == isFlexibleMoveInDate ? _self.isFlexibleMoveInDate : isFlexibleMoveInDate // ignore: cast_nullable_to_non_nullable
as bool,roomCount: freezed == roomCount ? _self.roomCount : roomCount // ignore: cast_nullable_to_non_nullable
as int?,furnitureOptions: null == furnitureOptions ? _self._furnitureOptions : furnitureOptions // ignore: cast_nullable_to_non_nullable
as List<String>,memo: null == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<PropertyImage>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncedAt: freezed == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerCopyWith<$Res> get owner {
  
  return $OwnerCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PropertyDealCopyWith<$Res> get deal {
  
  return $PropertyDealCopyWith<$Res>(_self.deal, (value) {
    return _then(_self.copyWith(deal: value));
  });
}/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get address {
  
  return $AddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}

// dart format on
