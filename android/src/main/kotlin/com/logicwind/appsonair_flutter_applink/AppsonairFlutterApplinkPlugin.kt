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

/** AppsonairFlutterApplinkPlugin */
class AppsonairFlutterApplinkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null
  private var activity: Activity? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "appsOnAirAppLink")
    channel.setMethodCallHandler(this)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "deep_link_event_channel")
    eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
      }

      override fun onCancel(arguments: Any?) {
        eventSink = null
      }
    })
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "initialize") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
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
          Log.d("DeepLinkListener", "Deep link processed --> $uri")
          Log.d("DeepLinkListener", "Parameters: $params")
          eventSink?.success(uri.toString())  // Send deep link to Flutter
        }

        override fun onDeepLinkError(uri: Uri?, error: String) {
          Log.e("DeepLinkListener", "Failed to process deep link: $uri")
          Log.e("DeepLinkListener", "Error: $error")
        }

        override fun onReferralLinkDetected(uri: Uri, params: Map<String, String>) {
          Log.d("DeepLinkListener", "Referral link detected --> $uri")
          Log.d("DeepLinkListener", "Parameters: $params")
          eventSink?.success(uri.toString())  // Send referral link to Flutter
        }
      })
    }
  }
}

