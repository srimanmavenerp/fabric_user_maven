import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:laundrymart/features/auth/model/app_settings.dart/app_settings.dart';
import 'package:laundrymart/features/auth/model/forgot_password_otp_submit_model/forgot_password_otp_submit_model.dart';
import 'package:laundrymart/features/auth/model/login_model/login_model.dart';
import 'package:laundrymart/features/auth/model/register_model/register_model.dart';
import 'package:laundrymart/services/api_service.dart';

abstract class IAuthRepo {
  // master data method

  Future<AppSettings> getAppSettings();

  Future<LoginModel> login({
    required String mobile,
    required String password,
    required String type,
    required String device_key,
  });
  Future<RegisterModel> register({required Map<String, dynamic> udata});
  Future<void> logout({
    required String device_key,
  });
  Future<String> forgotPassword({
    required String contact,
    required String verificationType,
  });

  Future<ForgotPasswordOtpSubmitModel> forgotPasswordVerification({
    //
    required String mobile,
    required String otp,
  });

  Future<void> resetPassword({
    //
    required String password,
    required String password_confirmation,
    required String token,
  });
}

class AuthRepo extends IAuthRepo {
  final Dio _dio = getDio();

  @override
  Future<AppSettings> getAppSettings() async {
    final Response response = await _dio.get('/master');
    return AppSettings.fromMap(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<LoginModel> login({
    required String mobile,
    required String password,
    required String type,
    required String device_key,
  }) async {
    final token = await FirebaseMessaging.instance.getToken();
    String deviceType = 'android';
    if (Platform.isIOS) {
      deviceType = 'ios';
    }
    final Response response = await _dio.post(
      '/login',
      data: FormData.fromMap(
        {
          'mobile': mobile,
          'password': password,
          'type': "mobile",
          'device_key': token,
          'device_type': deviceType
        },
      ),
    );
    return LoginModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<RegisterModel> register({required Map<String, dynamic> udata}) async {
    final Response response =
        await _dio.post('/register', data: FormData.fromMap(udata));

    return RegisterModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> logout({
    required String device_key,
  }) async {
    await _dio.post(
      '/logout',
      data: FormData.fromMap({'device_key': device_key}),
    );
  }

  @override
  Future<String> forgotPassword(
      {required String contact, required String verificationType}) async {
    final Map<String, dynamic> data = {};
    data["contact"] = contact;
    data["type"] = verificationType;
    final response = await _dio.post(
      '/forgot-password',
      data: FormData.fromMap(data),
    );
    return response.data["message"] as String;
  }

  @override
  Future<ForgotPasswordOtpSubmitModel> forgotPasswordVerification(
      {required String mobile, required String otp}) async {
    final Response response = await _dio.post(
      '/forgot-password/otp/verify',
      data: FormData.fromMap({'mobile': mobile, 'otp': otp, 'type': 'mobile'}),
    );
    return ForgotPasswordOtpSubmitModel.fromMap(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<void> resetPassword({
    required String password,
    required String password_confirmation,
    required String token,
  }) async {
    await _dio.post(
      '/reset-password',
      data: FormData.fromMap({
        'password': password,
        'password_confirmation': password_confirmation,
        'token': token
      }),
    );
  }
}

// class OfflineAuthRepo extends IAuthRepo {
//   @override
//   Future<LoginModel> login({
//     required String mobile,
//     required String password,
//     required String type,
//     required String device_key,
//   }) async {
//     await Future.delayed(apiDataDuration);

//     return LoginModel.fromMap(LoginOfflineData.loginData);
//   }

//   // @override
//   // Future<String> forgotPassword({required String mobile}) async {
//   //   await Future.delayed(apiDataDuration);
//   // }

//   @override
//   Future<void> resetPassword({
//     required String password,
//     required String password_confirmation,
//     required String token,
//   }) async {
//     await Future.delayed(apiDataDuration);
//   }

//   @override
//   Future<void> logout({
//     required String device_key,
//   }) async {
//     await Future.delayed(apiDataDuration);
//   }

//   @override
//   Future<void> addProfilePhoto({required File profile_photo}) async {
//     await Future.delayed(apiDataDuration);
//   }

//   @override
//   Future<RegisterModel> register({required Map<String, dynamic> udata}) async {
//     await Future.delayed(apiDataDuration);

//     return RegisterModel.fromMap(LoginOfflineData.registerData);
//   }

//   @override
//   Future<void> resendOTP(String contact) async {
//     await Future.delayed(apiDataDuration);
//   }

//   @override
//   Future<void> signUpVerification({
//     required String contact,
//     required String otp,
//   }) async {
//     await Future.delayed(apiDataDuration);
//   }

//   @override
//   Future<String> forgotPassword({required String mobile}) {
//     // TODO: implement forgotPassword
//     throw UnimplementedError();
//   }

//   @override
//   Future<ForgotPasswordOtpSubmitModel> forgotPasswordVerification(
//       {required String mobile ,required String otp}) {
//     // TODO: implement forgotPasswordVerification
//     throw UnimplementedError();
//   }
// }
