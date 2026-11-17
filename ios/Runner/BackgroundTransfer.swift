import Flutter
import UIKit

/// `vine_butler/background_transfer` 채널의 요청을 background URLSession으로 보내는 플러그인
///
/// - 앱이 suspend되어도 OS가 업로드·응답 수신을 이어 가고, 끝나면 앱을 깨워 결과를 Dart로 돌려줌
/// - 결과: `statusCode`, `headers`, `body` / 오류: `UNAVAILABLE`(본문 없는 요청), `TIMEOUT`, `NETWORK`
/// - background session은 upload·download task만 지원해 본문이 없는 요청은 `UNAVAILABLE` (Dart가 기본 전송으로 대체)
/// - 앱이 종료된 뒤 끝난 전송은 결과를 받을 Dart 호출이 없어 버림
/// - `content-length` 헤더는 URLSession이 본문 파일 크기로 직접 계산하므로 제외
final class BackgroundTransfer: NSObject, FlutterPlugin, URLSessionDataDelegate {
  private static let identifier = "com.atenb.vinebutler.transfer"
  /// 연결이 끊겼을 때 OS가 다시 시도하는 시간까지 포함한 전송 전체 제한 (초)
  private static let resourceTimeout: TimeInterval = 300

  private struct Transfer {
    let result: FlutterResult
    let bodyFile: URL
    var data = Data()
  }

  private let lock = NSLock()
  private var transfers: [Int: Transfer] = [:]
  private var finishEvents: (() -> Void)?
  private lazy var session: URLSession = {
    let configuration = URLSessionConfiguration.background(withIdentifier: Self.identifier)

    configuration.isDiscretionary = false
    configuration.sessionSendsLaunchEvents = true
    configuration.timeoutIntervalForResource = Self.resourceTimeout
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()

  static func register(with registrar: FlutterPluginRegistrar) {
    let instance = BackgroundTransfer()
    let channel = FlutterMethodChannel(name: "vine_butler/background_transfer", binaryMessenger: registrar.messenger())

    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "request" else {
      result(FlutterMethodNotImplemented)
      return
    }
    guard
      let arguments = call.arguments as? [String: Any],
      let url = URL(string: arguments["url"] as? String ?? ""),
      let body = (arguments["body"] as? FlutterStandardTypedData)?.data,
      !body.isEmpty
    else {
      result(FlutterError(code: "UNAVAILABLE", message: "본문이 없는 요청은 background URLSession으로 보낼 수 없음", details: nil))
      return
    }

    var request = URLRequest(url: url)
    let bodyFile = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)

    request.httpMethod = arguments["method"] as? String ?? "POST"
    if let receiveTimeoutMs = arguments["receiveTimeoutMs"] as? Int { request.timeoutInterval = TimeInterval(receiveTimeoutMs) / 1000 }
    for (key, value) in arguments["headers"] as? [String: String] ?? [:] where key.lowercased() != "content-length" {
      request.setValue(value, forHTTPHeaderField: key)
    }

    do {
      try body.write(to: bodyFile)
    } catch {
      result(FlutterError(code: "UNAVAILABLE", message: error.localizedDescription, details: nil))
      return
    }

    let task = session.uploadTask(with: request, fromFile: bodyFile)

    locked { transfers[task.taskIdentifier] = Transfer(result: result, bodyFile: bodyFile) }
    task.resume()
  }

  func application(
    _ application: UIApplication,
    handleEventsForBackgroundURLSession identifier: String,
    completionHandler: @escaping () -> Void
  ) -> Bool {
    guard identifier == Self.identifier else { return false }

    finishEvents = completionHandler
    _ = session
    return true
  }

  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    locked { transfers[dataTask.taskIdentifier]?.data.append(data) }
  }

  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    guard let transfer = locked({ transfers.removeValue(forKey: task.taskIdentifier) }) else { return }

    try? FileManager.default.removeItem(at: transfer.bodyFile)

    let response = task.response as? HTTPURLResponse
    let headers = (response?.allHeaderFields ?? [:]).reduce(into: [String: String]()) { $0["\($1.key)"] = "\($1.value)" }

    DispatchQueue.main.async {
      if let error {
        let code = (error as? URLError)?.code == .timedOut ? "TIMEOUT" : "NETWORK"

        transfer.result(FlutterError(code: code, message: error.localizedDescription, details: nil))
        return
      }

      transfer.result([
        "statusCode": response?.statusCode ?? 0,
        "headers": headers,
        "body": FlutterStandardTypedData(bytes: transfer.data),
      ])
    }
  }

  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    DispatchQueue.main.async {
      self.finishEvents?()
      self.finishEvents = nil
    }
  }

  private func locked<T>(_ body: () -> T) -> T {
    lock.lock()
    defer { lock.unlock() }
    return body()
  }
}
