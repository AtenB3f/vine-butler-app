part of 'native_map.dart';

/// 지도 오버레이 이미지 생성
abstract final class _NativeMapImages {
  /// 유저 위치 이미지 생성
  static Future<({NOverlayImage image, Size size})> userLocation(double pixelRatio) async {
    const size = Size(58, 58);
    final center = size.center(Offset.zero);
    final recorder = ui.PictureRecorder();

    Paint strokePaint(Color color) {
      return Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
    }

    Canvas(recorder)
      ..scale(pixelRatio)
      ..drawCircle(center, 11, Paint()..color = MainColor.medium..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6))
      ..drawCircle(center, 11, Paint()..color = StateColor.dimmed..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2))
      ..drawCircle(center, 11, Paint()..color = MainColor.medium)
      ..drawCircle(center, 10.5, strokePaint(MainColor.dark))
      ..drawCircle(center, 4.8, Paint()..color = StateColor.white)
      ..drawCircle(center, 4.3, strokePaint(MainColor.dark));

    final image = await recorder.endRecording().toImage((size.width * pixelRatio).ceil(), (size.height * pixelRatio).ceil());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    image.dispose();
    return (
      image: await NOverlayImage.fromByteArray(bytes!.buffer.asUint8List(), cacheKey: 'user_location_$pixelRatio'),
      size: size,
    );
  }

  /// 모바일용 매물 마커 이미지
  static Future<({NOverlayImage image, Size size, double tipY})> marker(
    NaverMarkerViewState marker,
    ui.Picture pin,
    String pinState,
    double pixelRatio,
    TextScaler textScaler,
  ) async {
    final label = marker.label;
    final text = label == null
        ? null
        : (TextPainter(
            text: TextSpan(text: label, style: AppFontStyle.sub1.style(TextColor.dark)),
            textDirection: TextDirection.ltr,
            textScaler: textScaler,
          )..layout());
    final labelSize = text == null ? Size.zero : Size(text.width + 22, text.height + 10);
    final labelGap = text == null ? 0.0 : PinSpec.labelGap;
    final size = Size(
      math.max(labelSize.width, PinSpec.shape.width).ceilToDouble(),
      (labelSize.height + labelGap + PinSpec.shape.height).ceilToDouble(),
    );
    final labelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH((size.width - labelSize.width) / 2 + 0.5, 0.5, labelSize.width - 1, labelSize.height - 1),
      const Radius.circular(4),
    );
    final pinLeft = (size.width - PinSpec.shape.width) / 2;
    final pinTop = labelSize.height + labelGap;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(pixelRatio);

    if (text != null) {
      canvas
        ..drawRRect(labelRect, Paint()..color = marker.backgroundColor)
        ..drawRRect(
          labelRect,
          Paint()
            ..color = marker.borderColor
            ..style = PaintingStyle.stroke,
        );
      text.paint(canvas, Offset((size.width - text.width) / 2, (labelSize.height - text.height) / 2));
    }
    canvas
      ..save()
      ..translate(pinLeft - PinSpec.shape.left, pinTop - PinSpec.shape.top)
      ..drawPicture(pin)
      ..restore();

    final image = await recorder.endRecording().toImage((size.width * pixelRatio).ceil(), (size.height * pixelRatio).ceil());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final cacheKey = [
      marker.id,
      marker.label,
      marker.backgroundColor.toARGB32(),
      marker.borderColor.toARGB32(),
      pinState,
      pixelRatio,
      textScaler.scale(1),
    ].join('_');

    text?.dispose();
    image.dispose();
    return (
      image: await NOverlayImage.fromByteArray(bytes!.buffer.asUint8List(), cacheKey: cacheKey),
      size: size,
      tipY: pinTop + PinSpec.tipY - PinSpec.shape.top,
    );
  }
}
