import 'package:appsonair_flutter_applink/models/app_link_params.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'appsonair_flutter_applink_method_channel.dart';

abstract class AppsonairFlutterApplinkPlatform extends PlatformInterface {
  /// Constructs a AppsonairFlutterApplinkPlatform.
  AppsonairFlutterApplinkPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppsonairFlutterApplinkPlatform _instance = MethodChannelAppsonairFlutterApplink();

  /// The default instance of [AppsonairFlutterApplinkPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppsonairFlutterApplink].
  static AppsonairFlutterApplinkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppsonairFlutterApplinkPlatform] when
  /// they register themselves.
  static set instance(AppsonairFlutterApplinkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Map<String, dynamic>?> getReferralDetails() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map<String, dynamic>?> createAppLink({required AppLinkParams appLinkParams}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Stream<Map<String, dynamic>?> initializeAppLink() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
