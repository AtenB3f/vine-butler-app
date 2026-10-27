import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/apply_property/apply_property_type_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_type_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';

void main() {
  late ProviderContainer container;

  ApplyPropertyTypeViewState state() => container.read(applyPropertyTypeVMProvider);
  void action(ApplyPropertyTypeAction action) => container.read(applyPropertyTypeVMProvider.notifier).action(action);

  setUp(() {
    container = ProviderContainer();
    container.listen(applyPropertyTypeVMProvider, (_, _) {});
    action(const ApplyPropertyTypeAction.selectTransactionType(PropertyTransactionType.rent));
  });

  tearDown(() => container.dispose());

  test('금액·월세·관리비는 0원에서 시작한다', () {
    expect(state().price, 0);
    expect(state().monthlyRent, 0);
    expect(state().maintenanceCost, 0);
  });

  test('입력한 금액·월세·관리비를 그대로 둔다', () {
    action(const ApplyPropertyTypeAction.changePrice(123456789));
    action(const ApplyPropertyTypeAction.changeMonthlyRent(555555));
    action(const ApplyPropertyTypeAction.changeMaintenanceCost(70000));

    expect(state().price, 123456789);
    expect(state().monthlyRent, 555555);
    expect(state().maintenanceCost, 70000);
  });

  test('거래 유형을 바꿔도 입력한 금액·월세·관리비를 유지한다', () {
    action(const ApplyPropertyTypeAction.changePrice(50000000));
    action(const ApplyPropertyTypeAction.changeMonthlyRent(500000));
    action(const ApplyPropertyTypeAction.changeMaintenanceCost(150000));

    action(const ApplyPropertyTypeAction.selectTransactionType(PropertyTransactionType.buy));

    expect(state().price, 50000000);
    expect(state().monthlyRent, 500000);
    expect(state().maintenanceCost, 150000);
  });

  group('다음 버튼', () {
    test('금액이 0원이면 완료가 아니고 다음으로 가지 않는다', () {
      action(const ApplyPropertyTypeAction.selectPropertyType(PropertyTypeFilterOption.villa));
      action(const ApplyPropertyTypeAction.changeMonthlyRent(500000));

      action(const ApplyPropertyTypeAction.next());

      expect(state().isCompleted, isFalse);
      expect(state().navigateTo, isNull);
    });

    test('월세 거래는 금액과 월세가 모두 있어야 완료다', () {
      action(const ApplyPropertyTypeAction.selectPropertyType(PropertyTypeFilterOption.villa));
      action(const ApplyPropertyTypeAction.changePrice(10000000));

      expect(state().isCompleted, isFalse);

      action(const ApplyPropertyTypeAction.changeMonthlyRent(500000));

      expect(state().isCompleted, isTrue);
    });

    test('매매·전세는 월세가 0원이어도 금액만 있으면 완료다', () {
      action(const ApplyPropertyTypeAction.selectTransactionType(PropertyTransactionType.buy));
      action(const ApplyPropertyTypeAction.selectPropertyType(PropertyTypeFilterOption.villa));
      action(const ApplyPropertyTypeAction.changePrice(300000000));

      expect(state().isCompleted, isTrue);
    });
  });

  group('금액 입력 칸', () {
    test('월세 거래면 금액 → 월세 → 관리비 순서로 넘어가고 마지막에 닫는다', () {
      action(const ApplyPropertyTypeAction.edit(ApplyPropertyPriceField.price));

      action(const ApplyPropertyTypeAction.nextField());

      expect(state().editingField, ApplyPropertyPriceField.monthlyRent);

      action(const ApplyPropertyTypeAction.nextField());

      expect(state().editingField, ApplyPropertyPriceField.maintenanceCost);

      action(const ApplyPropertyTypeAction.nextField());

      expect(state().editingField, isNull);
    });

    test('월세 거래가 아니면 금액 다음에 관리비로 넘어간다', () {
      action(const ApplyPropertyTypeAction.selectTransactionType(PropertyTransactionType.buy));
      action(const ApplyPropertyTypeAction.edit(ApplyPropertyPriceField.price));

      action(const ApplyPropertyTypeAction.nextField());

      expect(state().editingField, ApplyPropertyPriceField.maintenanceCost);
    });

    test('월세 입력 중에 월세가 없는 거래로 바꾸면 입력을 닫는다', () {
      action(const ApplyPropertyTypeAction.edit(ApplyPropertyPriceField.monthlyRent));

      action(const ApplyPropertyTypeAction.selectTransactionType(PropertyTransactionType.buy));

      expect(state().editingField, isNull);
    });
  });

  test('구독하는 화면이 없어지면 처음 상태로 돌아간다', () async {
    final fresh = ProviderContainer();
    final subscription = fresh.listen(applyPropertyTypeVMProvider, (_, _) {});

    fresh.read(applyPropertyTypeVMProvider.notifier)
      ..action(const ApplyPropertyTypeAction.selectTransactionType(PropertyTransactionType.buy))
      ..action(const ApplyPropertyTypeAction.changePrice(300000000));
    subscription.close();
    await Future<void>.delayed(Duration.zero);

    final reopened = fresh.read(applyPropertyTypeVMProvider);

    expect(reopened.transactionType, isNull);
    expect(reopened.price, 0);
    fresh.dispose();
  });
}
