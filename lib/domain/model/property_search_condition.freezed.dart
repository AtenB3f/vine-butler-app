// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_search_condition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PropertySearchCondition {

 PropertyTransactionType? get transactionType; Set<PropertyType> get propertyTypes; int? get price; String get keyword;
/// Create a copy of PropertySearchCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertySearchConditionCopyWith<PropertySearchCondition> get copyWith => _$PropertySearchConditionCopyWithImpl<PropertySearchCondition>(this as PropertySearchCondition, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PropertySearchCondition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertySearchCondition&&(identical(other.transactionType, _this.transactionType) || other.transactionType == _this.transactionType)&&const DeepCollectionEquality().equals(other.propertyTypes, _this.propertyTypes)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.keyword, _this.keyword) || other.keyword == _this.keyword));
}


@override
int get hashCode {
  final _this = this as PropertySearchCondition;
  return Object.hash(runtimeType,_this.transactionType,const DeepCollectionEquality().hash(_this.propertyTypes),_this.price,_this.keyword);
}

@override
String toString() {
  final _this = this as PropertySearchCondition;
  return 'PropertySearchCondition(transactionType: ${_this.transactionType}, propertyTypes: ${_this.propertyTypes}, price: ${_this.price}, keyword: ${_this.keyword})';
}


}

/// @nodoc
abstract mixin class $PropertySearchConditionCopyWith<$Res>  {
  factory $PropertySearchConditionCopyWith(PropertySearchCondition value, $Res Function(PropertySearchCondition) _then) = _$PropertySearchConditionCopyWithImpl;
@useResult
$Res call({
 PropertyTransactionType? transactionType, Set<PropertyType> propertyTypes, int? price, String keyword
});




}
/// @nodoc
class _$PropertySearchConditionCopyWithImpl<$Res>
    implements $PropertySearchConditionCopyWith<$Res> {
  _$PropertySearchConditionCopyWithImpl(this._self, this._then);

  final PropertySearchCondition _self;
  final $Res Function(PropertySearchCondition) _then;

/// Create a copy of PropertySearchCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactionType = freezed,Object? propertyTypes = null,Object? price = freezed,Object? keyword = null,}) {
  return _then(PropertySearchCondition(
transactionType: freezed == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as PropertyTransactionType?,propertyTypes: null == propertyTypes ? _self.propertyTypes : propertyTypes // ignore: cast_nullable_to_non_nullable
as Set<PropertyType>,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PropertySearchCondition].
extension PropertySearchConditionPatterns on PropertySearchCondition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PropertySearchCondition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PropertySearchCondition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PropertySearchCondition value)  $default,){
final _that = this;
switch (_that) {
case _PropertySearchCondition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PropertySearchCondition value)?  $default,){
final _that = this;
switch (_that) {
case _PropertySearchCondition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PropertyTransactionType? transactionType,  Set<PropertyType> propertyTypes,  int? price,  String keyword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PropertySearchCondition() when $default != null:
return $default(_that.transactionType,_that.propertyTypes,_that.price,_that.keyword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PropertyTransactionType? transactionType,  Set<PropertyType> propertyTypes,  int? price,  String keyword)  $default,) {final _that = this;
switch (_that) {
case _PropertySearchCondition():
return $default(_that.transactionType,_that.propertyTypes,_that.price,_that.keyword);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PropertyTransactionType? transactionType,  Set<PropertyType> propertyTypes,  int? price,  String keyword)?  $default,) {final _that = this;
switch (_that) {
case _PropertySearchCondition() when $default != null:
return $default(_that.transactionType,_that.propertyTypes,_that.price,_that.keyword);case _:
  return null;

}
}

}

/// @nodoc


class _PropertySearchCondition implements PropertySearchCondition {
  const _PropertySearchCondition({this.transactionType,  Set<PropertyType> propertyTypes = const {}, this.price, this.keyword = ''}): _propertyTypes = propertyTypes;
  

@override final  PropertyTransactionType? transactionType;
 final  Set<PropertyType> _propertyTypes;
@override@JsonKey() Set<PropertyType> get propertyTypes {
  if (_propertyTypes is EqualUnmodifiableSetView) return _propertyTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_propertyTypes);
}

@override final  int? price;
@override@JsonKey() final  String keyword;

/// Create a copy of PropertySearchCondition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertySearchConditionCopyWith<_PropertySearchCondition> get copyWith => __$PropertySearchConditionCopyWithImpl<_PropertySearchCondition>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PropertySearchCondition&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&const DeepCollectionEquality().equals(other.propertyTypes, _propertyTypes)&&(identical(other.price, price) || other.price == price)&&(identical(other.keyword, keyword) || other.keyword == keyword));
}


@override
int get hashCode {
    return Object.hash(runtimeType,transactionType,const DeepCollectionEquality().hash(_propertyTypes),price,keyword);
}

@override
String toString() {
    return 'PropertySearchCondition(transactionType: $transactionType, propertyTypes: $propertyTypes, price: $price, keyword: $keyword)';
}


}

/// @nodoc
abstract mixin class _$PropertySearchConditionCopyWith<$Res> implements $PropertySearchConditionCopyWith<$Res> {
  factory _$PropertySearchConditionCopyWith(_PropertySearchCondition value, $Res Function(_PropertySearchCondition) _then) = __$PropertySearchConditionCopyWithImpl;
@override @useResult
$Res call({
 PropertyTransactionType? transactionType, Set<PropertyType> propertyTypes, int? price, String keyword
});




}
/// @nodoc
class __$PropertySearchConditionCopyWithImpl<$Res>
    implements _$PropertySearchConditionCopyWith<$Res> {
  __$PropertySearchConditionCopyWithImpl(this._self, this._then);

  final _PropertySearchCondition _self;
  final $Res Function(_PropertySearchCondition) _then;

/// Create a copy of PropertySearchCondition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactionType = freezed,Object? propertyTypes = null,Object? price = freezed,Object? keyword = null,}) {
  return _then(_PropertySearchCondition(
transactionType: freezed == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as PropertyTransactionType?,propertyTypes: null == propertyTypes ? _self._propertyTypes : propertyTypes // ignore: cast_nullable_to_non_nullable
as Set<PropertyType>,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
