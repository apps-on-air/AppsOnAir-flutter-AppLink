import Flutter
import UIKit
import AppsOnAir_AppLink

public class AppsonairFlutterApplinkPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    
    private static var pendingDeepLink: String?  // Store deep link before Flutter is ready

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = AppsonairFlutterApplinkPlugin()
        instance.channel = FlutterMethodChannel(name: "appsOnAirAppLink", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: instance.channel!)

        instance.eventChannel = FlutterEventChannel(name: "appLinkEventChanel", binaryMessenger: registrar.messenger())
        instance.eventChannel?.setStreamHandler(instance)

        // Fetch deep link immediately on plugin registration
        AppLinkService.shared.initialize { latestUrl in
            pendingDeepLink = latestUrl  // Store deep link for later use
        }
    }

    private func createAppLink(result: @escaping FlutterResult, call: FlutterMethodCall) {
        AppLinkService.shared.getShortLink { latestLink in
            if let data = try? JSONSerialization.data(withJSONObject: latestLink, options: []),
               let jsonString = String(data: data, encoding: .utf8) {
                result(jsonString)  // Return as a JSON string
            } else {
                result("Error converting NSDictionary to String")
            }
        }
    }


    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "create_app_link":
            createAppLink(result: result, call: call)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension AppsonairFlutterApplinkPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events

        // Send the stored deep link (if available)
        if let pendingLink = AppsonairFlutterApplinkPlugin.pendingDeepLink {
            eventSink?(pendingLink)
            AppsonairFlutterApplinkPlugin.pendingDeepLink = nil  // Clear after sending
        }

        // Listen for new deep links
        AppLinkService.shared.initialize { latestUrl in
            self.eventSink?(latestUrl)
        }

        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
