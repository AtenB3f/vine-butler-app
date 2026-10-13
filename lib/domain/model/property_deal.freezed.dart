// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_deal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PropertyDeal {

 PropertyTransactionType get transactionType; int get price; int? get monthlyRent;
/// Create a copy of PropertyDeal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyDealCopyWith<PropertyDeal> get copyWith => _$PropertyDealCopyWithImpl<PropertyDeal>(this as PropertyDeal, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PropertyDeal;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertyDeal&&(identical(other.transactionType, _this.transactionType) || other.transactionType == _this.transactionType)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.monthlyRent, _this.monthlyRent) || other.monthlyRent == _this.monthlyRent));
}


@override
int get hashCode {
  final _this = this as PropertyDeal;
  return Object.hash(runtimeType,_this.transactionType,_this.price,_this.monthlyRent);
}

@override
String toString() {
  final _this = this as PropertyDeal;
  return 'PropertyDeal(transactionType: ${_this.transactionType}, price: ${_this.price}, monthlyRent: ${_this.monthlyRent})';
}


}

/// @nodoc
abstract mixin class $PropertyDealCopyWith<$Res>  {
  factory $PropertyDealCopyWith(PropertyDeal value, $Res Function(PropertyDeal) _then) = _$PropertyDealCopyWithImpl;
@useResult
$Res call({
 PropertyTransactionType transactionType, int price, int? monthlyRent
});




}
/// @nodoc
class _$PropertyDealCopyWithImpl<$Res>
    implements $PropertyDealCopyWith<$Res> {
  _$PropertyDealCopyWithImpl(this._self, this._then);

  final PropertyDeal _self;
  final $Res Function(PropertyDeal) _then;

/// Create a copy of PropertyDeal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactionType = null,Object? price = null,Object? monthlyRent = freezed,}) {
  return _then(PropertyDeal(
transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as PropertyTransactionType,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,monthlyRent: freezed == monthlyRent ? _self.monthlyRent : monthlyRent // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PropertyDeal].
extension PropertyDealPatterns on PropertyDeal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PropertyDeal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PropertyDeal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PropertyDeal value)  $default,){
final _that = this;
switch (_that) {
case _PropertyDeal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PropertyDeal value)?  $default,){
final _that = this;
switch (_that) {
case _PropertyDeal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PropertyTransactionType transactionType,  int price,  int? monthlyRent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PropertyDeal() when $default != null:
return $default(_that.transactionType,_that.price,_that.monthlyRent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PropertyTransactionType transactionType,  int price,  int? monthlyRent)  $default,) {final _that = this;
switch (_that) {
case _PropertyDeal():
return $default(_that.transactionType,_that.price,_that.monthlyRent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PropertyTransactionType transactionType,  int price,  int? monthlyRent)?  $default,) {final _that = this;
switch (_that) {
case _PropertyDeal() when $default != null:
return $default(_that.transactionType,_that.price,_that.monthlyRent);case _:
  return null;

}
}

}

/// @nodoc


class _PropertyDeal implements PropertyDeal {
  const _PropertyDeal({required this.transactionType, required this.price, this.monthlyRent});
  

@override final  PropertyTransactionType transactionType;
@override final  int price;
@override final  int? monthlyRent;

/// Create a copy of PropertyDeal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyDealCopyWith<_PropertyDeal> get copyWith => __$PropertyDealCopyWithImpl<_PropertyDeal>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PropertyDeal&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.price, price) || other.price == price)&&(identical(other.monthlyRent, monthlyRent) || other.monthlyRent == monthlyRent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,transactionType,price,monthlyRent);
}

@override
String toString() {
    return 'PropertyDeal(transactionType: $transactionType, price: $price, monthlyRent: $monthlyRent)';
}


}

/// @nodoc
abstract mixin class _$PropertyDealCopyWith<$Res> implements $PropertyDealCopyWith<$Res> {
  factory _$PropertyDealCopyWith(_PropertyDeal value, $Res Function(_PropertyDeal) _then) = __$PropertyDealCopyWithImpl;
@override @useResult
$Res call({
 PropertyTransactionType transactionType, int price, int? monthlyRent
});




}
/// @nodoc
class __$PropertyDealCopyWithImpl<$Res>
    implements _$PropertyDealCopyWith<$Res> {
  __$PropertyDealCopyWithImpl(this._self, this._then);

  final _PropertyDeal _self;
  final $Res Function(_PropertyDeal) _then;

/// Create a copy of PropertyDeal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactionType = null,Object? price = null,Object? monthlyRent = freezed,}) {
  return _then(_PropertyDeal(
transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as PropertyTransactionType,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,monthlyRent: freezed == monthlyRent ? _self.monthlyRent : monthlyRent // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
