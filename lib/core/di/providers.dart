import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/data/local/app_database.dart';
import 'package:vine_butler/data/repository/property_repository_impl.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final propertyRepositoryProvider = Provider<PropertyRepository>(
  (ref) => PropertyRepositoryImpl(ref.watch(appDatabaseProvider)),
);
