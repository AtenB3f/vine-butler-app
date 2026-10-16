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
import 'package:vine_butler/domain/model/property_search_condition.dart';
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
    expect(saved.address.latitude, 37.5006);
    expect(saved.address.longitude, 127.0364);
    expect(saved.syncedAt, isNull);
    expect(saved.needsSync, isTrue);
    expect(saved.updatedAt.isAfter(DateTime(2020)), isTrue);
  });

  test('상세 주소, 단독/다가구 유형, 관리비를 저장하고 복원한다', () async {
    final property = _property('a');

    await repository.save(
      property.copyWith(
        maintenanceCost: 0,
        propertyType: PropertyType.detachedHouse,
        address: property.address.copyWith(detailAddress: '202호'),
      ),
    );

    final saved = await repository.getById('a');

    expect(saved!.propertyType, PropertyType.detachedHouse);
    expect(saved.address.detailAddress, '202호');
    expect(saved.maintenanceCost, 0);
  });

  test('같은 id로 저장하면 덮어쓴다', () async {
    await repository.save(_property('a'));
    await repository.save(_property('a').copyWith(memo: '수정'));

    final all = await repository.watchList().first;

    expect(all, hasLength(1));
    expect(all.single.memo, '수정');
  });

  test('삭제하면 목록과 단건 조회에서 제외되지만 행은 남는다', () async {
    await repository.save(_property('a'));
    await repository.save(_property('b'));

    await repository.delete('a');

    expect(await repository.getById('a'), isNull);
    expect((await repository.watchList().first).map((p) => p.id), ['b']);
    expect(await db.select(db.propertyTable).get(), hasLength(2));
  });

  test('이미지는 order 순서대로 복원되고 이미지가 없으면 빈 목록이다', () async {
    await repository.save(_property('a', images: [_image('i2', 1), _image('i1', 0)]));
    await repository.save(_property('b'));

    final all = await repository.watchList().first;
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

  group('watchFilter', () {
    Property listed(
      String id, {
      PropertyTransactionType transactionType = PropertyTransactionType.rent,
      PropertyType propertyType = PropertyType.apartment,
      int price = 10000000,
      String roadAddress = '서울 강남구 테헤란로 1',
      String lotAddress = '역삼동 1-1',
      String detailAddress = '',
    }) {
      final property = _property(id);

      return property.copyWith(
        propertyType: propertyType,
        deal: PropertyDeal(transactionType: transactionType, price: price),
        address: property.address.copyWith(roadAddress: roadAddress, lotAddress: lotAddress, detailAddress: detailAddress),
      );
    }

    Future<List<String>> ids(PropertySearchCondition condition) async {
      final properties = await repository.watchFilter(condition).first;

      return properties.map((property) => property.id).toList();
    }

    test('이미지가 여러 장이어도 매물은 한 번만 나오고 이미지를 순서대로 붙인다', () async {
      await repository.save(listed('a').copyWith(images: [_image('i2', 1), _image('i1', 0), _image('i3', 2)]));
      await repository.save(listed('b'));

      final properties = await repository.watchFilter(const PropertySearchCondition()).first;

      expect(properties.map((property) => property.id), unorderedEquals(['a', 'b']));
      expect(properties.firstWhere((property) => property.id == 'a').images.map((image) => image.id), ['i1', 'i2', 'i3']);
    });

    test('삭제한 매물은 제외한다', () async {
      await repository.save(listed('a'));
      await repository.save(listed('b'));
      await repository.delete('a');

      expect(await ids(const PropertySearchCondition()), ['b']);
    });

    test('거래 유형과 건물 유형이 일치하는 매물만 가져온다', () async {
      await repository.save(listed('rentVilla', propertyType: PropertyType.villa));
      await repository.save(listed('buyVilla', transactionType: PropertyTransactionType.buy, propertyType: PropertyType.villa));
      await repository.save(listed('rentApartment'));

      expect(
        await ids(const PropertySearchCondition(transactionType: PropertyTransactionType.rent, propertyTypes: {PropertyType.villa})),
        ['rentVilla'],
      );
    });

    test('검색어가 도로명·지번·상세 주소 중 하나에 포함되면 가져온다', () async {
      await repository.save(listed('road', roadAddress: '서울 마포구 월드컵로 1'));
      await repository.save(listed('lot', lotAddress: '마포동 1-1'));
      await repository.save(listed('detail', detailAddress: '마포아파트 101호'));
      await repository.save(listed('none'));

      expect(await ids(const PropertySearchCondition(keyword: '마포')), unorderedEquals(['detail', 'lot', 'road']));
    });

    test('검색어의 %와 _는 문자 그대로 찾는다', () async {
      await repository.save(listed('percent', detailAddress: '100%'));
      await repository.save(listed('plain', detailAddress: '1000'));

      expect(await ids(const PropertySearchCondition(keyword: '0%')), ['percent']);
    });

    test('금액 기준이 있으면 금액이 가까운 순으로 정렬한다', () async {
      await repository.save(listed('far', price: 100000000));
      await repository.save(listed('near', price: 52000000));
      await repository.save(listed('middle', price: 30000000));

      expect(await ids(const PropertySearchCondition(price: 50000000)), ['near', 'middle', 'far']);
    });
  });
}
