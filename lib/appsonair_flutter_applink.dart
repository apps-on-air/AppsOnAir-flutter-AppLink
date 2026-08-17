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
  @Deprecated('Use getAttributionInfo() instead')
  Future<Map<String, dynamic>?> getReferralDetails() async {
    return await AppsonairFlutterApplinkPlatform.instance.getReferralDetails();
  }

  ///Return the referral link which user click for installing the application
  ///It will wait till untill referral data reflected
  @Deprecated('Use getAttributionInfo() instead')
  Future<Map<String, dynamic>?> getReferralInfo() async {
    return await AppsonairFlutterApplinkPlatform.instance.getReferralInfo();
  }

  ///Return the attribution info for the app install, including first-launch
  ///and attribution status details. It will wait until the attribution data
  ///is reflected.
  Future<Map<String, dynamic>?> getAttributionInfo() async {
    return await AppsonairFlutterApplinkPlatform.instance.getAttributionInfo();
  }

  ///Initialize the applink service in your application
  Stream<Map<String, dynamic>?> initializeAppLink() {
    return AppsonairFlutterApplinkPlatform.instance.initializeAppLink();
  }

  ///Provide the referral detail once app is launched after install for first time.
  @Deprecated('Use onAttributionListener() instead')
  Stream<Map<String, dynamic>?> onReferralLinkDetected() {
    return AppsonairFlutterApplinkPlatform.instance.onReferralLinkDetected();
  }

  ///Provide the attribution detail once app is launched after install for
  ///first time.
  Stream<Map<String, dynamic>?> onAttributionListener() {
    return AppsonairFlutterApplinkPlatform.instance.onAttributionListener();
  }
}
