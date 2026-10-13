import 'package:freezed_annotation/freezed_annotation.dart';

part 'property_image.freezed.dart';

@freezed
abstract class PropertyImage with _$PropertyImage {
  const factory PropertyImage({
    required String id,
    required String fileName,
    required int order,
    required DateTime createdAt,
  }) = _PropertyImage;
}
