import AppsOnAir_AppLink
import Flutter
import UIKit

public class AppsonairFlutterApplinkPlugin: NSObject, FlutterPlugin {

    // Singleton instance
    public static let shared = AppsonairFlutterApplinkPlugin()

    private var channel: FlutterMethodChannel?

    fileprivate static var pendingDeepLink: String?
    fileprivate static var pendingReferralDeepLink: String?
    fileprivate static var pendingAttributionInfo: String?

    // Mirrors `AppLinkService`'s own `.appsOnAirFirstLaunchDidExpire` observer, which re-fires
    // `onAttributionListener` when the app returns from background after the first-launch window
    // expires. That notification name is internal to the native module, so it isn't reachable
    // type-safely here - the raw string is what NotificationCenter actually matches on, and it's
    // exactly what AppHelper posts.
    private static let firstLaunchDidExpireNotificationName = Notification.Name(
        "AppsOnAirAppLink.firstLaunchDidExpire")
    private var firstLaunchExpiredObserver: NSObjectProtocol?

    private override init() {
        super.init()
        // Initialize AppLinkService once
        initializeAppLinkService()
    }

    deinit {
        if let firstLaunchExpiredObserver {
            NotificationCenter.default.removeObserver(firstLaunchExpiredObserver)
        }
    }

    private func initializeAppLinkService() {
        initialize(
            onDeepLinkProcessed: handleDeepLink, onReferralLinkDetected: handleReferralLinkDetected)

        firstLaunchExpiredObserver = NotificationCenter.default.addObserver(
            forName: AppsonairFlutterApplinkPlugin.firstLaunchDidExpireNotificationName,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleAttributionListener()
        }
    }

    private func handleDeepLink(latestUrl: URL?, result: [String: Any]) {
        let jsonResponse =
            ["uri": latestUrl?.absoluteString ?? "", "result": result] as [String: Any]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: [])
        let jsonString = String(data: jsonData ?? Data(), encoding: .utf8)

        if let sink = AppLinkEventHandler.shared.eventSink {
            sink(jsonString)
        } else {
            AppsonairFlutterApplinkPlugin.pendingDeepLink = jsonString
        }
    }

    private func handleReferralLinkDetected(result: [String: Any]) {
        let jsonData = try? JSONSerialization.data(withJSONObject: result, options: [])
        let jsonString = String(data: jsonData ?? Data(), encoding: .utf8)
        if let sink = ReferralEventHandler.shared.eventSink {
            sink(jsonString)
        } else {
            AppsonairFlutterApplinkPlugin.pendingReferralDeepLink = jsonString
        }

        // Native's initialize only accepts one listener closure at a time, so the
        // onAttributionListener equivalent is derived here by calling getAttributionInfo
        // on the same trigger onReferralLinkDetected fires on - matching what native's
        // own onAttributionListener does internally.
        handleAttributionListener()
    }

    private func handleAttributionListener() {
        AppLinkService.shared.getAttributionInfo { attributionInfo in
            let jsonData = try? JSONSerialization.data(withJSONObject: attributionInfo, options: [])
            let jsonString = String(data: jsonData ?? Data(), encoding: .utf8)
            if let sink = AttributionEventHandler.shared.eventSink {
                sink(jsonString)
            } else {
                AppsonairFlutterApplinkPlugin.pendingAttributionInfo = jsonString
            }
        }
    }

    /// Mirrors `AppLinkService.initialize(onDeepLinkProcessed:onReferralLinkDetected:)`.
    @available(
        *,
        deprecated,
        message:
            "`onReferralLinkDetected` is deprecated and will be removed in a future release. Use `onAttributionListener` instead."
    )
    private func initialize(
        onDeepLinkProcessed: @escaping (URL?, [String: Any]) -> Void,
        onReferralLinkDetected: @escaping ([String: Any]) -> Void
    ) {
        AppLinkService.shared.initialize(
            onDeepLinkProcessed: onDeepLinkProcessed,
            onReferralLinkDetected: onReferralLinkDetected
        )
    }

    /// Mirrors `AppLinkService.initialize(onDeepLinkProcessed:onAttributionListener:)`.
    private func initialize(
        onDeepLinkProcessed: @escaping (URL?, [String: Any]) -> Void,
        onAttributionListener: @escaping ([String: Any]) -> Void
    ) {
        AppLinkService.shared.initialize(
            onDeepLinkProcessed: onDeepLinkProcessed,
            onAttributionListener: onAttributionListener
        )
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = AppsonairFlutterApplinkPlugin.shared
        instance.channel = FlutterMethodChannel(
            name: "appsOnAirAppLink", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: instance.channel!)

        // Each event channel gets its own handler
        let appLinkEventChannel = FlutterEventChannel(
            name: "appLinkEventChanel", binaryMessenger: registrar.messenger())
        appLinkEventChannel.setStreamHandler(AppLinkEventHandler.shared)

        let referralEventChannel = FlutterEventChannel(
            name: "appLinkReferralEventChanel", binaryMessenger: registrar.messenger())
        referralEventChannel.setStreamHandler(ReferralEventHandler.shared)

        let attributionEventChannel = FlutterEventChannel(
            name: "appLinkAttributionEventChanel", binaryMessenger: registrar.messenger())
        attributionEventChannel.setStreamHandler(AttributionEventHandler.shared)
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
        let appsFlyer = args["appsFlyer"] as? [String: Any]
        let attributionTtl = args["attributionTtl"] as? Int

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
            androidFallbackUrl: androidFallbackUrl,
            appsFlyer: appsFlyer,
            attributionTtl: attributionTtl
        ) { latestLink in
            if let data = try? JSONSerialization.data(withJSONObject: latestLink, options: []),
                let jsonString = String(data: data, encoding: .utf8)
            {
                result(jsonString)
            } else {
                result("Error converting response to JSON string")
            }
        }
    }

    private func getReferralDetails(result: @escaping FlutterResult, call: FlutterMethodCall) {
        AppLinkService.shared.getReferralDetails { linkDetails in
            if let data = try? JSONSerialization.data(withJSONObject: linkDetails, options: []),
                let jsonString = String(data: data, encoding: .utf8)
            {
                result(jsonString)
            } else {
                result("Error converting response to JSON string")
            }
        }

    }

    private func getReferralInfo(result: @escaping FlutterResult, call: FlutterMethodCall) {
        AppLinkService.shared.getReferralInfo { linkDetails in
            if let data = try? JSONSerialization.data(withJSONObject: linkDetails, options: []),
                let jsonString = String(data: data, encoding: .utf8)
            {
                result(jsonString)
            } else {
                result("Error converting response to JSON string")
            }
        }
    }

    private func getAttributionInfo(result: @escaping FlutterResult, call: FlutterMethodCall) {
        AppLinkService.shared.getAttributionInfo { attributionInfo in
            if let data = try? JSONSerialization.data(withJSONObject: attributionInfo, options: []),
                let jsonString = String(data: data, encoding: .utf8)
            {
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
        case "get_attribution_info":
            getAttributionInfo(result: result, call: call)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

// MARK: - Separate Stream Handlers

class AppLinkEventHandler: NSObject, FlutterStreamHandler {
    static let shared = AppLinkEventHandler()
    var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
        -> FlutterError?
    {
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

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
        -> FlutterError?
    {
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

class AttributionEventHandler: NSObject, FlutterStreamHandler {
    static let shared = AttributionEventHandler()
    var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
        -> FlutterError?
    {
        self.eventSink = events
        if let pendingInfo = AppsonairFlutterApplinkPlugin.pendingAttributionInfo {
            events(pendingInfo)
            AppsonairFlutterApplinkPlugin.pendingAttributionInfo = nil
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
