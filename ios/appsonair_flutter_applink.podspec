#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint appsonair_flutter_applink.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'appsonair_flutter_applink'
  s.version          = '2.1.0'
  s.summary          = 'AppsOnAir AppLink Flutter SDK — deep link tracking and engagement analytics for iOS and Android.'
  s.description      = <<-DESC
The AppsOnAir AppLink Flutter SDK enables deep link tracking and engagement analytics for both iOS and Android.
It serves as a powerful alternative to Firebase Dynamic Links.
                       DESC
  s.homepage         = 'https://appsonair.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'devtools-logicwind' => 'devtools@logicwind.com' }
  s.source           = { :path => '.' }
  # Source files live in the SPM layout directory (shared between CocoaPods and SPM)
  s.source_files = 'appsonair_flutter_applink/Sources/appsonair_flutter_applink/**/*.{swift,h,m}'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'
  s.dependency 'AppsOnAir-AppLink', '2.1.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
