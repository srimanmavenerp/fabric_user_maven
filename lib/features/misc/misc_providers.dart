import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/auth/model/app_settings.dart/app_settings.dart';
import 'package:laundrymart/features/payment/model/schedule_model.dart';

final orderOrovider = StateProvider<int>((ref) {
  return 0;
});

final homeScreenPageControllerProvider =
    Provider.autoDispose<PageController>((ref) {
  return PageController(initialPage: 4);
});

final homeScreenIndexProvider = StateProvider.autoDispose<int>((ref) {
  return 0; //4 Means Home Screen
});
final dateProvider = StateProvider.family<DateTime?, String>((ref, id) => null);

final storeIdProvider = StateProvider<int>(
  (ref) {
    return 0;
  },
);
final scheduleProvider =
    StateProvider.family.autoDispose<ScheduleModel?, String>((ref, id) => null);

final orderProcessingProvider = StateProvider<bool>((ref) {
  return false;
});

final appSettingDataProvider = StateProvider<AppSettings>((ref) => AppSettings(
      currency: '',
      iosUrl: '',
      androidUrl: '',
      twoStepVerification: false,
      deviceType: 'mobile',
      cashOnDelivery: true,
      onlinePayment: false,
    ));
