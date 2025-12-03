class AppSettings {
  final String currency;
  final String androidUrl;
  final String iosUrl;
  final bool twoStepVerification;
  final String deviceType;
  final bool cashOnDelivery;
  final bool onlinePayment;
  AppSettings({
    required this.currency,
    required this.androidUrl,
    required this.iosUrl,
    required this.twoStepVerification,
    required this.deviceType,
    required this.cashOnDelivery,
    required this.onlinePayment,
  });

  AppSettings copyWith({
    String? currency,
    String? androidUrl,
    String? iosUrl,
    bool? twoStepVerification,
    String? deviceType,
    bool? cashOnDelivery,
    bool? onlinePayment,
  }) {
    return AppSettings(
      currency: currency ?? this.currency,
      androidUrl: androidUrl ?? this.androidUrl,
      iosUrl: iosUrl ?? this.iosUrl,
      twoStepVerification: twoStepVerification ?? this.twoStepVerification,
      deviceType: deviceType ?? this.deviceType,
      cashOnDelivery: cashOnDelivery ?? this.cashOnDelivery,
      onlinePayment: onlinePayment ?? this.onlinePayment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currency': currency,
      'android_url': androidUrl,
      'ios_url': iosUrl,
      'two_step_verification': twoStepVerification,
      'device_type': deviceType,
      'cash_on_delivery': cashOnDelivery,
      'online_payment': onlinePayment,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      currency: map['currency'] as String,
      androidUrl: map['android_url'] as String,
      iosUrl: map['ios_url'] ?? '',
      twoStepVerification: map['two_step_verification'] as bool,
      deviceType:
          map['device_type'] != null ? map['device_type'] as String : 'mobile',
      cashOnDelivery: map['cash_on_delivery'] as bool,
      onlinePayment: map['online_payment'] as bool,
    );
  }
}
