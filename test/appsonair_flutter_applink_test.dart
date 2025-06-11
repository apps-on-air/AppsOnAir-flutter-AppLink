import 'package:flutter_test/flutter_test.dart';
import 'package:appsonair_flutter_applink/appsonair_flutter_applink_platform_interface.dart';
import 'package:appsonair_flutter_applink/appsonair_flutter_applink_method_channel.dart';

void main() {
  final AppsonairFlutterApplinkPlatform initialPlatform =
      AppsonairFlutterApplinkPlatform.instance;

  test('$MethodChannelAppsonairFlutterApplink is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelAppsonairFlutterApplink>());
  });
}
