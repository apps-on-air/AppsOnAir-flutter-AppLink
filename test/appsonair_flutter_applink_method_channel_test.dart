import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appsonair_flutter_applink/appsonair_flutter_applink_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAppsonairFlutterApplink platform = MethodChannelAppsonairFlutterApplink();
  const MethodChannel channel = MethodChannel('appsOnAirAppLink');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.initializeAppLink(), '42');
  });
}
