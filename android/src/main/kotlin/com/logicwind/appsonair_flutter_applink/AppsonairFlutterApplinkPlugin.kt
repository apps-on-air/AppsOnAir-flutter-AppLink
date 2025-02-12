package com.logicwind.appsonair_flutter_applink
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import com.appsonair.applink.interfaces.AppLinkListener
import com.appsonair.applink.services.AppLinkHandler
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

/** AppsonairFlutterApplinkPlugin */
class AppsonairFlutterApplinkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null
  private var activity: Activity? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "appsOnAirAppLink")
    channel.setMethodCallHandler(this)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "appLinkEventChanel")
    eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
      }

      override fun onCancel(arguments: Any?) {
        eventSink = null
      }
    })
  }

  private fun createAppLink(context: Context, result: Result, call: MethodCall){

    val isShortLink: Boolean = call.argument<Boolean>("isShortLink") ?: false
    val url: String = call.argument<String>("url") ?: ""
    val prefixUrl: String = call.argument<String>("prefixUrl") ?: ""
    val androidFallbackUrl: String = call.argument<String>("androidFallbackUrl") ?: ""
    val iOSFallbackUrl: String = call.argument<String>("iOSFallbackUrl") ?: ""

    val customParams: Map<String, Any> = call.argument<Map<String, Any>>("customParams") ?: emptyMap()
    val socialMeta: Map<String, Any> = call.argument<Map<String, Any>>("socialMeta") ?: emptyMap()
    val analytics: Map<String, Any> = call.argument<Map<String, Any>>("analytics") ?: emptyMap()


    CoroutineScope(Dispatchers.Main).launch {
      val data = AppLinkHandler.createAppLink(
        url = url,
        prefixUrl = prefixUrl,
        customParams = customParams,
        socialMeta = socialMeta,
        analytics = analytics,
        isShortLink = isShortLink,
        androidFallbackUrl = androidFallbackUrl,
        iOSFallbackUrl = iOSFallbackUrl,
        context =context
      )
      result.success(data.toString())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "create_app_link" -> {
          activity?.let { createAppLink(it.applicationContext,result,call) }
        }
        "get_referral_details" -> {
          val deeplinkService = activity?.let { AppLinkService.getInstance(it.applicationContext) }
          val referral = deeplinkService?.getReferralLink()
          result.success(referral.toString())
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    eventSink = null
  }

  // Handle activity attachment and detachment
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    handleIntent(activity?.intent)
    binding.addOnNewIntentListener { intent ->
      handleIntent(intent)
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

  // Handle deep links from intents
  private fun handleIntent(intent: Intent?) {
    val deeplinkService = AppLinkService.getInstance(activity ?: return)

    if (intent != null) {
      deeplinkService.initialize(intent, object : AppLinkListener {
        override fun onDeepLinkProcessed(uri: Uri, params: Map<String, String>) {
          val mapData= mapOf(
            "uri" to uri,
            "params" to params,
            )
          eventSink?.success(mapData.toString())  // Send deep link to Flutter
        }

        override fun onDeepLinkError(uri: Uri?, error: String) {
          Log.e("DeepLinkListener", "Failed to process deep link: $uri")
          Log.e("DeepLinkListener", "Error: $error")
        }

        override fun onReferralLinkDetected(uri: Uri, params: Map<String, String>) {
          val mapData= mapOf(
            "uri" to uri,
            "params" to params,
          )
          eventSink?.success(mapData.toString())  // Send deep link to Flutter
        }
      })
    }
  }
}

