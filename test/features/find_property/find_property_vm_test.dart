import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';
import 'package:vine_butler/features/find_property/find_property_vm.dart';
import 'package:vine_butler/features/find_property/presentation/find_property_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/property_list_vm.dart';

class _FakePropertyRepository implements PropertyRepository {
  final List<PropertySearchCondition> requests = [];

  @override
  Stream<List<Property>> watchFilter(PropertySearchCondition condition) {
    requests.add(condition);
    return const Stream.empty();
  }

  @override
  Stream<List<Property>> watchList() => const Stream.empty();

  @override
  Future<Property?> getById(String id) async => null;

  @override
  Future<void> save(Property property) async {}

  @override
  Future<void> delete(String id) async {}
}

void main() {
  late _FakePropertyRepository repository;
  late ProviderContainer container;

  FindPropertyViewState state() => container.read(findPropertyVMProvider);
  void action(FindPropertyAction action) => container.read(findPropertyVMProvider.notifier).action(action);

  setUp(() {
    repository = _FakePropertyRepository();
    container = ProviderContainer(overrides: [propertyRepositoryProvider.overrideWithValue(repository)]);
    container.listen(findPropertyVMProvider, (_, _) {});
    container.listen(propertyListVMProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  test('다음을 누르면 고른 조건으로 매물 탭 필터를 적용하고 검색어를 비우며 패널을 닫는다', () {
    container.read(propertyListVMProvider.notifier)
      ..action(const PropertyListAction.search('테헤란'))
      ..action(const PropertyListAction.panel(true));
    action(const FindPropertyAction.selectTransactionType(PropertyTransactionType.rent));
    action(const FindPropertyAction.togglePropertyType(PropertyTypeFilterOption.villa));
    action(const FindPropertyAction.changePrice(100000000));

    action(const FindPropertyAction.next());

    final list = container.read(propertyListVMProvider);

    expect(list.filter.data.transactionType, PropertyTransactionType.rent);
    expect(list.filter.data.propertyTypes, {PropertyType.villa});
    expect(list.filter.data.price, 100000000);
    expect(list.query, '');
    expect(list.filter.isFilterOpen, isFalse);
    expect(
      repository.requests.last,
      const PropertySearchCondition(
        transactionType: PropertyTransactionType.rent,
        propertyTypes: {PropertyType.villa},
        price: 100000000,
      ),
    );
  });

  test('다음을 누르면 매물 탭으로 이동하고 찾기 화면을 초기화한다', () {
    action(const FindPropertyAction.selectTransactionType(PropertyTransactionType.buy));
    action(const FindPropertyAction.togglePropertyType(PropertyTypeFilterOption.apartment));

    action(const FindPropertyAction.next());

    expect(state().navigateTo, const PropertyListRoute().location);
    expect(state().transactionType, isNull);
    expect(state().propertyTypes, isEmpty);
    expect(state().price, FindPropertyViewState.initial().price);
  });

  test('이동 이벤트를 소비하면 비운다', () {
    action(const FindPropertyAction.next());

    container.read(findPropertyVMProvider.notifier).navigate();

    expect(state().navigateTo, isNull);
  });
}
