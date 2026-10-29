import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/components/components.dart';

void main() {
  Future<int> pumpKeypad(WidgetTester tester, int value, {VoidCallback? onConfirm}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => PriceKeypad(
              viewState: PriceKeypadViewState(value: value),
              onChanged: (next) => setState(() => value = next),
              onConfirm: onConfirm ?? () {},
            ),
          ),
        ),
      ),
    );
    return value;
  }

  Future<List<int>> tapKeys(WidgetTester tester, int value, List<String> labels) async {
    final changes = <int>[];
    var current = value;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => PriceKeypad(
              viewState: PriceKeypadViewState(value: current),
              onChanged: (next) {
                changes.add(next);
                setState(() => current = next);
              },
              onConfirm: () {},
            ),
          ),
        ),
      ),
    );

    for (final label in labels) {
      await tester.tap(label == '⌫' ? find.byType(Pressable).at(3) : find.text(label));
      await tester.pump();
    }
    return changes;
  }

  testWidgets('숫자·00·,000 키는 끝에 숫자를 붙인다', (tester) async {
    expect(await tapKeys(tester, 0, ['1', '2', '00', ',000']), [1, 12, 1200, 1200000]);
  });

  testWidgets('만·억은 그때까지 입력한 숫자에 단위를 붙여 더한다', (tester) async {
    expect((await tapKeys(tester, 0, ['1', '2', '억', '3', ',000', '만'])).last, 1230000000);
  });

  testWidgets('단위를 연달아 누르면 0을 더해 금액이 그대로다', (tester) async {
    expect(await tapKeys(tester, 0, ['1', '2', '억', '만']), [1, 12, 1200000000]);
  });

  testWidgets('단위 직후 0·00·,000은 전체 금액에 곱한다', (tester) async {
    expect((await tapKeys(tester, 0, ['1', '억', '0'])).last, 1000000000);
    expect((await tapKeys(tester, 0, ['1', '억', ',000'])).last, 100000000000);
    expect((await tapKeys(tester, 0, ['5', '만', '00'])).last, 5000000);
    expect((await tapKeys(tester, 0, ['1', '2', '억', '3', ',000', '만', '0'])).last, 12300000000);
  });

  testWidgets('칸을 막 열었을 때 0은 기존 금액에 곱한다', (tester) async {
    expect(await tapKeys(tester, 80000, ['0']), [800000]);
  });

  testWidgets('같은 단위를 다시 쓰면 더한다', (tester) async {
    expect((await tapKeys(tester, 0, ['3', '억', '2', '억'])).last, 500000000);
  });

  testWidgets('기존 금액이 있으면 그 금액에 이어서 입력한다', (tester) async {
    expect(await tapKeys(tester, 80000, ['3', '만']), [80003, 110000]);
  });

  testWidgets('지우기는 입력 중인 숫자부터, 없으면 금액의 마지막 자리를 지운다', (tester) async {
    expect(await tapKeys(tester, 0, ['1', '2', '억', '3', '⌫']), [1, 12, 1200000000, 1200000003, 1200000000]);
    expect(await tapKeys(tester, 1200000000, ['⌫']), [120000000]);
  });

  testWidgets('바깥에서 금액이 바뀌면 그 금액에서 다시 시작한다', (tester) async {
    await tapKeys(tester, 0, ['1', '2']);
    await pumpKeypad(tester, 0);

    expect(await tapKeys(tester, 0, ['만']), isEmpty);
  });

  testWidgets('0일 때 0을 붙이거나 상한을 넘는 입력은 무시한다', (tester) async {
    expect(await tapKeys(tester, 0, ['0', '00', '만']), isEmpty);
    expect(await tapKeys(tester, 0, ['1', '0', '0', '0', '0', '억']), [1, 10, 100, 1000, 10000, PriceKeypad.maxValue]);
    expect(await tapKeys(tester, PriceKeypad.maxValue, ['1', '억']), isEmpty);
  });

  testWidgets('확인 키를 누르면 onConfirm을 부른다', (tester) async {
    var isConfirmed = false;

    await pumpKeypad(tester, 0, onConfirm: () => isConfirmed = true);
    await tester.tap(find.byType(Pressable).last);

    expect(isConfirmed, isTrue);
  });

  testWidgets('animated는 키패드가 생기면 올리고 없어지면 내려서 placeholder만 남긴다', (tester) async {
    Future<void> pumpAnimated(PriceKeypad? keypad) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PriceKeypad.animated(keypad: keypad, placeholder: const Text('다음')),
          ),
        ),
      );
    }

    await pumpAnimated(null);

    expect(find.byType(PriceKeypad), findsNothing);

    await pumpAnimated(PriceKeypad(viewState: const PriceKeypadViewState(value: 0), onChanged: (_) {}, onConfirm: () {}));
    await tester.pump(const Duration(milliseconds: 100));

    final movingTop = tester.getTopLeft(find.byType(PriceKeypad)).dy;

    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.byType(PriceKeypad)).dy, lessThan(movingTop));
    expect(find.text('다음'), findsNothing);

    await pumpAnimated(null);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(PriceKeypad), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(PriceKeypad), findsNothing);
    expect(find.text('다음'), findsOneWidget);
  });
}
