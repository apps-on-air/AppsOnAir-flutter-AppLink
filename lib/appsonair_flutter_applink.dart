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

  ///Return the referral/attribution info: same as [getReferralInfo]
  Future<Map<String, dynamic>?> getAttributionInfo() async {
    return await AppsonairFlutterApplinkPlatform.instance.getAttributionInfo();
  }

  ///Initialize the applink service in your application
  Stream<Map<String, dynamic>?> initializeAppLink() {
    return AppsonairFlutterApplinkPlatform.instance.initializeAppLink();
  }

  ///Provide the referral detail once app is launched after install for first time.
  Stream<Map<String, dynamic>?> onReferralLinkDetected() {
    return AppsonairFlutterApplinkPlatform.instance.onReferralLinkDetected();
  }

  ///Fires when an attribution is detected, and again every time the app
  ///returns to the foreground so the payload stays current.
  Stream<Map<String, dynamic>?> onAttributionListener() {
    return AppsonairFlutterApplinkPlatform.instance.onAttributionListener();
  }
}
