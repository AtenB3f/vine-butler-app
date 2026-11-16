import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/components/components.dart';

void main() {
  const sideKey = Key('side');
  final handle = find.byWidgetPredicate((widget) => widget is MouseRegion && widget.cursor == SystemMouseCursors.resizeLeftRight);

  Future<List<double>> pumpSplit(WidgetTester tester, {required double totalWidth, required double sideWidth}) async {
    final resized = <double>[];

    tester.view.physicalSize = Size(totalWidth, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: DesktopSplitView(
          viewState: DesktopSplitViewState(sideWidth: sideWidth),
          side: const SizedBox.expand(key: sideKey),
          content: const SizedBox.expand(),
          onResize: resized.add,
          onResizeEnd: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    return resized;
  }

  testWidgets('사이드 너비가 최소보다 작으면 최소 너비로 그린다', (tester) async {
    await pumpSplit(tester, totalWidth: 1000, sideWidth: 200);

    expect(tester.getSize(find.byKey(sideKey)).width, 360);
  });

  testWidgets('콘텐츠도 최소 너비를 남기도록 사이드 너비를 줄인다', (tester) async {
    await pumpSplit(tester, totalWidth: 1000, sideWidth: 900);

    expect(tester.getSize(find.byKey(sideKey)).width, 640);
  });

  testWidgets('전체 너비가 최소의 2배 이하면 조절 손잡이가 없다', (tester) async {
    await pumpSplit(tester, totalWidth: 720, sideWidth: 360);

    expect(handle, findsNothing);
  });

  testWidgets('사이드는 오른쪽에 그린다', (tester) async {
    await pumpSplit(tester, totalWidth: 1000, sideWidth: 400);

    expect(tester.getTopLeft(find.byKey(sideKey)).dx, 600);
  });

  testWidgets('손잡이를 왼쪽으로 끌면 사이드 너비가 늘어난다', (tester) async {
    final resized = await pumpSplit(tester, totalWidth: 1000, sideWidth: 360);

    await tester.drag(handle, const Offset(-100, 0));

    expect(resized.last, closeTo(460, 20));
  });

  testWidgets('사이드가 닫히는 동안 마지막으로 열려 있던 사이드를 보여준다', (tester) async {
    Widget split(DesktopSplitType type, Widget side) {
      return MaterialApp(
        home: DesktopSplitView(
          viewState: DesktopSplitViewState(sideWidth: 360, type: type),
          side: side,
          content: const SizedBox.expand(),
          onResize: (_) {},
          onResizeEnd: () {},
        ),
      );
    }

    tester.view.physicalSize = const Size(1000, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(split(DesktopSplitType.two, const Text('매물 A')));
    await tester.pumpAndSettle();
    await tester.pumpWidget(split(DesktopSplitType.one, const SizedBox.shrink()));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('매물 A'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('매물 A'), findsNothing);
  });
}
