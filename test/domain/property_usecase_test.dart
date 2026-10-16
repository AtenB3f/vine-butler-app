import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';
import 'package:vine_butler/domain/model/property_image.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';
import 'package:vine_butler/domain/usecase/property_usecase.dart';

class _FakePropertyRepository implements PropertyRepository {
  final List<Property> saved = [];

  @override
  Future<void> save(Property property) async => saved.add(property);

  @override
  Stream<List<Property>> watchList() => Stream.value(saved);

  @override
  Stream<List<Property>> watchFilter(PropertySearchCondition condition) => watchList();

  @override
  Future<Property?> getById(String id) async => null;

  @override
  Future<void> delete(String id) async {}
}

const _address = Address(
  zipCode: '06236',
  roadAddress: '서울 강남구 테헤란로 1',
  lotAddress: '역삼동 1-1',
  sido: '서울특별시',
  sigungu: '강남구',
  dongMyeon: '역삼동',
  latitude: 37.5006,
  longitude: 127.0364,
);

void main() {
  late _FakePropertyRepository repository;
  late PropertyUseCase useCase;

  setUp(() {
    repository = _FakePropertyRepository();
    useCase = PropertyUseCase(repository);
  });

  Future<String> create() {
    return useCase.create(
      owner: const Owner(name: '홍길동', phone: '010-1234-5678'),
      propertyType: PropertyType.apartment,
      deal: const PropertyDeal(transactionType: PropertyTransactionType.rent, price: 10000000, monthlyRent: 500000),
      address: _address,
    );
  }

  test('create는 UUID v4 id로 매물을 저장하고 그 id를 반환한다', () async {
    final id = await create();

    expect(id, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')));
    expect(repository.saved.single.id, id);
    expect(repository.saved.single.needsSync, isTrue);
  });

  test('create를 두 번 호출하면 서로 다른 id가 만들어진다', () async {
    final first = await create();
    final second = await create();

    expect(first, isNot(second));
  });

  test('create에 넘긴 이미지가 매물과 함께 저장된다', () async {
    final image = PropertyImage(id: 'i1', fileName: 'i1.jpg', order: 0, createdAt: DateTime(2020));

    await useCase.create(
      owner: const Owner(name: '홍길동', phone: '010-1234-5678'),
      propertyType: PropertyType.apartment,
      deal: const PropertyDeal(transactionType: PropertyTransactionType.buy, price: 500000000),
      address: _address,
      images: [image],
    );

    expect(repository.saved.single.images, [image]);
  });
}
