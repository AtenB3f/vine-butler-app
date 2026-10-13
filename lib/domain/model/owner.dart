import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner.freezed.dart';

@freezed
abstract class Owner with _$Owner {
  const factory Owner({
    required String name,
    required String phone,
  }) = _Owner;
}
