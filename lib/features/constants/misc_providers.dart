import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAppLive = Provider<bool>((ref) => true);
final onesignalDeviceIDProvider = StateProvider<String>((ref) {
  return '';
});
final itemSelectMenuIndexProvider = StateProvider<int>((ref) {
  return 0;
});
final sortProvider = StateProvider<int>((ref) {
  return 0;
});
final onBoardingSliderIndexProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

final onBoardingSliderControllerProvider =
    Provider.family.autoDispose<PageController, String>((ref, name) {
  return PageController();
});