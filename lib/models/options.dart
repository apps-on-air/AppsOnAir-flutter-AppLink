class Options {
  String? url;
  String? prefixUrl;
  Map<String, dynamic>? customParams;
  SocialMeta? socialMeta;
  Analytics? analytics;
  bool? isShortLink;
  String? androidFallbackUrl;
  String? iOSFallbackUrl;

  Options(
      {this.url,
      this.prefixUrl,
      this.customParams,
      this.socialMeta,
      this.analytics,
      this.isShortLink = true,
      this.androidFallbackUrl,
      this.iOSFallbackUrl});

  Options.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    prefixUrl = json['prefixUrl'];
    customParams = json['customParams'] != null ? Map<String, dynamic>.from(json['customParams']) : null;
    socialMeta = json['socialMeta'] != null ? SocialMeta.fromJson(json['socialMeta']) : null;
    analytics = json['analytics'] != null ? Analytics.fromJson(json['analytics']) : null;
    isShortLink = json['isShortLink'];
    androidFallbackUrl = json['androidFallbackUrl'];
    iOSFallbackUrl = json['iOSFallbackUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['prefixUrl'] = prefixUrl;
    if (customParams != null) {
      data['customParams'] = customParams;
    }
    if (socialMeta != null) {
      data['socialMeta'] = socialMeta!.toJson();
    }
    if (analytics != null) {
      data['analytics'] = analytics!.toJson();
    }
    data['isShortLink'] = isShortLink;
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
