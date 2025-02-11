import 'package:appsonair_flutter_applink/models/options.dart';
import 'package:flutter/services.dart';

import 'appsonair_flutter_applink_platform_interface.dart';

/// An implementation of [AppsonairFlutterApplinkPlatform] that uses method channels.
class MethodChannelAppsonairFlutterApplink extends AppsonairFlutterApplinkPlatform {
  /// The method channel used to interact with the native platform.

  final methodChannel = const MethodChannel('appsOnAirAppLink');
  final eventChannel = const EventChannel('appLinkEventChanel');

  @override
  Future<String?> createAppLink({Options? options}) async {
    final response = await methodChannel.invokeMethod<String>('create_app_link', options?.toJson());
    return response;
  }

  @override
  Future<String?> getReferralDetails() async {
    final response = await methodChannel.invokeMethod<String>('get_referral_details');
    return response;
  }

  @override
  Stream<String?> initializeAppLink() {
    return eventChannel.receiveBroadcastStream().map((event) => event as String?);
  }
}
