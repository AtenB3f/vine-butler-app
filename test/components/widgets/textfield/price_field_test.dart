import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/components/components.dart';

void main() {
  Future<void> pump(WidgetTester tester, PriceFieldViewState viewState, {VoidCallback? onTap, VoidCallback? onClear}) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PriceField(viewState: viewState, onTap: onTap ?? () {}, onClear: onClear ?? () {}),
        ),
      ),
    );
  }

  testWidgets('보조 줄이 없으면 금액만 보인다', (tester) async {
    await pump(tester, const PriceFieldViewState(text: '0원'));

    expect(find.text('0원'), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
  });

  testWidgets('금액과 보조 줄을 보여주고 칸을 누르면 onTap을 부른다', (tester) async {
    var isTapped = false;

    await pump(tester, const PriceFieldViewState(text: '8만원', subText: '80,000원'), onTap: () => isTapped = true);
    await tester.tap(find.text('8만원'));

    expect(find.text('80,000원'), findsOneWidget);
    expect(isTapped, isTrue);
  });

  testWidgets('입력 중일 때만 지우기 버튼이 보이고 누르면 onClear를 부른다', (tester) async {
    var isCleared = false;

    await pump(tester, const PriceFieldViewState(text: '8만원'));

    expect(find.byType(SvgPicture), findsNothing);

    await pump(tester, const PriceFieldViewState(text: '8만원', isFocused: true), onClear: () => isCleared = true);
    await tester.tap(find.byType(SvgPicture));

    expect(isCleared, isTrue);
  });
}
