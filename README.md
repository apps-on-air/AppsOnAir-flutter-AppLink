# AppsOnAir-flutter-AppLink

**AppsOnAir-flutter-AppLink** enables you to handle deep links, and in-app routing seamlessly in your app. With a simple integration, you can configure, manage, and act on links from the web dashboard in real time and for more detail refer [documentation](https://documentation.appsonair.com/category/applink).

## 🚀 Features

- ✅ Deep link support (URI scheme, AppLinks)
- ✅ Fallback behavior (e.g., open Play Store, App Store)
- ✅ Custom domain support
- ✅ Referral tracking
- ✅ Seamless migration from Firebase Dynamic Links to AppLink

**Note:** For comprehensive instructions on migrating Firebase Dynamic Links to AppLink, refer to the [documentation](https://documentation.appsonair.com/MobileQuickstart/AppLink/firebase-dynamiclinks-migration).

## Minimum Requirements

#### iOS

- iOS deployment target: 13.0

#### Provide your application id in your app info.plist file.

```xml
<key>AppsonairAppId</key>
<string>XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX</string>
```

#### Enable the Advanced Deferred AppLink feature in your iOS app by adding the EnableAdvancedDeferredLink Boolean flag to your Info.plist file.
```xml
<key>EnableAdvancedDeferredLink</key>
<true/>
```

#### Add Associated Domain

```xml
<!-- If Using Custom Url Schema -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>YOUR_URL_NAME</string>
        <key>CFBundleURLSchemes</key>
        <array>
          <string>YOUR_CUSTOM_URL_SCHEME</string> <!-- Replace with your custom URL scheme -->
        </array>
    </dict>
</array>
```

```xml
<!-- If Using Universal Links -->
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:YOUR_DOMAIN</string> <!-- Replace with your actual domain -->
</array>
```

#### Android

- Android Gradle Plugin (AGP): Version 8.0.2 or higher
- Kotlin: Version 1.7.10 or higher
- Gradle: Version 8.0 or higher

---

### iOS Dependency Manager

This plugin supports **both CocoaPods and Swift Package Manager (SPM)**. SPM support requires **Flutter 3.24.0 or higher**.

By default, CocoaPods is used. You can control which dependency manager your project uses by adding the following to your app's `pubspec.yaml`:

#### Option 1 — CocoaPods (default)

Use this if you want to always use CocoaPods regardless of any global Flutter setting:

```yaml
# pubspec.yaml
flutter:
  config:
    # false → always uses CocoaPods (default)
    enable-swift-package-manager: false
```

No other steps needed. Run:

```sh
flutter pub get
cd ios && pod install
```

#### Option 2 — Swift Package Manager

> Requires **Flutter ≥ 3.24.0**. SPM support on iOS is available starting from this version.

Use this to opt into SPM and use `AppsOnAir-iOS-AppLink` via Swift Package Manager:

```yaml
# pubspec.yaml
flutter:
  config:
    # true → uses Swift Package Manager
    enable-swift-package-manager: true
```

Then run:

```sh
flutter pub get
```

Flutter will automatically resolve `AppsOnAir-iOS-AppLink v1.4.0` via SPM. No additional Xcode configuration is required.

> **Note:** You can also enable SPM globally for all your Flutter projects (instead of per-project) by running:
> ```sh
> flutter config --enable-swift-package-manager
> ```
> In that case, you can remove the `config` block from `pubspec.yaml` entirely and Flutter will use SPM automatically.

#### Summary

| `enable-swift-package-manager` | Flutter version | Result |
|:---:|:---:|:---|
| `false` | any | **CocoaPods** — used |
| `true` | ≥ 3.24.0 | **SPM** — used |
| not set | any (global off) | **CocoaPods** — default behaviour |
| not set | ≥ 3.24.0 (global on) | **SPM** — Flutter global setting applies |

> 💡 **Recommendation:** We recommend migrating to **Swift Package Manager** — it is Apple's official, actively maintained dependency manager and receives updates first.

---

## How to use?

#### Add below code to setting.gradle.

```sh
pluginManagement {
   repositories {
       google()
       mavenCentral()
       gradlePluginPortal()
       maven { url 'https://jitpack.io' }
   }
}
```

#### Add below code to your root level build.gradle

```sh
allprojects {
   repositories {
       google()
       mavenCentral()
       maven { url 'https://jitpack.io' }
   }
}
```

#### Add meta-data to the app's AndroidManifest.xml file under the application tag.

>Make sure meta-data name is "AppsonairAppId".

>Provide your application id in meta-data value.


```xml
<application>
    ...
    <meta-data
        android:name="AppsonairAppId"
        android:value="********-****-****-****-************" />
</application>
```

#### Add below code to the app's AndroidManifest.xml file under the activity tag of your main activity.

```xml
<intent-filter android:autoVerify="true">
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data
    android:host="your domain"
    android:scheme="https" />
</intent-filter>
```

#### Add below code if you are using custom uri scheme.
```xml
<intent-filter>
   <action android:name="android.intent.action.VIEW" />
   <category android:name="android.intent.category.DEFAULT" />
   <category android:name="android.intent.category.BROWSABLE" />
   <data
    android:host="open"
    android:scheme="your scheme" />
</intent-filter>
```


## Example :

#### Create AppLink Method

```dart
final _appsonairFlutterApplinkPlugin = AppsonairFlutterApplink();
await _appsonairFlutterApplinkPlugin.createAppLink(
        appLinkParams: AppLinkParams(
          url: 'https://appsonair.com',
          name: 'AppsOnAir',
          urlPrefix: 'YOUR_DOMAIN_NAME', //shouldn't contain http or https
          shortId: 'LINK_ID', // If not set, it will be auto-generated
          socialMeta: SocialMeta(
            title: 'link title',
            description: 'link description',
            imageUrl: 'https://image.png',
          ),
          androidFallbackUrl: 'https://play.google.com',
          iosFallbackUrl: 'https://appstore.com',
          isOpenInAndroidApp: true,
          isOpenInBrowserAndroid: false,
          isOpenInIosApp: true,
          isOpenInBrowserApple: false,
        ),
      );
```

#### Listen the AppLink
```dart
_appsonairFlutterApplinkPlugin.initializeAppLink().listen((event) {
    // Handle received link here...
});
```
#### Listen the Referral Details

It is triggered only when the app is installed and launched for the first time with a referral details.

```dart
_appsonairFlutterApplinkPlugin.onReferralLinkDetected().listen((event) {
    // Handle referral here...
});
```

#### To retrieving the referral link
```dart
var data = await _appsonairFlutterApplinkPlugin.getReferralInfo();
```
