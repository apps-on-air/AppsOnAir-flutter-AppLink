class AppLinkParams {
  String url;
  String name;
  String urlPrefix;
  String? prefixId;
  //Map<String, dynamic>? customParams;
  SocialMeta? socialMeta;
  //Analytics? analytics;
  //bool? isShortLink;
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
    this.prefixId,
    //this.customParams,
    this.socialMeta,
    //this.analytics,
    //this.isShortLink = true,
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
      prefixId: json['prefixId'],
      //customParams: json['customParams'] != null ? Map<String, dynamic>.from(json['customParams']) : null,
      socialMeta: json['socialMeta'] != null ? SocialMeta.fromJson(json['socialMeta']) : null,
      //analytics: json['analytics'] != null ? Analytics.fromJson(json['analytics']) : null,
      //isShortLink: json['isShortLink'],
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
    data['prefixId'] = prefixId;
    // if (customParams != null) {
    //   data['customParams'] = customParams;
    // }
    if (socialMeta != null) {
      data['socialMeta'] = socialMeta!.toJson();
    }
    // if (analytics != null) {
    //   data['analytics'] = analytics!.toJson();
    // }
    //data['isShortLink'] = isShortLink;
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

class Analytics {
  String? platform;
  String? campaign;
  String? utmSource;
  String? utmMedium;
  String? utmCampaign;

  Analytics({
    this.platform,
    this.campaign,
    this.utmSource,
    this.utmMedium,
    this.utmCampaign,
  });
  Analytics.fromJson(Map<String, dynamic> json)
      : platform = json['platform'],
        campaign = json['campaign'],
        utmSource = json['utmSource'],
        utmMedium = json['utmMedium'],
        utmCampaign = json['utmCampaign'];

  Map<String, dynamic> toJson() => {
        if (platform != null) 'platform': platform,
        if (campaign != null) 'campaign': campaign,
        if (utmSource != null) 'utmSource': utmSource,
        if (utmMedium != null) 'utmMedium': utmMedium,
        if (utmCampaign != null) 'utmCampaign': utmCampaign,
      };
}
