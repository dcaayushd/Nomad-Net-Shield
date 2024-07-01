import UIKit
import Flutter
import NetworkExtension

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let vpnChannel = FlutterMethodChannel(name: "com.example.vpn/method",
                                          binaryMessenger: controller.binaryMessenger)
    vpnChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "startVpn":
        self.startVpn(result: result)
      case "stopVpn":
        self.stopVpn(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func startVpn(result: @escaping FlutterResult) {
    let manager = NETunnelProviderManager()
    let proto = NETunnelProviderProtocol()
    proto.providerBundleIdentifier = "com.example.vpn.PacketTunnelProvider"
    proto.serverAddress = "YOUR_VPN_SERVER_ADDRESS"
    manager.protocolConfiguration = proto
    manager.localizedDescription = "My VPN"
    manager.isEnabled = true

    manager.saveToPreferences { error in
      if let error = error {
        result(FlutterError(code: "VPN_START_ERROR",
                            message: "Failed to save VPN configuration",
                            details: error.localizedDescription))
      } else {
        manager.loadFromPreferences { error in
          if let error = error {
            result(FlutterError(code: "VPN_START_ERROR",
                                message: "Failed to load VPN configuration",
                                details: error.localizedDescription))
          } else {
            do {
              try manager.connection.startVPNTunnel()
              result(nil)
            } catch {
              result(FlutterError(code: "VPN_START_ERROR",
                                  message: "Failed to start VPN tunnel",
                                  details: error.localizedDescription))
            }
          }
        }
      }
    }
  }

  private func stopVpn(result: @escaping FlutterResult) {
    NETunnelProviderManager.loadAllFromPreferences { managers, error in
      if let error = error {
        result(FlutterError(code: "VPN_STOP_ERROR",
                            message: "Failed to load VPN configurations",
                            details: error.localizedDescription))
      } else if let manager = managers?.first {
        manager.connection.stopVPNTunnel()
        result(nil)
      } else {
        result(FlutterError(code: "VPN_STOP_ERROR",
                            message: "No VPN configuration found",
                            details: nil))
      }
    }
  }
}