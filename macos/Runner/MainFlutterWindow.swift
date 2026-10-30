import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    registerRichClipboard(messenger: flutterViewController.engine.binaryMessenger)

    super.awakeFromNib()
  }

  /// 텍스트와 HTML을 한 항목으로 클립보드에 쓰는 채널 (Dart `RichClipboard`)
  private func registerRichClipboard(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "vine_butler/clipboard", binaryMessenger: messenger)

    channel.setMethodCallHandler { call, result in
      guard call.method == "setRichText",
            let args = call.arguments as? [String: String],
            let text = args["text"],
            let html = args["html"] else {
        result(FlutterMethodNotImplemented)
        return
      }

      let pasteboard = NSPasteboard.general

      pasteboard.clearContents()
      pasteboard.setString(html, forType: .html)
      pasteboard.setString(text, forType: .string)
      result(nil)
    }
  }
}
