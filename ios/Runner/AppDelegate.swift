import Flutter
import UIKit
import AVFoundation
import MediaPlayer

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure audio session for background playback
    configureAudioSession()

    // Register for remote control events
    UIApplication.shared.beginReceivingRemoteControlEvents()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  // MARK: - Audio Session Configuration

  private func configureAudioSession() {
    do {
      let audioSession = AVAudioSession.sharedInstance()

      // Allow background playback + mixing with other audio
      try audioSession.setCategory(
        .playback,
        mode: .default,
        options: [
          .allowBluetooth,
          .allowAirPlay,
          .mixWithOthers
        ]
      )

      // Activate the session
      try audioSession.setActive(true)
    } catch {
      print("[Musix] Failed to configure audio session: \(error.localizedDescription)")
    }
  }

  // MARK: - Remote Control

  override func remoteControlReceived(with event: UIEvent?) {
    guard let event = event, event.type == .remoteControl else { return }

    switch event.subtype {
    case .remoteControlPlay:
      // Handled by audio_service
      break
    case .remoteControlPause:
      // Handled by audio_service
      break
    case .remoteControlNextTrack:
      // Handled by audio_service
      break
    case .remoteControlPreviousTrack:
      // Handled by audio_service
      break
    default:
      break
    }
  }

  // MARK: - Background Tasks

  override func applicationDidEnterBackground(_ application: UIApplication) {
    // Keep audio session active in background
    do {
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("[Musix] Background audio session error: \(error.localizedDescription)")
    }
  }

  override func applicationWillEnterForeground(_ application: UIApplication) {
    // Re-activate audio session when coming to foreground
    do {
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("[Musix] Foreground audio session error: \(error.localizedDescription)")
    }
  }
}
