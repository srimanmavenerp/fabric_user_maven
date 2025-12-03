import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/others/logic/settings_notfier.dart';
import 'package:laundrymart/features/others/logic/settings_repo.dart';
import 'package:laundrymart/features/others/model/about_us.dart/about.dart';
import 'package:laundrymart/features/others/model/terms_of_service_model/terms_of_service_model.dart';
import 'package:laundrymart/services/api_state.dart';

final settingsRepoProvider = Provider<ISettingsRepo>((ref) {
  return SettingsRepo();
});

//
//
//

//
//
//
final tosProvider = StateNotifierProvider<TermsOfServiceNotifier,
    ApiState<TermsOfServiceModel>>((ref) {
  return TermsOfServiceNotifier(ref.watch(settingsRepoProvider));
});
//
//
//
final privacyProvider =
    StateNotifierProvider<PrivacyPolicyNotifier, ApiState<TermsOfServiceModel>>(
        (ref) {
  return PrivacyPolicyNotifier(ref.watch(settingsRepoProvider));
});
//
//
//
final aboutUsProvider =
    StateNotifierProvider<AboutUsNotifier, ApiState<TermsOfServiceModel>>(
        (ref) {
  return AboutUsNotifier(ref.watch(settingsRepoProvider));
});
final aboutProvidre =
    StateNotifierProvider<AboutNotifier, ApiState<AboutUs>>((ref) {
  return AboutNotifier(ref.watch(settingsRepoProvider));
});
