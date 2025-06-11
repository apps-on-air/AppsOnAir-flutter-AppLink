class AppLinkParams {
  String url;
  String name;
  String urlPrefix;
  String? shortId;
  SocialMeta? socialMeta;
  String? androidFallbackUrl;
  String? iOSFallbackUrl;
  bool? isOpenInBrowserAndroid;
  bool? isOpenInAndroidApp;
  bool? isOpenInBrowserApple;
  bool? isOpenInIosApp;

  AppLinkParams({
    required this.url,
    required this.name,
    required this.urlPrefix,
    this.shortId,
    this.socialMeta,
    this.androidFallbackUrl,
    this.iOSFallbackUrl,
    this.isOpenInBrowserAndroid = false,
    this.isOpenInAndroidApp = true,
    this.isOpenInBrowserApple = false,
    this.isOpenInIosApp = true,
  });

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
      iOSFallbackUrl: json['iOSFallbackUrl'],
    );
  }

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
    data['iOSFallbackUrl'] = iOSFallbackUrl;
    return data;
  }
}

class SocialMeta {
  String? title;
  String? description;
  String? imageUrl;

  SocialMeta({
    this.title,
    this.description,
    this.imageUrl,
  });

  SocialMeta.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        imageUrl = json['imageUrl'];

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };
}
