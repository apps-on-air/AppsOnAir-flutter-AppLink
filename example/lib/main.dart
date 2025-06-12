import 'dart:developer';
import 'package:appsonair_flutter_applink/models/app_link_params.dart';
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
  String _linkDetails = '';
  final _appsonairFlutterApplinkPlugin = AppsonairFlutterApplink();
  TextEditingController txtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _appsonairFlutterApplinkPlugin.initializeAppLink().listen((event) {
      setState(() {
        _linkDetails = event.toString(); // Update UI with deep link
      });
    });
  }

  Future<void> createLink() async {
    String link;
    String? shortId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      if (txtController.text.trim().isNotEmpty) {
        shortId = txtController.text.trim();
      }
      var data = await _appsonairFlutterApplinkPlugin.createAppLink(
        appLinkParams: AppLinkParams(
          url: 'https://appsonair.com',
          name: 'AppsOnAir',
          urlPrefix: 'your url prefix',
          shortId: shortId,
        ),
      );
      link = data.toString();
      txtController.clear();
    } on PlatformException {
      link = 'Failed to create link.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _linkDetails = link;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter AppLink Example'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: txtController,
                  decoration: const InputDecoration(
                      hintText: "Enter short link id if needed",
                      border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.greenAccent)),
                  onPressed: () {
                    createLink();
                  },
                  child: const Text("Create App Link"),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.tealAccent)),
                  onPressed: () async {
                    try {
                      var data = await _appsonairFlutterApplinkPlugin
                          .getReferralDetails();
                      setState(() {
                        _linkDetails = data.toString();
                      });
                    } on PlatformException catch (e) {
                      log(e.toString());
                    }
                  },
                  child: const Text("Get Referral Link"),
                ),
              ),
              const SizedBox(height: 40),
              Flexible(
                child: Text(
                  _linkDetails,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}
