/// 표시할 영역 수
///
/// - `one`: 사이드를 접고 콘텐츠만 표시
/// - `two`: 사이드·콘텐츠 모두 표시
enum DesktopSplitType { one, two }

class DesktopSplitViewState {
  final double sideWidth;
  final DesktopSplitType type;
  final double minWidth;

  const DesktopSplitViewState({
    required this.sideWidth,
    this.type = DesktopSplitType.two,
    this.minWidth = 360,
  });
}
