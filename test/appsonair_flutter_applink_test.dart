import 'package:flutter_test/flutter_test.dart';
import 'package:appsonair_flutter_applink/appsonair_flutter_applink.dart';
import 'package:appsonair_flutter_applink/appsonair_flutter_applink_platform_interface.dart';
import 'package:appsonair_flutter_applink/appsonair_flutter_applink_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppsonairFlutterApplinkPlatform with MockPlatformInterfaceMixin implements AppsonairFlutterApplinkPlatform {
  @override
  Future<String?> initializeAppLink() => Future.value('42');
}

void main() {
  final AppsonairFlutterApplinkPlatform initialPlatform = AppsonairFlutterApplinkPlatform.instance;

  test('$MethodChannelAppsonairFlutterApplink is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppsonairFlutterApplink>());
  });

  test('getPlatformVersion', () async {
    AppsonairFlutterApplink appsonairFlutterApplinkPlugin = AppsonairFlutterApplink();
    MockAppsonairFlutterApplinkPlatform fakePlatform = MockAppsonairFlutterApplinkPlatform();
    AppsonairFlutterApplinkPlatform.instance = fakePlatform;

    expect(await appsonairFlutterApplinkPlugin.getPlatformVersion(), '42');
  });
}
