import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/network/dio_factory.dart';
import 'package:vine_butler/data/local/app_database.dart';
import 'package:vine_butler/data/remote/juso/juso_api.dart';
import 'package:vine_butler/data/remote/naver/geocode_api.dart';
import 'package:vine_butler/data/repository/address_repository_impl.dart';
import 'package:vine_butler/data/repository/property_repository_impl.dart';
import 'package:vine_butler/domain/repository/address_repository.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';
import 'package:vine_butler/domain/usecase/address_usecase.dart';
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
