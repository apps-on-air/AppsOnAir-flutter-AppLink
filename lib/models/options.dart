class Options {
  String? url;
  String? prefixUrl;
  CustomParams? customParams;
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
      this.isShortLink,
      this.androidFallbackUrl,
      this.iOSFallbackUrl});

  Options.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    prefixUrl = json['prefixUrl'];
    customParams = json['customParams'] != null ? CustomParams.fromJson(json['customParams']) : null;
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
      data['customParams'] = customParams!.toJson();
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

class CustomParams {
  String? referrer;

  CustomParams({this.referrer});

  CustomParams.fromJson(Map<String, dynamic> json) {
    referrer = json['referrer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['referrer'] = referrer;
    return data;
  }
}

class SocialMeta {
  String? title;
  String? description;
  String? imageUrl;

  SocialMeta({this.title, this.description, this.imageUrl});

  SocialMeta.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    return data;
  }
}

class Analytics {
  String? platform;
  String? campaign;
  String? utmSource;
  String? utmMedium;
  String? utmCampaign;

  Analytics({this.platform, this.campaign, this.utmSource, this.utmMedium, this.utmCampaign});

  Analytics.fromJson(Map<String, dynamic> json) {
    platform = json['platform'];
    campaign = json['campaign'];
    utmSource = json['utmSource'];
    utmMedium = json['utmMedium'];
    utmCampaign = json['utmCampaign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['platform'] = platform;
    data['campaign'] = campaign;
    data['utmSource'] = utmSource;
    data['utmMedium'] = utmMedium;
    data['utmCampaign'] = utmCampaign;
    return data;
  }
}
