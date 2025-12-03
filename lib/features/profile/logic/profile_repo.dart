// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:laundrymart/features/profile/model/profile_info_model/profile_info_model.dart';
import 'package:laundrymart/services/api_service.dart';

abstract class IProfileRepo {
  Future<ProfileInfoModel> getProfileInfo();
  Future<void> updateProfile({required Map<String, dynamic> data, File? file});
  Future<void> changePassword({
    //
    required String current_password,
    required String password,
    required String password_confirmation,
  });
}

class ProfileRepo implements IProfileRepo {
  final Dio _dio = getDio();
  @override
  Future<ProfileInfoModel> getProfileInfo() async {
    final Response reponse = await _dio.get('/users/profile');
    return ProfileInfoModel.fromMap(reponse.data as Map<String, dynamic>);
  }

  @override
  Future<void> updateProfile({
    required Map<String, dynamic> data,
    File? file,
  }) async {
    final ext = file?.path.split('.').last;

    // if (file != null) {
    //   await _dio.post(
    //     '/users/profile-photo/update',
    //     data: FormData.fromMap({
    //       'profile_photo': await MultipartFile.fromFile(
    //         file.path,
    //         filename:
    //             "${DateTime.now().millisecondsSinceEpoch.toString()}.$ext",
    //       )
    //     }),
    //   );
    // }
    await _dio.post(
      '/users/update',
      data: FormData.fromMap({
        ...data,
        'profile_photo': file != null
            ? await MultipartFile.fromFile(
                file.path,
                filename:
                    "${DateTime.now().millisecondsSinceEpoch.toString()}.$ext",
              )
            : null,
      }),
    );
  }

  @override
  Future<void> changePassword({
    required String current_password,
    required String password,
    required String password_confirmation,
  }) async {
    await _dio.post(
      '/change/password',
      data: FormData.fromMap({
        'current_password': current_password,
        'password': password,
        'password_confirmation': password_confirmation
      }),
    );
  }
}
