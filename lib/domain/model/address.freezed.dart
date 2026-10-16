// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Address {

 String get zipCode; String get roadAddress; String get lotAddress; String get sido; String get sigungu; String get dongMyeon; String? get buildingName; String get detailAddress; double get latitude; double get longitude;
/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressCopyWith<Address> get copyWith => _$AddressCopyWithImpl<Address>(this as Address, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Address;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Address&&(identical(other.zipCode, _this.zipCode) || other.zipCode == _this.zipCode)&&(identical(other.roadAddress, _this.roadAddress) || other.roadAddress == _this.roadAddress)&&(identical(other.lotAddress, _this.lotAddress) || other.lotAddress == _this.lotAddress)&&(identical(other.sido, _this.sido) || other.sido == _this.sido)&&(identical(other.sigungu, _this.sigungu) || other.sigungu == _this.sigungu)&&(identical(other.dongMyeon, _this.dongMyeon) || other.dongMyeon == _this.dongMyeon)&&(identical(other.buildingName, _this.buildingName) || other.buildingName == _this.buildingName)&&(identical(other.detailAddress, _this.detailAddress) || other.detailAddress == _this.detailAddress)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude));
}


@override
int get hashCode {
  final _this = this as Address;
  return Object.hash(runtimeType,_this.zipCode,_this.roadAddress,_this.lotAddress,_this.sido,_this.sigungu,_this.dongMyeon,_this.buildingName,_this.detailAddress,_this.latitude,_this.longitude);
}

@override
String toString() {
  final _this = this as Address;
  return 'Address(zipCode: ${_this.zipCode}, roadAddress: ${_this.roadAddress}, lotAddress: ${_this.lotAddress}, sido: ${_this.sido}, sigungu: ${_this.sigungu}, dongMyeon: ${_this.dongMyeon}, buildingName: ${_this.buildingName}, detailAddress: ${_this.detailAddress}, latitude: ${_this.latitude}, longitude: ${_this.longitude})';
}


}

/// @nodoc
abstract mixin class $AddressCopyWith<$Res>  {
  factory $AddressCopyWith(Address value, $Res Function(Address) _then) = _$AddressCopyWithImpl;
@useResult
$Res call({
 String zipCode, String roadAddress, String lotAddress, String sido, String sigungu, String dongMyeon, String? buildingName, String detailAddress, double latitude, double longitude
});




}
/// @nodoc
class _$AddressCopyWithImpl<$Res>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._self, this._then);

  final Address _self;
  final $Res Function(Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? zipCode = null,Object? roadAddress = null,Object? lotAddress = null,Object? sido = null,Object? sigungu = null,Object? dongMyeon = null,Object? buildingName = freezed,Object? detailAddress = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(Address(
zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,roadAddress: null == roadAddress ? _self.roadAddress : roadAddress // ignore: cast_nullable_to_non_nullable
as String,lotAddress: null == lotAddress ? _self.lotAddress : lotAddress // ignore: cast_nullable_to_non_nullable
as String,sido: null == sido ? _self.sido : sido // ignore: cast_nullable_to_non_nullable
as String,sigungu: null == sigungu ? _self.sigungu : sigungu // ignore: cast_nullable_to_non_nullable
as String,dongMyeon: null == dongMyeon ? _self.dongMyeon : dongMyeon // ignore: cast_nullable_to_non_nullable
as String,buildingName: freezed == buildingName ? _self.buildingName : buildingName // ignore: cast_nullable_to_non_nullable
as String?,detailAddress: null == detailAddress ? _self.detailAddress : detailAddress // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Address].
extension AddressPatterns on Address {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Address value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Address value)  $default,){
final _that = this;
switch (_that) {
case _Address():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Address value)?  $default,){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String zipCode,  String roadAddress,  String lotAddress,  String sido,  String sigungu,  String dongMyeon,  String? buildingName,  String detailAddress,  double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.zipCode,_that.roadAddress,_that.lotAddress,_that.sido,_that.sigungu,_that.dongMyeon,_that.buildingName,_that.detailAddress,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String zipCode,  String roadAddress,  String lotAddress,  String sido,  String sigungu,  String dongMyeon,  String? buildingName,  String detailAddress,  double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _Address():
return $default(_that.zipCode,_that.roadAddress,_that.lotAddress,_that.sido,_that.sigungu,_that.dongMyeon,_that.buildingName,_that.detailAddress,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String zipCode,  String roadAddress,  String lotAddress,  String sido,  String sigungu,  String dongMyeon,  String? buildingName,  String detailAddress,  double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.zipCode,_that.roadAddress,_that.lotAddress,_that.sido,_that.sigungu,_that.dongMyeon,_that.buildingName,_that.detailAddress,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc


class _Address implements Address {
  const _Address({required this.zipCode, required this.roadAddress, required this.lotAddress, required this.sido, required this.sigungu, required this.dongMyeon, this.buildingName, this.detailAddress = '', required this.latitude, required this.longitude});
  

@override final  String zipCode;
@override final  String roadAddress;
@override final  String lotAddress;
@override final  String sido;
@override final  String sigungu;
@override final  String dongMyeon;
@override final  String? buildingName;
@override@JsonKey() final  String detailAddress;
@override final  double latitude;
@override final  double longitude;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressCopyWith<_Address> get copyWith => __$AddressCopyWithImpl<_Address>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Address&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.roadAddress, roadAddress) || other.roadAddress == roadAddress)&&(identical(other.lotAddress, lotAddress) || other.lotAddress == lotAddress)&&(identical(other.sido, sido) || other.sido == sido)&&(identical(other.sigungu, sigungu) || other.sigungu == sigungu)&&(identical(other.dongMyeon, dongMyeon) || other.dongMyeon == dongMyeon)&&(identical(other.buildingName, buildingName) || other.buildingName == buildingName)&&(identical(other.detailAddress, detailAddress) || other.detailAddress == detailAddress)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode {
    return Object.hash(runtimeType,zipCode,roadAddress,lotAddress,sido,sigungu,dongMyeon,buildingName,detailAddress,latitude,longitude);
}

@override
String toString() {
    return 'Address(zipCode: $zipCode, roadAddress: $roadAddress, lotAddress: $lotAddress, sido: $sido, sigungu: $sigungu, dongMyeon: $dongMyeon, buildingName: $buildingName, detailAddress: $detailAddress, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$AddressCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$AddressCopyWith(_Address value, $Res Function(_Address) _then) = __$AddressCopyWithImpl;
@override @useResult
$Res call({
 String zipCode, String roadAddress, String lotAddress, String sido, String sigungu, String dongMyeon, String? buildingName, String detailAddress, double latitude, double longitude
});




}
/// @nodoc
class __$AddressCopyWithImpl<$Res>
    implements _$AddressCopyWith<$Res> {
  __$AddressCopyWithImpl(this._self, this._then);

  final _Address _self;
  final $Res Function(_Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? zipCode = null,Object? roadAddress = null,Object? lotAddress = null,Object? sido = null,Object? sigungu = null,Object? dongMyeon = null,Object? buildingName = freezed,Object? detailAddress = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_Address(
zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,roadAddress: null == roadAddress ? _self.roadAddress : roadAddress // ignore: cast_nullable_to_non_nullable
as String,lotAddress: null == lotAddress ? _self.lotAddress : lotAddress // ignore: cast_nullable_to_non_nullable
as String,sido: null == sido ? _self.sido : sido // ignore: cast_nullable_to_non_nullable
as String,sigungu: null == sigungu ? _self.sigungu : sigungu // ignore: cast_nullable_to_non_nullable
as String,dongMyeon: null == dongMyeon ? _self.dongMyeon : dongMyeon // ignore: cast_nullable_to_non_nullable
as String,buildingName: freezed == buildingName ? _self.buildingName : buildingName // ignore: cast_nullable_to_non_nullable
as String?,detailAddress: null == detailAddress ? _self.detailAddress : detailAddress // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
