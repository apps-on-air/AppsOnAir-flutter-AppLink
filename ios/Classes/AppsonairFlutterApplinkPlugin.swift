import Flutter
import UIKit
import AppsOnAir_AppLink

public class AppsonairFlutterApplinkPlugin: NSObject, FlutterPlugin {
    
    // Singleton instance
    public static let shared = AppsonairFlutterApplinkPlugin()
    
    private var channel: FlutterMethodChannel?
    
    fileprivate static var pendingDeepLink: String?
    fileprivate static var pendingReferralDeepLink: String?
    
    private override init() {
        super.init()
        // Initialize AppLinkService once
        initializeAppLinkService()
    }
    
    private func initializeAppLinkService() {
        AppLinkService.shared.initialize { latestUrl, result in
            let jsonResponse = ["uri": latestUrl?.absoluteString ?? "", "result": result]
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: [])
            let jsonString = String(data: jsonData ?? Data(), encoding: .utf8)
            
            if let sink = AppLinkEventHandler.shared.eventSink {
                sink(jsonString)
            } else {
                AppsonairFlutterApplinkPlugin.pendingDeepLink = jsonString
            }
        } onReferralLinkDetected: { result in
            let jsonData = try? JSONSerialization.data(withJSONObject: result, options: [])
            let jsonString = String(data: jsonData ?? Data(), encoding: .utf8)
            if let sink = ReferralEventHandler.shared.eventSink {
                sink(jsonString)
            } else {
                AppsonairFlutterApplinkPlugin.pendingReferralDeepLink = jsonString
            }
        }
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = AppsonairFlutterApplinkPlugin.shared
        instance.channel = FlutterMethodChannel(name: "appsOnAirAppLink", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: instance.channel!)
        
        // Each event channel gets its own handler
        let appLinkEventChannel = FlutterEventChannel(name: "appLinkEventChanel", binaryMessenger: registrar.messenger())
        appLinkEventChannel.setStreamHandler(AppLinkEventHandler.shared)
        
        let referralEventChannel = FlutterEventChannel(name: "appLinkReferralEventChanel", binaryMessenger: registrar.messenger())
        referralEventChannel.setStreamHandler(ReferralEventHandler.shared)
    }
    
    private func createAppLink(result: @escaping FlutterResult, call: FlutterMethodCall) {
        guard let args = call.arguments as? [String: Any] else {
            result("Invalid arguments")
            return
        }
        
        let url = args["url"] as? String ?? ""
        let name = args["name"] as? String ?? ""
        let shortId = args["shortId"] as? String
        let urlPrefix = args["urlPrefix"] as? String ?? ""
        let androidFallbackUrl = args["androidFallbackUrl"] as? String
        let iosFallbackUrl = args["iosFallbackUrl"] as? String
        let socialMeta = args["socialMeta"] as? [String: Any]
        
        let isOpenInBrowserAndroid = args["isOpenInBrowserAndroid"] as? Bool
        let isOpenInAndroidApp = args["isOpenInAndroidApp"] as? Bool
        let isOpenInBrowserApple = args["isOpenInBrowserApple"] as? Bool
        let isOpenInIosApp = args["isOpenInIosApp"] as? Bool
        
        AppLinkService.shared.createAppLink(
            url: url,
            name: name,
            urlPrefix: urlPrefix,
            shortId: shortId,
            socialMeta: socialMeta,
            isOpenInBrowserApple: isOpenInBrowserApple,
            isOpenInIosApp: isOpenInIosApp,
            iosFallbackUrl: iosFallbackUrl,
            isOpenInAndroidApp: isOpenInAndroidApp,
            isOpenInBrowserAndroid: isOpenInBrowserAndroid,
            androidFallbackUrl: androidFallbackUrl
        ) { latestLink in
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

    private func getReferralInfo(result: @escaping FlutterResult, call: FlutterMethodCall) {
        AppLinkService.shared.getReferralInfo { linkDetails in
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
        case "get_referral_info":
            getReferralInfo(result: result, call: call)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

// MARK: - Separate Stream Handlers

class AppLinkEventHandler: NSObject, FlutterStreamHandler {
    static let shared = AppLinkEventHandler()
    var eventSink: FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        if let pendingLink = AppsonairFlutterApplinkPlugin.pendingDeepLink {
            events(pendingLink)
            AppsonairFlutterApplinkPlugin.pendingDeepLink = nil
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}

class ReferralEventHandler: NSObject, FlutterStreamHandler {
    static let shared = ReferralEventHandler()
    var eventSink: FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        if let pendingLink = AppsonairFlutterApplinkPlugin.pendingReferralDeepLink {
            events(pendingLink)
            AppsonairFlutterApplinkPlugin.pendingReferralDeepLink = nil
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
