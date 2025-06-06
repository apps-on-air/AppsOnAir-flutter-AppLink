import 'package:appsonair_flutter_applink/models/app_link_params.dart';
import 'package:flutter/services.dart';
import 'appsonair_flutter_applink_platform_interface.dart';

class AppsonairFlutterApplink {
  Future<String?> createAppLink({required AppLinkParams appLinkParams}) {
    return AppsonairFlutterApplinkPlatform.instance.createAppLink(appLinkParams: appLinkParams);
  }

  /// Retrieves the referral information.
  ///
  /// **Android Only**: This method works only on Android.
  /// Throws [PlatformException] if called on iOS
  Future getReferralDetails() async {
    return await AppsonairFlutterApplinkPlatform.instance.getReferralDetails();
  }

  Stream<String?> initializeAppLink() {
    return AppsonairFlutterApplinkPlatform.instance.initializeAppLink();
  }
}
