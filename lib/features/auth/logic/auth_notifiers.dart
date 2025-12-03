import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/auth/logic/auth_repo.dart';
import 'package:laundrymart/features/auth/model/app_settings.dart/app_settings.dart';
import 'package:laundrymart/features/auth/model/forgot_password_otp_submit_model/forgot_password_otp_submit_model.dart';
import 'package:laundrymart/features/auth/model/login_model/login_model.dart';
import 'package:laundrymart/features/auth/model/register_model/register_model.dart';
import 'package:laundrymart/services/api_state.dart';
import 'package:laundrymart/services/network_exceptions.dart';

class AppSettingsNotifier extends StateNotifier<ApiState<AppSettings>> {
  final IAuthRepo repo;
  AppSettingsNotifier(this.repo) : super(const ApiState.initial());

  Future<AppSettings> getAppSettings() async {
    state = const ApiState.loading();
    try {
      AppSettings appSettings = await repo.getAppSettings();
      state = ApiState.loaded(data: appSettings);
      return appSettings;
    } catch (e) {
      debugPrint("this is the error $e");
      state = ApiState.error(error: NetworkExceptions.errorText(e));
      rethrow;
    }
  }
}

class LoginNotifier extends StateNotifier<ApiState<LoginModel>> {
  LoginNotifier(this.repo, this.device_key) : super(const ApiState.initial());
  final IAuthRepo repo;
  // ignore: non_constant_identifier_names
  final String device_key;
  Future<void> login(String mobile, String password) async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
          data: await repo.login(
        mobile: mobile,
        password: password,
        type: "mobile",
        device_key: device_key,
      ));
    } catch (e) {
      debugPrint("this is the error $e");
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class RegistrationNotifier extends StateNotifier<ApiState<RegisterModel>> {
  RegistrationNotifier(this.repo) : super(const ApiState.initial());

  final IAuthRepo repo;

  Future<void> register(Map<String, dynamic> data) async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
        data: await repo.register(udata: data),
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class LogoutNotifier extends StateNotifier<ApiState<String>> {
  LogoutNotifier(this.repo, this.device_key) : super(const ApiState.initial());

  final IAuthRepo repo;
  // ignore: non_constant_identifier_names
  final String device_key;

  Future<void> logout() async {
    state = const ApiState.loading();
    try {
      await repo.logout(device_key: device_key);
      state = const ApiState.loaded(
        data: 'Success',
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class ForgotPassNotifier extends StateNotifier<ApiState<String>> {
  ForgotPassNotifier(this.repo) : super(const ApiState.initial());

  final IAuthRepo repo;

  Future<void> forgotPassword(
      {required String contact, required String verificatonType}) async {
    state = const ApiState.loading();
    try {
      final data = await repo.forgotPassword(
          contact: contact, verificationType: verificatonType);
      state = ApiState.loaded(data: data);
    } catch (e) {
      debugPrint(e.toString());
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class ForgotPassOtpVerficationNotifier
    extends StateNotifier<ApiState<ForgotPasswordOtpSubmitModel>> {
  ForgotPassOtpVerficationNotifier(this.repo) : super(const ApiState.initial());

  final IAuthRepo repo;

  Future<void> verifyOtp(String mobile, String otp) async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
        data: await repo.forgotPasswordVerification(mobile: mobile, otp: otp),
      );
    } catch (e) {
      debugPrint(e.toString());
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class ForgotPassResetPassNotifier extends StateNotifier<ApiState<String>> {
  ForgotPassResetPassNotifier(this.repo) : super(const ApiState.initial());

  final IAuthRepo repo;

  Future<void> resetPassword(
    String password,
    String passwordConfirmation,
    String token,
  ) async {
    state = const ApiState.loading();
    try {
      await repo.resetPassword(
        password_confirmation: passwordConfirmation,
        password: password,
        token: token,
      );
      state = const ApiState.loaded(
        data: 'Success',
      );
    } catch (e) {
      debugPrint(e.toString());
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}
