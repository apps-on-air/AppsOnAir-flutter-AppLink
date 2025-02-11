import 'dart:convert';

import 'package:appsonair_flutter_applink/models/options.dart';
import 'package:appsonair_flutter_applink/models/referral_response.dart';

import 'appsonair_flutter_applink_platform_interface.dart';

class AppsonairFlutterApplink {
  Future<String?> createAppLink({Options? options}) {
    return AppsonairFlutterApplinkPlatform.instance.createAppLink(options: options);
  }

  Future<ReferralResponse> getReferralDetails() async {
    var response = await AppsonairFlutterApplinkPlatform.instance.getReferralDetails();
    return (response?.trim().isNotEmpty ?? false)
        ? ReferralResponse.fromJson(jsonDecode(response!))
        : ReferralResponse();
  }

  Stream<String?> initializeAppLink() {
    return AppsonairFlutterApplinkPlatform.instance.initializeAppLink();
  }
}
