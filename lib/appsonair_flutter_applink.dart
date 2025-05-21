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
  // Future<ReferralResponse> getReferralDetails() async {
  //   if (!Platform.isAndroid) {
  //     log("Throwing PlatformException for iOS", name: "getReferralDetails()");
  //     throw PlatformException(
  //       code: 'UNSUPPORTED_PLATFORM',
  //       message: 'getReferralDetails() is only supported on Android.',
  //     );
  //   }
  //   var response = await AppsonairFlutterApplinkPlatform.instance.getReferralDetails();
  //   return (response?.trim().isNotEmpty ?? false)
  //       ? ReferralResponse.fromJson(jsonDecode(response!))
  //       : ReferralResponse();
  // }

  Stream<String?> initializeAppLink() {
    return AppsonairFlutterApplinkPlatform.instance.initializeAppLink();
  }
}
