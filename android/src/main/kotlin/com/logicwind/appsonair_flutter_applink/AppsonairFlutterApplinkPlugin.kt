package com.logicwind.appsonair_flutter_applink
import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import com.appsonair.applink.interfaces.AppLinkListener
import com.appsonair.applink.services.AppLinkService
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject

/** AppsonairFlutterApplinkPlugin */
class AppsonairFlutterApplinkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private lateinit var referralEventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null
  private lateinit var attributionEventChannel: EventChannel
  private var referralEventSink: EventChannel.EventSink? = null
  private var attributionEventSink: EventChannel.EventSink? = null
  private var activity: Activity? = null

  // initialize() runs from onAttachedToActivity, which can fire before Dart's initState() has
  // subscribed to these EventChannels. A callback that arrives before onListen would otherwise be
  // dropped silently (eventSink?.success() on a null sink is a no-op) even though native logs show
  // it fired. Buffer the latest payload per channel and flush it once a listener attaches.
  private var pendingDeepLink: String? = null
  private var pendingReferralInfo: String? = null
  private var pendingAttributionInfo: String? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "appsOnAirAppLink")
    channel.setMethodCallHandler(this)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "appLinkEventChanel")
    referralEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "appLinkReferralEventChanel")
    attributionEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "appLinkAttributionEventChanel")

    eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        pendingDeepLink?.let {
          events?.success(it)
          pendingDeepLink = null
        }
      }

      override fun onCancel(arguments: Any?) {
        eventSink = null
      }
    })
    referralEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        referralEventSink = events
        pendingReferralInfo?.let {
          events?.success(it)
          pendingReferralInfo = null
        }
      }

      override fun onCancel(arguments: Any?) {
        referralEventSink = null
      }
    })
    attributionEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        attributionEventSink = events
        pendingAttributionInfo?.let {
          events?.success(it)
          pendingAttributionInfo = null
        }
      }

      override fun onCancel(arguments: Any?) {
        attributionEventSink = null
      }
    })
  }

  private fun createAppLink( result: Result, call: MethodCall){
    val appLinkService = activity?.let { AppLinkService.getInstance(it.applicationContext) }
    val url: String = call.argument<String>("url") ?: ""
    val name: String = call.argument<String>("name") ?: ""
    val urlPrefix: String = call.argument<String>("urlPrefix") ?: ""
    val shortId: String? = call.argument<String>("shortId") ?: null
    val androidFallbackUrl: String? = call.argument<String>("androidFallbackUrl") ?: null
    val iosFallbackUrl: String? = call.argument<String>("iosFallbackUrl") ?: null
    val socialMeta: Map<String, Any>? = call.argument<Map<String, Any>>("socialMeta") ?: null
    val isOpenInBrowserAndroid: Boolean? = call.argument<Boolean>("isOpenInBrowserAndroid") ?: null
    val isOpenInAndroidApp: Boolean? = call.argument<Boolean>("isOpenInAndroidApp") ?: null
    val isOpenInBrowserApple: Boolean? = call.argument<Boolean>("isOpenInBrowserApple") ?: null
    val isOpenInIosApp: Boolean? = call.argument<Boolean>("isOpenInIosApp") ?: null
    val appsFlyer: Map<String, Any>? = call.argument<Map<String, Any>>("appsFlyer") ?: null
    val attributionTtl: Int? = call.argument<Int>("attributionTtl") ?: null

    CoroutineScope(Dispatchers.Main).launch {
      val data = appLinkService?.createAppLink(
          name = name,
          url = url,
          urlPrefix = urlPrefix,
          shortId = shortId,
          socialMeta = socialMeta,
          androidFallbackUrl = androidFallbackUrl,
          iosFallbackUrl = iosFallbackUrl,
          isOpenInAndroidApp = isOpenInAndroidApp,
          isOpenInBrowserAndroid = isOpenInBrowserAndroid,
          isOpenInBrowserApple = isOpenInBrowserApple,
          isOpenInIosApp = isOpenInIosApp,
          appsFlyer = appsFlyer,
          attributionTtl = attributionTtl
      )
      result.success(data.toString())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "create_app_link" -> {
          activity?.let { createAppLink(result,call) }
        }
        "get_referral_details" -> {
          val appLinkService = activity?.let { AppLinkService.getInstance(it.applicationContext) }
          val referral = appLinkService?.getReferralDetails()
          result.success(referral.toString())
        }
       "get_referral_info" -> {
        val appLinkService = activity?.let { AppLinkService.getInstance(it.applicationContext) }
        CoroutineScope(Dispatchers.Main).launch {
          val referral = appLinkService?.getReferralInfo()
          result.success(referral.toString())
         }
       }
      "get_attribution_info" -> {
        val appLinkService = activity?.let { AppLinkService.getInstance(it.applicationContext) }
        CoroutineScope(Dispatchers.Main).launch {
          val attributionInfo = appLinkService?.getAttributionInfo()
          result.success(attributionInfo.toString())
         }
       }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    eventSink = null
    referralEventSink = null
    attributionEventSink = null
  }

  // Handle activity attachment and detachment
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    initializeAppLinkService(activity?.intent)
    binding.addOnNewIntentListener { intent ->
      handleNewIntent(intent)
      true
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  private val appLinkListener = object : AppLinkListener {
    override fun onDeepLinkProcessed(uri: Uri, result: JSONObject) {
      val mapData = mapOf(
        "uri" to uri.toString(),
        "result" to result,
      )
      val payload = JSONObject(mapData).toString()
      val sink = eventSink
      if (sink != null) {
        sink.success(payload)
      } else {
        pendingDeepLink = payload
      }
    }

    override fun onReferralLinkDetected(result: JSONObject) {
      val payload = result.toString()
      val sink = referralEventSink
      if (sink != null) {
        sink.success(payload)
      } else {
        pendingReferralInfo = payload
      }
    }

    override fun onAttributionListener(result: JSONObject) {
      val payload = result.toString()
      val sink = attributionEventSink
      if (sink != null) {
        sink.success(payload)
      } else {
        pendingAttributionInfo = payload
      }
    }

    override fun onDeepLinkError(uri: Uri?, error: String) {
      Log.e("DeepLinkListener", "Failed to process deep link: $uri")
      Log.e("DeepLinkListener", "Error: $error")
    }
  }

  // One-time setup: registers the listener and processes the launch intent (if any). Per the SDK,
  // initialize() is idempotent and only processes the deep link on its first call — a later intent
  // arriving while the app is already running must go through handleDeepLink() instead, not another
  // initialize() call, otherwise it is silently dropped.
  private fun initializeAppLinkService(intent: Intent?) {
    val activity = activity ?: return
    val appLinkService = AppLinkService.getInstance(activity)
    appLinkService.initialize(activity, intent ?: Intent(), appLinkListener)
  }

  // Handle a deep link delivered to an already-running activity.
  private fun handleNewIntent(intent: Intent?) {
    val activity = activity ?: return
    if (intent == null) return
    val appLinkService = AppLinkService.getInstance(activity)
    appLinkService.handleDeepLink(intent, activity.packageName)
  }
}

