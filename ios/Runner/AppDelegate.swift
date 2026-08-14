import UIKit

import Flutter
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  // Android 쪽 TorchPlugin.kt 와 같은 채널·같은 메서드 이름을 쓴다.
  //
  // iOS 에는 고를 카메라가 사실상 하나뿐이라 Android 같은 선택 버그가 없다.
  // 그래도 Dart 가 플랫폼을 구분하지 않도록 목록 형태를 그대로 맞춰 준다.
  //
  // 별도 Swift 파일 대신 여기에 두는 이유는, 새 파일을 Runner 타깃에 넣으려면
  // project.pbxproj 를 손으로 고쳐야 하고 그쪽이 훨씬 깨지기 쉽기 때문이다.
  private static let torchChannelName = "lighton/torch"
  private static let torchCameraId = "default"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: AppDelegate.torchChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { call, result in
        AppDelegate.handleTorchCall(call, result)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private static func torchDevice() -> AVCaptureDevice? {
    guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
      return nil
    }
    return device
  }

  private static func handleTorchCall(
    _ call: FlutterMethodCall,
    _ result: @escaping FlutterResult
  ) {
    switch call.method {
    case "listCameras":
      // facing 1 은 Android 의 LENS_FACING_BACK 과 같은 값이다.
      result([
        [
          "id": torchCameraId,
          "hasFlash": torchDevice() != nil,
          "facing": 1,
        ]
      ])

    case "setTorch":
      let arguments = call.arguments as? [String: Any]
      let on = arguments?["on"] as? Bool ?? false
      guard let device = torchDevice() else {
        result(FlutterError(code: "NO_TORCH", message: "이 기기에는 플래시가 없습니다.", details: nil))
        return
      }
      do {
        try device.lockForConfiguration()
        defer { device.unlockForConfiguration() }
        if on {
          try device.setTorchModeOn(level: 1.0)
        } else {
          device.torchMode = .off
        }
        result(device.torchMode == .on)
      } catch {
        result(FlutterError(code: "SET_TORCH_FAILED", message: "\(error)", details: nil))
      }

    case "isTorchOn":
      result(torchDevice()?.torchMode == .on)

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
