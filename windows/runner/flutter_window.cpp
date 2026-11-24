#include "flutter_window.h"

#include <flutter/standard_method_codec.h>

#include <cstdio>
#include <cstring>
#include <optional>
#include <string>

#include "flutter/generated_plugin_registrant.h"

namespace {

// Builds Windows "HTML Format" clipboard data.
//
// - `StartHTML` ~ `EndFragment`: UTF-8 byte offsets (CF_HTML spec)
std::string BuildHtmlFormat(const std::string& fragment) {
  const std::string prefix = "<html><body><!--StartFragment-->";
  const std::string suffix = "<!--EndFragment--></body></html>";
  const char* header_template =
      "Version:0.9\r\nStartHTML:%010zu\r\nEndHTML:%010zu\r\n"
      "StartFragment:%010zu\r\nEndFragment:%010zu\r\n";
  char header[160];
  const size_t header_length = static_cast<size_t>(
      std::snprintf(header, sizeof(header), header_template, size_t{0},
                    size_t{0}, size_t{0}, size_t{0}));
  const size_t start_fragment = header_length + prefix.size();
  const size_t end_fragment = start_fragment + fragment.size();
  const size_t end_html = end_fragment + suffix.size();

  std::snprintf(header, sizeof(header), header_template, header_length,
                end_html, start_fragment, end_fragment);
  return std::string(header) + prefix + fragment + suffix;
}

void SetClipboardBytes(UINT format, const void* data, size_t size) {
  HGLOBAL memory = GlobalAlloc(GMEM_MOVEABLE, size);

  if (!memory) {
    return;
  }

  std::memcpy(GlobalLock(memory), data, size);
  GlobalUnlock(memory);

  if (!SetClipboardData(format, memory)) {
    GlobalFree(memory);
  }
}

bool SetClipboardRichText(HWND hwnd, const std::string& text,
                          const std::string& html) {
  if (!OpenClipboard(hwnd)) {
    return false;
  }

  EmptyClipboard();

  const int wide_length =
      MultiByteToWideChar(CP_UTF8, 0, text.c_str(), -1, nullptr, 0);
  std::wstring wide_text(static_cast<size_t>(wide_length), L'\0');

  MultiByteToWideChar(CP_UTF8, 0, text.c_str(), -1, wide_text.data(),
                      wide_length);
  SetClipboardBytes(CF_UNICODETEXT, wide_text.c_str(),
                    wide_text.size() * sizeof(wchar_t));

  const std::string html_format = BuildHtmlFormat(html);

  SetClipboardBytes(RegisterClipboardFormatW(L"HTML Format"),
                    html_format.c_str(), html_format.size() + 1);
  CloseClipboard();
  return true;
}

}  // namespace

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  RegisterRichClipboard();
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::RegisterRichClipboard() {
  rich_clipboard_channel_ =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          flutter_controller_->engine()->messenger(), "vine_butler/clipboard",
          &flutter::StandardMethodCodec::GetInstance());

  rich_clipboard_channel_->SetMethodCallHandler(
      [this](const flutter::MethodCall<flutter::EncodableValue>& call,
             std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
                 result) {
        const auto* args =
            std::get_if<flutter::EncodableMap>(call.arguments());

        if (call.method_name() != "setRichText" || !args) {
          result->NotImplemented();
          return;
        }

        const auto text_it = args->find(flutter::EncodableValue("text"));
        const auto html_it = args->find(flutter::EncodableValue("html"));

        if (text_it == args->end() || html_it == args->end()) {
          result->NotImplemented();
          return;
        }

        const auto& text = std::get<std::string>(text_it->second);
        const auto& html = std::get<std::string>(html_it->second);

        if (!SetClipboardRichText(GetHandle(), text, html)) {
          result->Error("CLIPBOARD_UNAVAILABLE", "Failed to open the clipboard.");
          return;
        }

        result->Success();
      });
}

void FlutterWindow::OnDestroy() {
  rich_clipboard_channel_ = nullptr;

  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
