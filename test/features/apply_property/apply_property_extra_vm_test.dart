import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/apply_property/apply_property_address_vm.dart';
import 'package:vine_butler/features/apply_property/apply_property_extra_vm.dart';
import 'package:vine_butler/features/apply_property/apply_property_owner_vm.dart';
import 'package:vine_butler/features/apply_property/apply_property_type_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_address_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/property_list_event_vm.dart';

import '../../helpers/fakes/fake_address_repository.dart';
import '../../helpers/fakes/fake_property_repository.dart';
import '../../helpers/fixtures.dart';

void main() {
  late FakePropertyRepository repository;
  late ProviderContainer container;

  void extra(ApplyPropertyExtraAction action) => container.read(applyPropertyExtraVMProvider.notifier).action(action);

  Future<void> fillRequired() async {
    final type = container.read(applyPropertyTypeVMProvider.notifier);
    final address = container.read(applyPropertyAddressVMProvider.notifier);
    final owner = container.read(applyPropertyOwnerVMProvider.notifier);

    type.action(const ApplyPropertyTypeAction.selectTransactionType(PropertyTransactionType.rent));
    type.action(const ApplyPropertyTypeAction.selectPropertyType(PropertyTypeFilterOption.singleMulti));
    type.action(const ApplyPropertyTypeAction.changePrice(10000000));
    type.action(const ApplyPropertyTypeAction.changeMonthlyRent(500000));
    type.action(const ApplyPropertyTypeAction.changeMaintenanceCost(100000));
    address.action(ApplyPropertyAddressAction.select(AddressResultViewState.fromDomain(bundangCandidate)));
    await Future<void>.delayed(Duration.zero);
    address.action(const ApplyPropertyAddressAction.inputDetail(' 202호 '));
    owner.action(const ApplyPropertyOwnerAction.changeName('홍길동'));
    owner.action(const ApplyPropertyOwnerAction.changePhone('010-1234-5678'));
  }

  Future<void> save() async {
    extra(const ApplyPropertyExtraAction.save());
    await Future<void>.delayed(Duration.zero);
  }

  setUp(() {
    repository = FakePropertyRepository();
    container = ProviderContainer(
      overrides: [
        addressRepositoryProvider.overrideWithValue(FakeAddressRepository(addresses: const [bundangCandidate])),
        propertyRepositoryProvider.overrideWithValue(repository),
      ],
    );
    container.listen(applyPropertyTypeVMProvider, (_, _) {});
    container.listen(applyPropertyAddressVMProvider, (_, _) {});
    container.listen(applyPropertyOwnerVMProvider, (_, _) {});
    container.listen(applyPropertyExtraVMProvider, (_, _) {});
    container.listen(propertyListEventVMProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  test('등록 단계 입력값을 모아 저장한다', () async {
    await fillRequired();
    extra(const ApplyPropertyExtraAction.selectLoan(true));
    extra(const ApplyPropertyExtraAction.selectRoomCount(2));
    extra(const ApplyPropertyExtraAction.toggleFurniture('냉장고'));
    extra(const ApplyPropertyExtraAction.changeMemo(' 메모 '));

    await save();

    final property = repository.saved.single;

    expect(property.owner, const Owner(name: '홍길동', phone: '010-1234-5678'));
    expect(property.propertyType, PropertyType.detachedHouse);
    expect(property.deal, const PropertyDeal(transactionType: PropertyTransactionType.rent, price: 10000000, monthlyRent: 500000));
    expect(property.maintenanceCost, 100000);
    expect(property.address.roadAddress, bundangCandidate.roadAddress);
    expect(property.address.detailAddress, '202호');
    expect(property.address.latitude, 37.3595033);
    expect(property.hasLoan, isTrue);
    expect(property.roomCount, 2);
    expect(property.furnitureOptions, ['냉장고']);
    expect(property.memo, '메모');
  });

  test('관리비 0원은 0으로 저장한다', () async {
    await fillRequired();
    container.read(applyPropertyTypeVMProvider.notifier).action(const ApplyPropertyTypeAction.changeMaintenanceCost(0));

    await save();

    expect(repository.saved.single.maintenanceCost, 0);
  });

  test('월세가 아니면 월세 금액을 저장하지 않는다', () async {
    await fillRequired();
    container.read(applyPropertyTypeVMProvider.notifier)
        .action(const ApplyPropertyTypeAction.selectTransactionType(PropertyTransactionType.depositOnly));

    await save();

    expect(repository.saved.single.deal.monthlyRent, isNull);
  });

  test('필수값이 없으면 저장하지 않는다', () async {
    await save();

    expect(repository.saved, isEmpty);
    expect(container.read(applyPropertyExtraVMProvider).navigateTo, isNull);
  });

  test('저장하면 등록 이벤트를 보내고 목록으로 이동하며 등록 단계를 초기화한다', () async {
    await fillRequired();
    extra(const ApplyPropertyExtraAction.changeMemo('메모'));

    await save();

    expect(container.read(propertyListEventVMProvider).registerId, repository.saved.single.id);
    expect(container.read(applyPropertyExtraVMProvider).navigateTo, const PropertyListRoute().location);
    expect(container.read(applyPropertyExtraVMProvider).memo, '');
    expect(container.read(applyPropertyTypeVMProvider).transactionType, isNull);
    expect(container.read(applyPropertyAddressVMProvider).located, isNull);
    expect(container.read(applyPropertyOwnerVMProvider).name, '');
  });

  test('저장에 실패하면 오류 메시지를 보내고 입력값을 유지한다', () async {
    repository.shouldFailSave = true;
    await fillRequired();

    await save();

    final state = container.read(applyPropertyExtraVMProvider);

    expect(state.errorMessage, isNotNull);
    expect(state.isSaving, isFalse);
    expect(state.navigateTo, isNull);
    expect(container.read(applyPropertyOwnerVMProvider).name, '홍길동');
  });
}
