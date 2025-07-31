/// Holds the configuration details required to create an AppLink.
///
/// The [AppLinkParams] class allows users to define how the link behaves on
/// both Android and iOS platforms, including fallback URLs, opening behavior,
/// and optional social metadata for link previews.
class AppLinkParams {
  /// The destination URL to which the AppLink should redirect.
  final String url;

  /// The name or label associated with the AppLink.
  final String name;

  /// The URL prefix (base domain) used to construct the full AppLink.
  final String urlPrefix;

  /// An optional custom short ID to be used as part of the short link.
  final String? shortId;

  /// Optional metadata for rendering social link previews.
  final SocialMeta? socialMeta;

  /// Optional fallback URL for Android devices if the app is not installed.
  final String? androidFallbackUrl;

  /// Optional fallback URL for iOS devices if the app is not installed.
  final String? iosFallbackUrl;

  /// Indicates whether the link should open in the browser on Android.
  final bool? isOpenInBrowserAndroid;

  /// Indicates whether the link should attempt to open in the Android app.
  final bool? isOpenInAndroidApp;

  /// Indicates whether the link should open in the browser on iOS.
  final bool? isOpenInBrowserApple;

  /// Indicates whether the link should attempt to open in the iOS app.
  final bool? isOpenInIosApp;

  /// Creates an [AppLinkParams] instance with the required and optional fields.
  AppLinkParams({
    required this.url,
    required this.name,
    required this.urlPrefix,
    this.shortId,
    this.socialMeta,
    this.androidFallbackUrl,
    this.iosFallbackUrl,
    this.isOpenInBrowserAndroid,
    this.isOpenInAndroidApp,
    this.isOpenInBrowserApple,
    this.isOpenInIosApp,
  });

  /// Creates an [AppLinkParams] instance from a JSON [Map].
  ///
  /// Parses all relevant fields and initializes the object. If the `socialMeta`
  /// key is present, it will be converted using [SocialMeta.fromJson].
  factory AppLinkParams.fromJson(Map<String, dynamic> json) {
    return AppLinkParams(
      url: json['url'] ?? '',
      name: json['name'] ?? '',
      urlPrefix: json['urlPrefix'] ?? '',
      shortId: json['shortId'],
      socialMeta: json['socialMeta'] != null
          ? SocialMeta.fromJson(json['socialMeta'])
          : null,
      isOpenInBrowserAndroid: json['isOpenInBrowserAndroid'],
      isOpenInAndroidApp: json['isOpenInAndroidApp'],
      isOpenInBrowserApple: json['isOpenInBrowserApple'],
      isOpenInIosApp: json['isOpenInIosApp'],
      androidFallbackUrl: json['androidFallbackUrl'],
      iosFallbackUrl: json['iosFallbackUrl'],
    );
  }

  /// Converts the [AppLinkParams] object into a JSON-compatible [Map].
  ///
  /// Only non-null values are included. The `socialMeta` object is also
  /// converted to JSON if it exists.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['name'] = name;
    data['urlPrefix'] = urlPrefix;
    data['shortId'] = shortId;
    if (socialMeta != null) {
      data['socialMeta'] = socialMeta!.toJson();
    }
    data['isOpenInBrowserAndroid'] = isOpenInBrowserAndroid;
    data['isOpenInBrowserApple'] = isOpenInBrowserApple;
    data['isOpenInIosApp'] = isOpenInIosApp;
    data['isOpenInAndroidApp'] = isOpenInAndroidApp;
    data['androidFallbackUrl'] = androidFallbackUrl;
    data['iosFallbackUrl'] = iosFallbackUrl;
    return data;
  }
}

/// Represents the social meta information used for link previews.
///
/// This class contains metadata such as the [title], [description], and [imageUrl]
/// that can be used to generate rich previews of links when shared across
/// social media platforms or messaging apps.

class SocialMeta {
  /// The title of the link preview.
  final String? title;

  /// The description associated with the link.
  final String? description;

  /// The URL of the preview image.
  final String? imageUrl;

  /// Creates a [SocialMeta] object with optional [title], [description], and [imageUrl].
  SocialMeta({
    this.title,
    this.description,
    this.imageUrl,
  });

  /// Creates a [SocialMeta] object from a JSON map.
  ///
  /// The keys `title`, `description`, and `imageUrl` are read from the [json] map.
  factory SocialMeta.fromJson(Map<String, dynamic> json) => SocialMeta(
        title: json['title'],
        description: json['description'],
        imageUrl: json['imageUrl'],
      );

  /// Converts this [SocialMeta] object into a JSON map.
  ///
  /// Only non-null fields are included in the returned map.
  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };
}
