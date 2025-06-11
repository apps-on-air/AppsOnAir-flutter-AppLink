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

  @override
  Future<Map<String, dynamic>?> createAppLink(
      {required AppLinkParams appLinkParams}) async {
    final response = await methodChannel.invokeMethod(
        'create_app_link', appLinkParams.toJson());
    return jsonDecode(response);
  }

  @override
  Future<Map<String, dynamic>?> getReferralDetails() async {
    final response = await methodChannel.invokeMethod('get_referral_details');
    return jsonDecode(response);
  }

  @override
  Stream<Map<String, dynamic>?> initializeAppLink() {
    return eventChannel
        .receiveBroadcastStream()
        .map((event) => jsonDecode(event));
  }
}
