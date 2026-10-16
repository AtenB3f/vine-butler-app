import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';
import 'package:vine_butler/features/property_list/property_list_vm.dart';

class _FakePropertyRepository implements PropertyRepository {
  final StreamController<List<Property>> controller = StreamController<List<Property>>();

  @override
  Stream<List<Property>> watchAll() => controller.stream;

  @override
  Future<void> save(Property property) async {}

  @override
  Future<Property?> getById(String id) async => null;

  @override
  Future<void> delete(String id) async {}
}

Property _property({String detailAddress = '', int? roomCount}) {
  return Property(
    id: 'a',
    owner: const Owner(name: '홍길동', phone: '010-1234-5678'),
    propertyType: PropertyType.apartment,
    deal: const PropertyDeal(transactionType: PropertyTransactionType.rent, price: 10000000, monthlyRent: 500000),
    address: Address(
      zipCode: '06236',
      roadAddress: '서울 강남구 테헤란로 1',
      lotAddress: '역삼동 1-1',
      sido: '서울특별시',
      sigungu: '강남구',
      dongMyeon: '역삼동',
      detailAddress: detailAddress,
      latitude: 37.5006,
      longitude: 127.0364,
    ),
    roomCount: roomCount,
    updatedAt: DateTime(2020),
  );
}

void main() {
  late _FakePropertyRepository repository;
  late ProviderContainer container;

  PropertyListViewState state() => container.read(propertyListVMProvider);

  Future<void> emit(List<Property> properties) async {
    repository.controller.add(properties);
    await Future<void>.delayed(Duration.zero);
  }

  setUp(() {
    repository = _FakePropertyRepository();
    container = ProviderContainer(overrides: [propertyRepositoryProvider.overrideWithValue(repository)]);
    container.listen(propertyListVMProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  test('저장된 매물을 목록 항목으로 보여준다', () async {
    await emit([_property(detailAddress: '202호', roomCount: 2)]);

    final item = state().items.single;

    expect(item.id, 'a');
    expect(item.amount, 10000000);
    expect(item.monthlyAmount, 500000);
    expect(item.roadAddress, '서울 강남구 테헤란로 1, 202호');
    expect(item.jibunAddress, '역삼동 1-1');
    expect(item.tag, ['방 2개']);
  });

  test('상세 주소와 방 개수가 없으면 도로명 주소만 쓰고 태그가 없다', () async {
    await emit([_property()]);

    expect(state().items.single.roadAddress, '서울 강남구 테헤란로 1');
    expect(state().items.single.tag, isEmpty);
  });

  test('목록이 바뀌어도 검색어를 유지한다', () async {
    container.read(propertyListVMProvider.notifier).action(const PropertyListAction.search('테헤란'));

    await emit([_property()]);

    expect(state().query, '테헤란');
    expect(state().searchResults, hasLength(1));
  });
}
