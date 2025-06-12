## ![pub package](https://appsonair.com/images/logo.svg)
# AppsOnAir-flutter-AppLink

**AppsOnAir-flutter-AppLink** enables you to handle deep links, and in-app routing seamlessly in your app. With a simple integration, you can configure, manage, and act on links from the web dashboard in real time and for more detail refer [documentation](https://documentation.appsonair.com/MobileQuickstart/GettingStarted/).

## ⚠️ Important Notice ⚠️

This plugin is currently in **pre-production**. While the plugin is fully functional, the supported services it integrates with are not yet live in production. Stay tuned for updates as we bring our services to production!

## 🚀 Features

- ✅ Deep link support (URI scheme, App Links)
- ✅ Fallback behavior (e.g., open Play Store, App Store)
- ✅ Custom domain support
- ✅ Referral tracking
- ✅ Firebase dynamic link migration to AppLink(Coming Soon)

## Minimum Requirements

#### iOS

- iOS deployment target: 13.0

#### Provide your application id in your app info.plist file.

```sh
<key>AppsOnAirAPIKey</key>
<string>XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX</string>
```

#### Add Associated Domain

```
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

```
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

>Make sure meta-data name is “appId”.

>Provide your application id in meta-data value.


```sh
</application>
    ...
    <meta-data
        android:name="appId"
        android:value="********-****-****-****-************" />
</application>
```

#### Add below code to the app's AndroidManifest.xml file under the activity tag of your main activity.

```sh
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
```sh
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

```
final _appsonairFlutterApplinkPlugin = AppsonairFlutterApplink();
await _appsonairFlutterApplinkPlugin.createAppLink(
        appLinkParams: AppLinkParams(
        url: 'https://appsonair.com',
        name: 'AppsOnAir',
        urlPrefix: 'YOUR_DOMAIN_NAME' //shouldn't contain http or https
       ),)

```

#### Listen the AppLink
```
    _appsonairFlutterApplinkPlugin.initializeAppLink().listen((event) {
      // Handle received link here...
    });
```

#### To retrieving the referral link
```
    var data = await _appsonairFlutterApplinkPlugin.getReferralDetails();
```
