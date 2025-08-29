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
  @Deprecated('Use getReferralInfo() instead')
  Future<Map<String, dynamic>?> getReferralDetails() async {
    return await AppsonairFlutterApplinkPlatform.instance.getReferralDetails();
  }

  ///Return the referral link which user click for installing the application
  ///It will wait till untill referral data reflected
  Future<Map<String, dynamic>?> getReferralInfo() async {
    return await AppsonairFlutterApplinkPlatform.instance.getReferralInfo();
  }

  ///Initialize the applink service in your application
  Stream<Map<String, dynamic>?> initializeAppLink() {
    return AppsonairFlutterApplinkPlatform.instance.initializeAppLink();
  }

  ///Provide the referral detail once app is launched after install for first time.
  Stream<Map<String, dynamic>?> onReferralLinkDetected() {
    return AppsonairFlutterApplinkPlatform.instance.onReferralLinkDetected();
  }
}
