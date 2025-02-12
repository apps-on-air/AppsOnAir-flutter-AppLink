class ReferralResponse {
  String? installReferrer;
  int? referrerClickTimestamp;
  int? installBeginTimestamp;
  String? installVersion;

  ReferralResponse({
    this.installReferrer,
    this.referrerClickTimestamp,
    this.installBeginTimestamp,
    this.installVersion,
  });

  ReferralResponse.fromJson(Map<String, dynamic> json)
      : installReferrer = json['installReferrer'],
        referrerClickTimestamp = json['referrerClickTimestamp'],
        installBeginTimestamp = json['installBeginTimestamp'],
        installVersion = json['installVersion'];

  Map<String, dynamic> toJson() => {
        'installReferrer': installReferrer,
        'referrerClickTimestamp': referrerClickTimestamp,
        'installBeginTimestamp': installBeginTimestamp,
        'installVersion': installVersion,
      };
}
