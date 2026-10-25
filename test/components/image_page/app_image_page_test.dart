import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/components/components.dart';

void main() {
  /// 1×1 투명 PNG
  final pixel = Uint8List.fromList(const [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
    0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
    0x42, 0x60, 0x82,
  ]);

  Future<void> pump(WidgetTester tester, AppImagePageViewState viewState, {ValueChanged<int>? onTap}) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(width: 300, height: 300, child: AppImagePage(viewState: viewState, onTap: onTap)),
        ),
      ),
    );
  }

  testWidgets('사진을 누르면 그 사진 번호로 onTap을 부른다', (tester) async {
    int? tapped;

    await pump(
      tester,
      AppImagePageViewState(images: [MemoryImage(pixel), MemoryImage(pixel)]),
      onTap: (index) => tapped = index,
    );
    await tester.tap(find.byType(PageView));

    expect(tapped, 0);
  });

  testWidgets('index 사진부터 보여주고 그 번호로 onTap을 부른다', (tester) async {
    int? tapped;

    await pump(
      tester,
      AppImagePageViewState(images: [MemoryImage(pixel), MemoryImage(pixel), MemoryImage(pixel)], index: 2),
      onTap: (index) => tapped = index,
    );
    await tester.tap(find.byType(PageView));

    expect(tapped, 2);
    expect(tester.widget<PageView>(find.byType(PageView)).controller?.initialPage, 2);
  });

  testWidgets('fit을 넘기면 사진에 그대로 쓴다', (tester) async {
    await pump(tester, AppImagePageViewState(images: [MemoryImage(pixel)], fit: BoxFit.contain));

    expect(tester.widget<Image>(find.byType(Image)).fit, BoxFit.contain);
  });
}
