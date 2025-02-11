import 'appsonair_flutter_applink_platform_interface.dart';

class AppsonairFlutterApplink {
  Future<String?> getPlatformVersion() {
    return AppsonairFlutterApplinkPlatform.instance.initializeAppLink();
  }
}
