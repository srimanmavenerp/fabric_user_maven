import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/auth/logic/auth_notifiers.dart';
import 'package:laundrymart/features/auth/logic/auth_repo.dart';
import 'package:laundrymart/features/auth/model/app_settings.dart/app_settings.dart';
import 'package:laundrymart/features/auth/model/forgot_password_otp_submit_model/forgot_password_otp_submit_model.dart';
import 'package:laundrymart/features/auth/model/login_model/login_model.dart';
import 'package:laundrymart/features/auth/model/register_model/register_model.dart';
import 'package:laundrymart/features/constants/misc_providers.dart';
import 'package:laundrymart/services/api_state.dart';

final authRepoProvider = Provider<IAuthRepo>((ref) {
  return AuthRepo();
});

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, ApiState<AppSettings>>((ref) {
  return AppSettingsNotifier(
    ref.watch(authRepoProvider),
  );
});

final loginProvider =
    StateNotifierProvider<LoginNotifier, ApiState<LoginModel>>((ref) {
  return LoginNotifier(
    ref.watch(authRepoProvider),
    ref.watch(onesignalDeviceIDProvider),
  );
});
final registrationProvider =
    StateNotifierProvider<RegistrationNotifier, ApiState<RegisterModel>>((ref) {
  return RegistrationNotifier(ref.watch(authRepoProvider));
});

final logOutProvider =
    StateNotifierProvider<LogoutNotifier, ApiState<String>>((ref) {
  return LogoutNotifier(
    ref.watch(authRepoProvider),
    ref.watch(onesignalDeviceIDProvider),
  );
});

final forgotPassProvider =
    StateNotifierProvider<ForgotPassNotifier, ApiState<String>>((ref) {
  return ForgotPassNotifier(ref.watch(authRepoProvider));
});

final forgotPassOtpVerificationProvider = StateNotifierProvider<
    ForgotPassOtpVerficationNotifier,
    ApiState<ForgotPasswordOtpSubmitModel>>((ref) {
  return ForgotPassOtpVerficationNotifier(ref.watch(authRepoProvider));
});

final forgotPassResetPassProvider =
    StateNotifierProvider<ForgotPassResetPassNotifier, ApiState<String>>((ref) {
  return ForgotPassResetPassNotifier(ref.watch(authRepoProvider));
});
