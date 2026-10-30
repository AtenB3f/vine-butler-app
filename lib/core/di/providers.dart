import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/network/dio_factory.dart';
import 'package:vine_butler/data/local/app_database.dart';
import 'package:vine_butler/data/remote/clova/clova_studio_api.dart';
import 'package:vine_butler/data/remote/clova/prompts/blog_prompt.dart';
import 'package:vine_butler/data/remote/clova/prompts/default_blog_prompt.dart';
import 'package:vine_butler/data/remote/juso/juso_api.dart';
import 'package:vine_butler/data/remote/naver/geocode_api.dart';
import 'package:vine_butler/data/repository/address_repository_impl.dart';
import 'package:vine_butler/data/repository/blog_repository_impl.dart';
import 'package:vine_butler/data/repository/location_repository_impl.dart';
import 'package:vine_butler/data/repository/property_repository_impl.dart';
import 'package:vine_butler/data/repository/user_role_repository_impl.dart';
import 'package:vine_butler/data/storage/image_storage_impl.dart';
import 'package:vine_butler/domain/repository/address_repository.dart';
import 'package:vine_butler/domain/repository/blog_repository.dart';
import 'package:vine_butler/domain/repository/image_storage.dart';
import 'package:vine_butler/domain/repository/location_repository.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';
import 'package:vine_butler/domain/repository/user_role_repository.dart';
import 'package:vine_butler/domain/usecase/address_usecase.dart';
import 'package:vine_butler/domain/usecase/blog_usecase.dart';
import 'package:vine_butler/domain/usecase/property_usecase.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final propertyRepositoryProvider = Provider<PropertyRepository>(
  (ref) => PropertyRepositoryImpl(ref.watch(appDatabaseProvider)),
);

final propertyUseCaseProvider = Provider<PropertyUseCase>((ref) => PropertyUseCase(ref.watch(propertyRepositoryProvider)));

final naverMapsDioProvider = Provider<Dio>((ref) {
  final dio = createNaverMapsDio();
  ref.onDispose(dio.close);
  return dio;
});

final jusoDioProvider = Provider<Dio>((ref) {
  final dio = createJusoDio();
  ref.onDispose(dio.close);
  return dio;
});

final addressRepositoryProvider = Provider<AddressRepository>(
  (ref) => AddressRepositoryImpl(JusoApi(ref.watch(jusoDioProvider)), GeocodeApi(ref.watch(naverMapsDioProvider))),
);

final addressUseCaseProvider = Provider<AddressUseCase>((ref) => AddressUseCase(ref.watch(addressRepositoryProvider)));

/// 매물 이미지 저장 폴더 (`main()`에서 앱 전용 폴더 아래 경로로 override)
final imageDirectoryProvider = Provider<Directory>((ref) => throw UnimplementedError());

final imageStorageProvider = Provider<ImageStorage>((ref) => ImageStorageImpl(ref.watch(imageDirectoryProvider)));

final locationRepositoryProvider = Provider<LocationRepository>((ref) => const LocationRepositoryImpl());

final clovaStudioDioProvider = Provider<Dio>((ref) {
  final dio = createClovaStudioDio();
  ref.onDispose(dio.close);
  return dio;
});

final blogPromptProvider = Provider<BlogPromptBuilder>((ref) => DefaultBlogPrompt.new);

final blogRepositoryProvider = Provider<BlogRepository>(
  (ref) => BlogRepositoryImpl(
    ClovaStudioApi(ref.watch(clovaStudioDioProvider)),
    ref.watch(imageStorageProvider),
    ref.watch(blogPromptProvider),
  ),
);

final userRoleRepositoryProvider = Provider<UserRoleRepository>((ref) => const UserRoleRepositoryImpl());

final blogUseCaseProvider = Provider<BlogUseCase>(
  (ref) => BlogUseCase(
    ref.watch(blogRepositoryProvider),
    ref.watch(propertyRepositoryProvider),
    ref.watch(userRoleRepositoryProvider),
  ),
);
