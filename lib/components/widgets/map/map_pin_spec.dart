import 'dart:ui';

/// 매물 마커 핀 이미지 규격
///
/// - `size`: SVG 가로·세로 크기
/// - `tipY`: 핀 끝(좌표에 닿는 지점)의 세로 위치
/// - `shape`: 테두리를 포함한 핀 모양의 실제 영역
/// - `labelGap`: 금액 라벨과 핀 사이 간격
abstract final class PinSpec {
  static const double size = 36;
  static const double tipY = 33.8;
  static const Rect shape = Rect.fromLTRB(6, 1.5, 30, 34.3);
  static const double labelGap = 4;
  static const String enableAsset = 'assets/icons/Marker_Enable.svg';
  static const String disableAsset = 'assets/icons/Marker_Disable.svg';
}
