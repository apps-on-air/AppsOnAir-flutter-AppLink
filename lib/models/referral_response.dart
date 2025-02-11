class ReferralResponse {
  String? installReferrer;
  int? referrerClickTimestamp;
  int? installBeginTimestamp;
  String? installVersion;

  ReferralResponse(
      {this.installReferrer, this.referrerClickTimestamp, this.installBeginTimestamp, this.installVersion});

  ReferralResponse.fromJson(Map<String, dynamic> json) {
    installReferrer = json['installReferrer'];
    referrerClickTimestamp = json['referrerClickTimestamp'];
    installBeginTimestamp = json['installBeginTimestamp'];
    installVersion = json['installVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['installReferrer'] = installReferrer;
    data['referrerClickTimestamp'] = referrerClickTimestamp;
    data['installBeginTimestamp'] = installBeginTimestamp;
    data['installVersion'] = installVersion;
    return data;
  }
}
