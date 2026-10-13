// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PropertyImage {

 String get id; String get fileName; int get order; DateTime get createdAt;
/// Create a copy of PropertyImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyImageCopyWith<PropertyImage> get copyWith => _$PropertyImageCopyWithImpl<PropertyImage>(this as PropertyImage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PropertyImage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertyImage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.order, _this.order) || other.order == _this.order)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as PropertyImage;
  return Object.hash(runtimeType,_this.id,_this.fileName,_this.order,_this.createdAt);
}

@override
String toString() {
  final _this = this as PropertyImage;
  return 'PropertyImage(id: ${_this.id}, fileName: ${_this.fileName}, order: ${_this.order}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $PropertyImageCopyWith<$Res>  {
  factory $PropertyImageCopyWith(PropertyImage value, $Res Function(PropertyImage) _then) = _$PropertyImageCopyWithImpl;
@useResult
$Res call({
 String id, String fileName, int order, DateTime createdAt
});




}
/// @nodoc
class _$PropertyImageCopyWithImpl<$Res>
    implements $PropertyImageCopyWith<$Res> {
  _$PropertyImageCopyWithImpl(this._self, this._then);

  final PropertyImage _self;
  final $Res Function(PropertyImage) _then;

/// Create a copy of PropertyImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fileName = null,Object? order = null,Object? createdAt = null,}) {
  return _then(PropertyImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PropertyImage].
extension PropertyImagePatterns on PropertyImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PropertyImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PropertyImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PropertyImage value)  $default,){
final _that = this;
switch (_that) {
case _PropertyImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PropertyImage value)?  $default,){
final _that = this;
switch (_that) {
case _PropertyImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fileName,  int order,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PropertyImage() when $default != null:
return $default(_that.id,_that.fileName,_that.order,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fileName,  int order,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PropertyImage():
return $default(_that.id,_that.fileName,_that.order,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fileName,  int order,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PropertyImage() when $default != null:
return $default(_that.id,_that.fileName,_that.order,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _PropertyImage implements PropertyImage {
  const _PropertyImage({required this.id, required this.fileName, required this.order, required this.createdAt});
  

@override final  String id;
@override final  String fileName;
@override final  int order;
@override final  DateTime createdAt;

/// Create a copy of PropertyImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyImageCopyWith<_PropertyImage> get copyWith => __$PropertyImageCopyWithImpl<_PropertyImage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PropertyImage&&(identical(other.id, id) || other.id == id)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.order, order) || other.order == order)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,fileName,order,createdAt);
}

@override
String toString() {
    return 'PropertyImage(id: $id, fileName: $fileName, order: $order, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PropertyImageCopyWith<$Res> implements $PropertyImageCopyWith<$Res> {
  factory _$PropertyImageCopyWith(_PropertyImage value, $Res Function(_PropertyImage) _then) = __$PropertyImageCopyWithImpl;
@override @useResult
$Res call({
 String id, String fileName, int order, DateTime createdAt
});




}
/// @nodoc
class __$PropertyImageCopyWithImpl<$Res>
    implements _$PropertyImageCopyWith<$Res> {
  __$PropertyImageCopyWithImpl(this._self, this._then);

  final _PropertyImage _self;
  final $Res Function(_PropertyImage) _then;

/// Create a copy of PropertyImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fileName = null,Object? order = null,Object? createdAt = null,}) {
  return _then(_PropertyImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
