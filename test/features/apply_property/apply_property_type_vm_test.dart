import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/apply_property/apply_property_type_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_type_view_state.dart';

void main() {
  late ProviderContainer container;

  ApplyPropertyTypeViewState state() => container.read(applyPropertyTypeVMProvider);
  void action(ApplyPropertyTypeAction action) => container.read(applyPropertyTypeVMProvider.notifier).action(action);

  setUp(() {
    container = ProviderContainer();
    action(const ApplyPropertyTypeAction.selectTransactionType(PropertyTransactionType.rent));
  });

  tearDown(() => container.dispose());

  group('금액', () {
    test('최대보다 큰 값도 입력한 그대로 둔다', () {
      action(ApplyPropertyTypeAction.changePrice(state().maxPrice + 1));

      expect(state().price, state().maxPrice + 1);
    });

    test('최소보다 작은 값도 입력한 그대로 둔다', () {
      action(ApplyPropertyTypeAction.changePrice(state().minPrice - 1));

      expect(state().price, state().minPrice - 1);
    });

    test('범위 안이면 입력한 값 그대로 둔다', () {
      action(const ApplyPropertyTypeAction.changePrice(123456789));

      expect(state().price, 123456789);
    });
  });

  group('월세', () {
    test('최대보다 큰 값도 입력한 그대로 둔다', () {
      action(const ApplyPropertyTypeAction.changeMonthlyRent(ApplyPropertyTypeViewState.maxMonthlyRent + 1));

      expect(state().monthlyRent, ApplyPropertyTypeViewState.maxMonthlyRent + 1);
    });

    test('최소보다 작은 값도 입력한 그대로 둔다', () {
      action(const ApplyPropertyTypeAction.changeMonthlyRent(0));

      expect(state().monthlyRent, 0);
    });

    test('범위 안이면 입력한 값 그대로 둔다', () {
      action(const ApplyPropertyTypeAction.changeMonthlyRent(555555));

      expect(state().monthlyRent, 555555);
    });
  });

  group('거래 유형 전환', () {
    test('입력한 금액이 새 범위 안이면 그대로 둔다', () {
      action(const ApplyPropertyTypeAction.changePrice(300000000));

      action(const ApplyPropertyTypeAction.selectTransactionType(PropertyTransactionType.depositOnly));

      expect(state().price, 300000000);
    });

    test('입력한 금액이 새 범위 밖이면 새 범위의 중간값으로 바꾼다', () {
      action(const ApplyPropertyTypeAction.changePrice(50000000));

      action(const ApplyPropertyTypeAction.selectTransactionType(PropertyTransactionType.buy));

      expect(state().price, state().midPrice);
    });
  });

  group('관리비', () {
    test('기본값은 10만원이다', () {
      expect(state().maintenanceCost, 100000);
    });

    test('0원과 범위 밖 값도 입력한 그대로 둔다', () {
      action(const ApplyPropertyTypeAction.changeMaintenanceCost(0));

      expect(state().maintenanceCost, 0);

      action(const ApplyPropertyTypeAction.changeMaintenanceCost(ApplyPropertyTypeViewState.maxMaintenanceCost + 1));

      expect(state().maintenanceCost, ApplyPropertyTypeViewState.maxMaintenanceCost + 1);
    });

    test('거래 유형을 바꿔도 유지한다', () {
      action(const ApplyPropertyTypeAction.changeMaintenanceCost(150000));

      action(const ApplyPropertyTypeAction.selectTransactionType(PropertyTransactionType.buy));

      expect(state().maintenanceCost, 150000);
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
}
