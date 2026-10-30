import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/blog_post.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/property_list_vm.dart';

class _FakePropertyRepository implements PropertyRepository {
  final List<PropertySearchCondition> requests = [];
  StreamController<List<Property>> controller = StreamController<List<Property>>();

  @override
  Stream<List<Property>> watchList() => controller.stream;

  @override
  Stream<List<Property>> watchFilter(PropertySearchCondition condition) {
    requests.add(condition);
    controller = StreamController<List<Property>>();
    return controller.stream;
  }

  @override
  Future<void> save(Property property) async {}

  @override
  Future<Property?> getById(String id) async => null;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> saveBlogPost(String propertyId, BlogPost post) async {}
}

Property _property({String detailAddress = '', int? roomCount, bool? isParkingAvailable, bool? isSuretyInsuranceAvailable}) {
  return Property(
    id: 'a',
    owner: const Owner(name: '홍길동', phone: '010-1234-5678'),
    propertyType: PropertyType.apartment,
    deal: const PropertyDeal(transactionType: PropertyTransactionType.rent, price: 10000000, monthlyRent: 500000),
    address: Address(
      zipCode: '06236',
      roadAddress: '서울 강남구 테헤란로 1',
      lotAddress: '서울특별시 강남구 역삼동 1-1',
      sido: '서울특별시',
      sigungu: '강남구',
      dongMyeon: '역삼동',
      detailAddress: detailAddress,
      latitude: 37.5006,
      longitude: 127.0364,
    ),
    roomCount: roomCount,
    isParkingAvailable: isParkingAvailable,
    isSuretyInsuranceAvailable: isSuretyInsuranceAvailable,
    updatedAt: DateTime(2020),
  );
}

void main() {
  late _FakePropertyRepository repository;
  late ProviderContainer container;

  PropertyListViewState state() => container.read(propertyListVMProvider);
  void action(PropertyListAction action) => container.read(propertyListVMProvider.notifier).action(action);

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
    expect(item.address, '서울특별시 강남구 역삼동 1-1 202호');
    expect(item.tag, ['방 2개']);
  });

  test('상세 주소와 방 개수가 없으면 지번 주소만 쓰고 태그가 없다', () async {
    await emit([_property()]);

    expect(state().items.single.address, '서울특별시 강남구 역삼동 1-1');
    expect(state().items.single.tag, isEmpty);
  });

  test('주차 가능과 보증보험 가입 가능이면 태그로 보여준다', () async {
    await emit([_property(roomCount: 1, isParkingAvailable: true, isSuretyInsuranceAvailable: true)]);

    expect(state().items.single.tag, ['방 1개', '주차가능', '보증보험가입']);
  });

  test('주차 불가와 보증보험 가입 불가면 태그가 없다', () async {
    await emit([_property(isParkingAvailable: false, isSuretyInsuranceAvailable: false)]);

    expect(state().items.single.tag, isEmpty);
  });

  test('목록이 바뀌어도 검색어를 유지한다', () async {
    action(const PropertyListAction.search('테헤란'));

    await emit([_property()]);

    expect(state().query, '테헤란');
    expect(state().searchResults, hasLength(1));
  });

  group('검색 조건', () {
    test('처음에는 조건 없이 요청한다', () {
      expect(repository.requests.single, const PropertySearchCondition());
    });

    test('검색어가 바뀌면 검색어로 다시 요청한다', () {
      action(const PropertyListAction.search(' 테헤란 '));

      expect(repository.requests.last.keyword, '테헤란');
    });

    test('필터가 바뀌면 필터 조건으로 다시 요청한다', () {
      action(
        const PropertyListAction.filtering(
          PropertyFilterData(
            transactionType: PropertyTransactionType.rent,
            propertyTypes: {PropertyType.villa},
            price: 100000000,
          ),
        ),
      );

      expect(
        repository.requests.last,
        const PropertySearchCondition(
          transactionType: PropertyTransactionType.rent,
          propertyTypes: {PropertyType.villa},
          price: 100000000,
        ),
      );
    });

    test('금액이 최댓값이면 금액 정렬을 하지 않는다', () {
      action(const PropertyListAction.filtering(PropertyFilterData(transactionType: PropertyTransactionType.buy)));

      expect(repository.requests.last.price, isNull);
    });
  });

  test('필터를 바꿔도 검색어와 패널 상태를 유지하고 새 조건으로 다시 요청한다', () {
    action(const PropertyListAction.search('테헤란'));
    action(const PropertyListAction.panel(true));

    action(
      const PropertyListAction.filtering(
        PropertyFilterData(transactionType: PropertyTransactionType.buy, propertyTypes: {PropertyType.apartment}),
      ),
    );

    expect(state().query, '테헤란');
    expect(state().status, PropertySearchStatus.open);
    expect(state().filter.transactionType, PropertyTransactionType.buy);
    expect(
      repository.requests.last,
      const PropertySearchCondition(
        transactionType: PropertyTransactionType.buy,
        propertyTypes: {PropertyType.apartment},
        keyword: '테헤란',
      ),
    );
  });
}
