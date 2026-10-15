import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/data/local/app_database.dart';
import 'package:vine_butler/data/repository/property_repository_impl.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/model/property_image.dart';
import 'package:vine_butler/domain/property_type.dart';

PropertyImage _image(String id, int order) {
  return PropertyImage(id: id, fileName: '$id.jpg', order: order, createdAt: DateTime(2020));
}

Property _property(String id, {List<PropertyImage> images = const []}) {
  return Property(
    id: id,
    owner: const Owner(name: '홍길동', phone: '010-1234-5678'),
    propertyType: PropertyType.apartment,
    deal: const PropertyDeal(transactionType: PropertyTransactionType.rent, price: 10000000, monthlyRent: 500000),
    address: const Address(
      zipCode: '06236',
      roadAddress: '서울 강남구 테헤란로 1',
      lotAddress: '역삼동 1-1',
      sido: '서울특별시',
      sigungu: '강남구',
      dongMyeon: '역삼동',
      buildingName: '역삼빌딩',
      latitude: 37.5006,
      longitude: 127.0364,
    ),
    furnitureOptions: const ['침대', '냉장고'],
    images: images,
    updatedAt: DateTime(2020),
  );
}

void main() {
  late AppDatabase db;
  late PropertyRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = PropertyRepositoryImpl(db);
  });

  tearDown(() => db.close());

  test('저장 후 조회하면 값이 그대로 복원되고 동기화 필요 상태다', () async {
    await repository.save(_property('a'));

    final saved = await repository.getById('a');

    expect(saved, isNotNull);
    expect(saved!.furnitureOptions, ['침대', '냉장고']);
    expect(saved.deal, const PropertyDeal(transactionType: PropertyTransactionType.rent, price: 10000000, monthlyRent: 500000));
    expect(saved.owner, const Owner(name: '홍길동', phone: '010-1234-5678'));
    expect(saved.address.roadAddress, '서울 강남구 테헤란로 1');
    expect(saved.address.sido, '서울특별시');
    expect(saved.address.sigungu, '강남구');
    expect(saved.address.dongMyeon, '역삼동');
    expect(saved.address.buildingName, '역삼빌딩');
    expect(saved.address.latitude, 37.5006);
    expect(saved.address.longitude, 127.0364);
    expect(saved.syncedAt, isNull);
    expect(saved.needsSync, isTrue);
    expect(saved.updatedAt.isAfter(DateTime(2020)), isTrue);
  });

  test('같은 id로 저장하면 덮어쓴다', () async {
    await repository.save(_property('a'));
    await repository.save(_property('a').copyWith(memo: '수정'));

    final all = await repository.watchAll().first;

    expect(all, hasLength(1));
    expect(all.single.memo, '수정');
  });

  test('삭제하면 목록과 단건 조회에서 제외되지만 행은 남는다', () async {
    await repository.save(_property('a'));
    await repository.save(_property('b'));

    await repository.delete('a');

    expect(await repository.getById('a'), isNull);
    expect((await repository.watchAll().first).map((p) => p.id), ['b']);
    expect(await db.select(db.propertyTable).get(), hasLength(2));
  });

  test('이미지는 order 순서대로 복원되고 이미지가 없으면 빈 목록이다', () async {
    await repository.save(_property('a', images: [_image('i2', 1), _image('i1', 0)]));
    await repository.save(_property('b'));

    final all = await repository.watchAll().first;
    final a = all.firstWhere((p) => p.id == 'a');
    final b = all.firstWhere((p) => p.id == 'b');

    expect(a.images.map((i) => i.fileName), ['i1.jpg', 'i2.jpg']);
    expect(b.images, isEmpty);
    expect(all, hasLength(2));
  });

  test('이미지를 다시 저장하면 기존 이미지가 교체된다', () async {
    await repository.save(_property('a', images: [_image('i1', 0), _image('i2', 1)]));
    await repository.save(_property('a', images: [_image('i3', 0)]));

    final saved = await repository.getById('a');

    expect(saved!.images.map((i) => i.id), ['i3']);
    expect(await db.select(db.propertyImageTable).get(), hasLength(1));
  });

  test('소프트 삭제해도 이미지 행은 남는다', () async {
    await repository.save(_property('a', images: [_image('i1', 0)]));

    await repository.delete('a');

    expect(await repository.getById('a'), isNull);
    expect(await db.select(db.propertyImageTable).get(), hasLength(1));
  });

  test('동기화된 매물을 다시 저장하면 동기화 필요 상태가 된다', () async {
    final synced = _property('a').copyWith(updatedAt: DateTime(2020), syncedAt: DateTime(2020));

    expect(synced.needsSync, isFalse);

    await repository.save(synced);

    final saved = await repository.getById('a');

    expect(saved!.syncedAt, DateTime(2020));
    expect(saved.needsSync, isTrue);
  });

  test('동기화된 매물을 삭제하면 동기화 필요 상태가 된다', () async {
    await repository.save(_property('a'));
    await (db.update(db.propertyTable)..where((t) => t.id.equals('a')))
        .write(PropertyTableCompanion(syncedAt: Value(DateTime(2020))));

    await repository.delete('a');

    final row = await db.select(db.propertyTable).getSingle();

    expect(row.deletedAt, isNotNull);
    expect(row.updatedAt.isAfter(row.syncedAt!), isTrue);
  });
}
