import 'package:appsonair_flutter_applink/models/referral_response.dart';
import 'package:flutter/material.dart';

import 'package:appsonair_flutter_applink/appsonair_flutter_applink.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _appsonairFlutterApplinkPlugin = AppsonairFlutterApplink();

  @override
  void initState() {
    super.initState();
    _appsonairFlutterApplinkPlugin.initializeAppLink().listen((event) {
      setState(() {
        _platformVersion = event.toString(); // Update UI with deep link
      });
    });
  }

  Future<void> createLink() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _appsonairFlutterApplinkPlugin.createAppLink() ?? 'No link found';
    } on PlatformException {
      platformVersion = 'Failed to create link.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> getReferral() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      ReferralResponse? data = await _appsonairFlutterApplinkPlugin.getReferralDetails();
      platformVersion = data.installReferrer ?? "No data";
    } on PlatformException {
      platformVersion = 'No link found';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text('Link :-> $_platformVersion\n'),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    createLink();
                  },
                  child: const Text("Create Link"),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    getReferral();
                  },
                  child: const Text("Get Referral"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
