import 'package:flutter/widgets.dart';

/// 모바일용 네이티브 런치 화면 유지
///
/// - Flutter 첫 프레임을 내보내지 않는 동안 OS가 런치 화면을 계속 보여 줌
class LaunchScreen {
  static bool _isShow = false;

  static void hold() {
    if (_isShow) { return; }

    _isShow = true;
    WidgetsBinding.instance.deferFirstFrame();
  }

  static void release() {
    if (!_isShow) { return; }

    _isShow = false;
    WidgetsBinding.instance.allowFirstFrame();
  }
}
