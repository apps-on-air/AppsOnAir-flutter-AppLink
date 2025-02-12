import Flutter
import UIKit
import AppsOnAir_AppLink

public class AppsonairFlutterApplinkPlugin: NSObject, FlutterPlugin {
    
    // Singleton instance
    public static let shared = AppsonairFlutterApplinkPlugin()
    
    private var channel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    
    private static var pendingDeepLink: String?  // Store deep link before Flutter is ready
    
    private override init() {
        super.init()
        // Initialize AppLinkService once
        initializeAppLinkService()
    }
    
    private func initializeAppLinkService() {
        AppLinkService.shared.initialize { [weak self] latestUrl in
            guard let self = self else { return }
            
            // Store the deep link if Flutter is not ready
            if self.eventSink == nil {
                AppsonairFlutterApplinkPlugin.pendingDeepLink = latestUrl
            } else {
                // Send the deep link immediately if Flutter is ready
                self.eventSink?(latestUrl)
            }
        }
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = AppsonairFlutterApplinkPlugin.shared
        instance.channel = FlutterMethodChannel(name: "appsOnAirAppLink", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: instance.channel!)
        
        instance.eventChannel = FlutterEventChannel(name: "appLinkEventChanel", binaryMessenger: registrar.messenger())
        instance.eventChannel?.setStreamHandler(instance)
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
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
