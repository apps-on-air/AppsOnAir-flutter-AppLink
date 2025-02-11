import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'appsonair_flutter_applink_platform_interface.dart';

/// An implementation of [AppsonairFlutterApplinkPlatform] that uses method channels.
class MethodChannelAppsonairFlutterApplink extends AppsonairFlutterApplinkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('appsOnAirAppLink');

  @override
  Future<String?> initializeAppLink() async {
    final version = await methodChannel.invokeMethod<String>('initialize');
    return version;
  }
}
