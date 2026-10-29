import 'package:flutter/services.dart';

/// 텍스트와 HTML을 한 항목으로 클립보드에 쓰는 함수
///
/// - `vine_butler/clipboard`: 네이티브 클립보드 채널 (macOS·Windows Runner에 구현)
/// - 채널이 없는 플랫폼은 텍스트만 복사
abstract final class RichClipboard {
  static const _channel = MethodChannel('vine_butler/clipboard');

  static Future<void> setRichText({required String text, required String html}) async {
    try {
      await _channel.invokeMethod<void>('setRichText', {'text': text, 'html': html});
    } on MissingPluginException {
      await Clipboard.setData(ClipboardData(text: text));
    }
  }
}
