// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blog_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BlogPost {

 String get title; String get body; bool get isTruncated;
/// Create a copy of BlogPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogPostCopyWith<BlogPost> get copyWith => _$BlogPostCopyWithImpl<BlogPost>(this as BlogPost, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BlogPost;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogPost&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.isTruncated, _this.isTruncated) || other.isTruncated == _this.isTruncated));
}


@override
int get hashCode {
  final _this = this as BlogPost;
  return Object.hash(runtimeType,_this.title,_this.body,_this.isTruncated);
}

@override
String toString() {
  final _this = this as BlogPost;
  return 'BlogPost(title: ${_this.title}, body: ${_this.body}, isTruncated: ${_this.isTruncated})';
}


}

/// @nodoc
abstract mixin class $BlogPostCopyWith<$Res>  {
  factory $BlogPostCopyWith(BlogPost value, $Res Function(BlogPost) _then) = _$BlogPostCopyWithImpl;
@useResult
$Res call({
 String title, String body, bool isTruncated
});




}
/// @nodoc
class _$BlogPostCopyWithImpl<$Res>
    implements $BlogPostCopyWith<$Res> {
  _$BlogPostCopyWithImpl(this._self, this._then);

  final BlogPost _self;
  final $Res Function(BlogPost) _then;

/// Create a copy of BlogPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? body = null,Object? isTruncated = null,}) {
  return _then(BlogPost(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,isTruncated: null == isTruncated ? _self.isTruncated : isTruncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BlogPost].
extension BlogPostPatterns on BlogPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlogPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlogPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlogPost value)  $default,){
final _that = this;
switch (_that) {
case _BlogPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlogPost value)?  $default,){
final _that = this;
switch (_that) {
case _BlogPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String body,  bool isTruncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogPost() when $default != null:
return $default(_that.title,_that.body,_that.isTruncated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String body,  bool isTruncated)  $default,) {final _that = this;
switch (_that) {
case _BlogPost():
return $default(_that.title,_that.body,_that.isTruncated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String body,  bool isTruncated)?  $default,) {final _that = this;
switch (_that) {
case _BlogPost() when $default != null:
return $default(_that.title,_that.body,_that.isTruncated);case _:
  return null;

}
}

}

/// @nodoc


class _BlogPost implements BlogPost {
  const _BlogPost({this.title = '', required this.body, this.isTruncated = false});
  

@override@JsonKey() final  String title;
@override final  String body;
@override@JsonKey() final  bool isTruncated;

/// Create a copy of BlogPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlogPostCopyWith<_BlogPost> get copyWith => __$BlogPostCopyWithImpl<_BlogPost>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogPost&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.isTruncated, isTruncated) || other.isTruncated == isTruncated));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,body,isTruncated);
}

@override
String toString() {
    return 'BlogPost(title: $title, body: $body, isTruncated: $isTruncated)';
}


}

/// @nodoc
abstract mixin class _$BlogPostCopyWith<$Res> implements $BlogPostCopyWith<$Res> {
  factory _$BlogPostCopyWith(_BlogPost value, $Res Function(_BlogPost) _then) = __$BlogPostCopyWithImpl;
@override @useResult
$Res call({
 String title, String body, bool isTruncated
});




}
/// @nodoc
class __$BlogPostCopyWithImpl<$Res>
    implements _$BlogPostCopyWith<$Res> {
  __$BlogPostCopyWithImpl(this._self, this._then);

  final _BlogPost _self;
  final $Res Function(_BlogPost) _then;

/// Create a copy of BlogPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? body = null,Object? isTruncated = null,}) {
  return _then(_BlogPost(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,isTruncated: null == isTruncated ? _self.isTruncated : isTruncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
