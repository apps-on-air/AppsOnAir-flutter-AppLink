import 'package:appsonair_flutter_applink/models/app_link_params.dart';
import 'appsonair_flutter_applink_platform_interface.dart';

class AppsonairFlutterApplink {
  /// Allow to create the applink with provided AppLinkParams data
  Future<Map<String, dynamic>?> createAppLink(
      {required AppLinkParams appLinkParams}) async {
    return await AppsonairFlutterApplinkPlatform.instance
        .createAppLink(appLinkParams: appLinkParams);
  }

  ///Return the referral link which user click for installing the application
  Future<Map<String, dynamic>?> getReferralDetails() async {
    return await AppsonairFlutterApplinkPlatform.instance.getReferralDetails();
  }

  ///Initialize the applink service in your application
  Stream<Map<String, dynamic>?> initializeAppLink() {
    return AppsonairFlutterApplinkPlatform.instance.initializeAppLink();
  }
}
