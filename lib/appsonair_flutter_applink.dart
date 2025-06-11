import 'package:appsonair_flutter_applink/models/app_link_params.dart';
import 'appsonair_flutter_applink_platform_interface.dart';

class AppsonairFlutterApplink {
  Future<Map<String, dynamic>?> createAppLink(
      {required AppLinkParams appLinkParams}) async {
    return await AppsonairFlutterApplinkPlatform.instance
        .createAppLink(appLinkParams: appLinkParams);
  }

  Future<Map<String, dynamic>?> getReferralDetails() async {
    return await AppsonairFlutterApplinkPlatform.instance.getReferralDetails();
  }

  Stream<Map<String, dynamic>?> initializeAppLink() {
    return AppsonairFlutterApplinkPlatform.instance.initializeAppLink();
  }
}
