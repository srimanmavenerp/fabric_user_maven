import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/others/logic/settings_repo.dart';
import 'package:laundrymart/features/others/model/about_us.dart/about.dart';
import 'package:laundrymart/features/others/model/terms_of_service_model/terms_of_service_model.dart';
import 'package:laundrymart/services/api_state.dart';
import 'package:laundrymart/services/network_exceptions.dart';

class TermsOfServiceNotifier
    extends StateNotifier<ApiState<TermsOfServiceModel>> {
  TermsOfServiceNotifier(this.repo) : super(const ApiState.initial()) {
    getTOS();
  }

  final ISettingsRepo repo;

  Future<void> getTOS() async {
    state = const ApiState.loading();

    try {
      final TermsOfServiceModel data = await repo.getTOS();

      state = ApiState.loaded(
        data: data,
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class PrivacyPolicyNotifier
    extends StateNotifier<ApiState<TermsOfServiceModel>> {
  PrivacyPolicyNotifier(this.repo) : super(const ApiState.initial()) {
    getPrivacyPolicy();
  }

  final ISettingsRepo repo;

  Future<void> getPrivacyPolicy() async {
    state = const ApiState.loading();

    try {
      final TermsOfServiceModel data = await repo.getPrivacyPolicy();

      state = ApiState.loaded(
        data: data,
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class AboutUsNotifier extends StateNotifier<ApiState<TermsOfServiceModel>> {
  AboutUsNotifier(this.repo) : super(const ApiState.initial()) {
    getAboutUs();
  }

  final ISettingsRepo repo;

  Future<void> getAboutUs() async {
    state = const ApiState.loading();

    try {
      final TermsOfServiceModel data = await repo.getAboutUs();

      state = ApiState.loaded(
        data: data,
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class AboutNotifier extends StateNotifier<ApiState<AboutUs>> {
  AboutNotifier(this.repo) : super(const ApiState.initial()) {
    getAbout();
  }

  final ISettingsRepo repo;

  Future<void> getAbout() async {
    state = const ApiState.loading();

    try {
      final AboutUs data = await repo.getAbout();

      state = ApiState.loaded(data: data);
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}
