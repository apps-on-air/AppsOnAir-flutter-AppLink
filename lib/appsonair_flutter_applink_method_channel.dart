import 'dart:convert';

import 'package:appsonair_flutter_applink/models/app_link_params.dart';
import 'package:flutter/services.dart';

import 'appsonair_flutter_applink_platform_interface.dart';

/// An implementation of [AppsonairFlutterApplinkPlatform] that uses method channels.
class MethodChannelAppsonairFlutterApplink
    extends AppsonairFlutterApplinkPlatform {
  /// The method channel used to interact with the native platform.

  final methodChannel = const MethodChannel('appsOnAirAppLink');
  final eventChannel = const EventChannel('appLinkEventChanel');
  final appLinkReferralEventChanel =
      const EventChannel('appLinkReferralEventChanel');
  final appLinkAttributionEventChanel =
      const EventChannel('appLinkAttributionEventChanel');

  ///Pass the AppLinkParams data to native api and provide the response received from native api to flutter
  @override
  Future<Map<String, dynamic>?> createAppLink(
      {required AppLinkParams appLinkParams}) async {
    final response = await methodChannel.invokeMethod(
        'create_app_link', appLinkParams.toJson());
    return jsonDecode(response);
  }

  ///Provides data data received from native api to flutter for referral tracking
  @override
  @Deprecated('Use getReferralInfo() instead')
  Future<Map<String, dynamic>?> getReferralDetails() async {
    final response = await methodChannel.invokeMethod('get_referral_details');
    return jsonDecode(response);
  }

  ///Provides data data received from native api to flutter for referral tracking
  @override
  Future<Map<String, dynamic>?> getReferralInfo() async {
    final response = await methodChannel.invokeMethod('get_referral_info');
    return jsonDecode(response);
  }

  ///Provides referral/attribution data received from native api to flutter
  @override
  Future<Map<String, dynamic>?> getAttributionInfo() async {
    final response =
        await methodChannel.invokeMethod('get_attribution_info');
    return jsonDecode(response);
  }

  ///Initialize the applink service in your application for link tracking and deeplinking
  @override
  Stream<Map<String, dynamic>?> initializeAppLink() {
    return eventChannel
        .receiveBroadcastStream()
        .map((event) => jsonDecode(event));
  }

  ///Provide the referral detail once app is launched after install for first time.
  @override
  Stream<Map<String, dynamic>?> onReferralLinkDetected() {
    return appLinkReferralEventChanel
        .receiveBroadcastStream()
        .map((event) => jsonDecode(event));
  }

  ///Fires when an attribution is detected, and again every time the app
  ///returns to the foreground so the payload stays current.
  @override
  Stream<Map<String, dynamic>?> onAttributionListener() {
    return appLinkAttributionEventChanel
        .receiveBroadcastStream()
        .map((event) => jsonDecode(event));
  }
}
