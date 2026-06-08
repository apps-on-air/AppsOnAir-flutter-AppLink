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

  // Form Controllers
  final TextEditingController _urlController = TextEditingController(text: 'https://appsonair.com');
  final TextEditingController _nameController = TextEditingController(text: 'AppsOnAir');
  final TextEditingController _urlPrefixController = TextEditingController(text: 'YOUR_DOMAIN_NAME');
  final TextEditingController _shortIdController = TextEditingController();
  final TextEditingController _titleController = TextEditingController(text: 'link title');
  final TextEditingController _descriptionController = TextEditingController(text: 'link description');
  final TextEditingController _imageUrlController = TextEditingController(text: 'https://image.png');
  final TextEditingController _androidFallbackController = TextEditingController(text: 'https://play.google.com');
  final TextEditingController _iosFallbackController = TextEditingController(text: 'https://appstore.com');

  // Toggle States
  bool _isOpenInAndroidApp = true;
  bool _isOpenInBrowserAndroid = false;
  bool _isOpenInIosApp = true;
  bool _isOpenInBrowserApple = false;

  @override
  void initState() {
    super.initState();
    _appsonairFlutterApplinkPlugin.initializeAppLink().listen((event) {
      setState(() {
        _linkDetails = event.toString();
      });
    });
    _appsonairFlutterApplinkPlugin.onReferralLinkDetected().listen((event) {
      setState(() {
        _linkDetails = event.toString();
      });
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    _urlPrefixController.dispose();
    _shortIdController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _androidFallbackController.dispose();
    _iosFallbackController.dispose();
    super.dispose();
  }

  Future<void> createLink() async {
    String link;
    String? shortId = _shortIdController.text.trim().isEmpty ? null : _shortIdController.text.trim();

    try {
      var data = await _appsonairFlutterApplinkPlugin.createAppLink(
        appLinkParams: AppLinkParams(
          url: _urlController.text.trim(),
          name: _nameController.text.trim(),
          urlPrefix: _urlPrefixController.text.trim(),
          shortId: shortId,
          socialMeta: SocialMeta(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            imageUrl: _imageUrlController.text.trim(),
          ),
          androidFallbackUrl: _androidFallbackController.text.trim(),
          iosFallbackUrl: _iosFallbackController.text.trim(),
          isOpenInAndroidApp: _isOpenInAndroidApp,
          isOpenInBrowserAndroid: _isOpenInBrowserAndroid,
          isOpenInIosApp: _isOpenInIosApp,
          isOpenInBrowserApple: _isOpenInBrowserApple,
        ),
      );
      link = data.toString();
    } on PlatformException {
      link = 'Failed to create link.';
    }

    if (!mounted) return;

    setState(() {
      _linkDetails = link;
    });
  }

  Future<void> getReferralInfo() async {
    try {
      var data = await _appsonairFlutterApplinkPlugin.getReferralInfo();
      setState(() {
        _linkDetails = data.toString();
      });
    } on PlatformException catch (e) {
      log(e.toString());
      setState(() {
        _linkDetails = 'Failed to get referral info: ${e.message}';
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: isMultiline ? 2 : 1,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildToggle({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Switch(
            value: value,
            onChanged: (newValue) => onChanged(newValue),
            activeThumbColor: Colors.green,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter AppLink Example'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Basic Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _urlController,
                label: 'URL',
                hint: 'https://example.com',
              ),
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                hint: 'App Name',
              ),
              _buildTextField(
                controller: _urlPrefixController,
                label: 'URL Prefix',
                hint: 'YOUR_DOMAIN_NAME (no http/https)',
              ),
              _buildTextField(
                controller: _shortIdController,
                label: 'Short ID',
                hint: 'Leave empty for auto-generation',
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Social Media',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _titleController,
                label: 'Social Title',
                hint: 'Title for social sharing',
              ),
              _buildTextField(
                controller: _descriptionController,
                label: 'Social Description',
                hint: 'Description for social sharing',
                isMultiline: true,
              ),
              _buildTextField(
                controller: _imageUrlController,
                label: 'Image URL',
                hint: 'https://example.com/image.png',
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Fallback URLs',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _androidFallbackController,
                label: 'Android Fallback URL',
                hint: 'https://play.google.com/store/apps/...',
              ),
              _buildTextField(
                controller: _iosFallbackController,
                label: 'iOS Fallback URL',
                hint: 'https://apps.apple.com/app/...',
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Open Behavior',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              _buildToggle(
                label: 'Open in Android App',
                value: _isOpenInAndroidApp,
                onChanged: (value) => setState(() => _isOpenInAndroidApp = value),
              ),
              _buildToggle(
                label: 'Open in Browser (Android)',
                value: _isOpenInBrowserAndroid,
                onChanged: (value) => setState(() => _isOpenInBrowserAndroid = value),
              ),
              _buildToggle(
                label: 'Open in iOS App',
                value: _isOpenInIosApp,
                onChanged: (value) => setState(() => _isOpenInIosApp = value),
              ),
              _buildToggle(
                label: 'Open in Browser (Apple)',
                value: _isOpenInBrowserApple,
                onChanged: (value) => setState(() => _isOpenInBrowserApple = value),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: createLink,
                    icon: const Icon(Icons.link),
                    label: const Text('Create Link'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: getReferralInfo,
                    icon: const Icon(Icons.info),
                    label: const Text('Get Referral'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_linkDetails.isNotEmpty) ...[
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    'Result',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                  ),
                  child: SelectableText(
                    _linkDetails,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
