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
        AppLinkService.shared.initialize {latestUrl, result in
            // Store the deep link if Flutter is not ready
            let jsonResponse = ["uri":latestUrl?.absoluteString ?? "", "result":result]
         let jsonData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: [])
            let jsonString = String(data: jsonData ?? Data(), encoding: .utf8)
            if self.eventSink == nil {
            
                AppsonairFlutterApplinkPlugin.pendingDeepLink = jsonString
            } else {
                // Send the deep link immediately if Flutter is ready
                self.eventSink?(jsonString)
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
        guard let args = call.arguments as? [String: Any] else {
            result("Invalid arguments")
            return
        }

        let url = args["url"] as? String ?? ""
        let name = args["name"] as? String ?? ""
        let shortId = args["shortId"] as? String ?? nil
        let urlPrefix = args["urlPrefix"] as? String ?? ""
        let androidFallbackUrl = args["androidFallbackUrl"] as? String
        let iOSFallbackUrl = args["iOSFallbackUrl"] as? String

        let socialMeta = args["socialMeta"] as? [String: Any]

        let isOpenInBrowserAndroid = args["isOpenInBrowserAndroid"] as? Bool ?? false
        let isOpenInAndroidApp = args["isOpenInAndroidApp"] as? Bool ?? true
        let isOpenInBrowserApple = args["isOpenInBrowserApple"] as? Bool ?? false
        let isOpenInIosApp = args["isOpenInIosApp"] as? Bool ?? true

        AppLinkService.shared.createAppLink(url: url, name: name, urlPrefix: urlPrefix, shortId: shortId, socialMeta: socialMeta, isOpenInBrowserApple: isOpenInBrowserApple, isOpenInIosApp: isOpenInIosApp, iOSFallbackUrl: iOSFallbackUrl,isOpenInAndroidApp: isOpenInAndroidApp,isOpenInBrowserAndroid: isOpenInBrowserAndroid, androidFallbackUrl: androidFallbackUrl)  { latestLink in
            if let data = try? JSONSerialization.data(withJSONObject: latestLink, options: []),
               let jsonString = String(data: data, encoding: .utf8) {
                result(jsonString)
            } else {
                result("Error converting response to JSON string")
            }
        }
    }
    
    private func getReferralDetails(result: @escaping FlutterResult, call: FlutterMethodCall) {
        AppLinkService.shared.getReferralDetails {linkDetails in
            if let data = try? JSONSerialization.data(withJSONObject: linkDetails, options: []),
               let jsonString = String(data: data, encoding: .utf8) {
                result(jsonString)
            } else {
                result("Error converting response to JSON string")
            }
        }
           
    }

    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "create_app_link":
            createAppLink(result: result, call: call)
        case "get_referral_details":
            getReferralDetails(result: result, call: call)
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
