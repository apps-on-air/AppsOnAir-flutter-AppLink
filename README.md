## ![pub package](https://appsonair.com/images/logo.svg)
# AppsOnAir-flutter-AppLink

**AppsOnAir-flutter-AppLink** enables you to handle deep links, and in-app routing seamlessly in your app. With a simple integration, you can configure, manage, and act on links from the web dashboard in real time and for more detail refer [documentation](https://documentation.appsonair.com/MobileQuickstart/GettingStarted/).

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

```sh
<key>AppsonairAppId</key>
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

>Make sure meta-data name is “AppsonairAppId”.

>Provide your application id in meta-data value.


```sh
</application>
    ...
    <meta-data
        android:name="AppsonairAppId"
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
```
_appsonairFlutterApplinkPlugin.initializeAppLink().listen((event) {
    // Handle received link here...
});
```
#### Listen the Referral Details

It is triggered only when the app is installed and launched for the first time with a referral details.

```
_appsonairFlutterApplinkPlugin.onReferralLinkDetected().listen((event) {
    // Handle referral here...
});
```

#### To retrieving the referral link
```
var data = await _appsonairFlutterApplinkPlugin.getReferralInfo();
```
