import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/profile/logic/profile_repo.dart';
import 'package:laundrymart/features/profile/model/profile_info_model/profile_info_model.dart';
import 'package:laundrymart/services/api_state.dart';
import 'package:laundrymart/services/network_exceptions.dart';

class UpdateProfileNotifier extends StateNotifier<ApiState<String>> {
  UpdateProfileNotifier(this._repo) : super(const ApiState.initial());

  final IProfileRepo _repo;
  Future<void> updateProfile(Map<String, dynamic> data, File? file) async {
    state = const ApiState.loading();
    try {
      await _repo.updateProfile(data: data, file: file);
      state = const ApiState.loaded(data: 'Success');
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class ProfileInfoNotifier extends StateNotifier<ApiState<ProfileInfoModel>> {
  ProfileInfoNotifier(this._repo) : super(const ApiState.initial()) {
    getProfile();
  }

  final IProfileRepo _repo;
  Future<void> getProfile() async {
    state = const ApiState.loading();
    try {
      final ProfileInfoModel userdata = await _repo.getProfileInfo();
      final Box userBox = Hive.box(AppHSC.userBox);
      userBox.putAll(userdata.data!.user!.toMap());
      state = ApiState.loaded(
        data: userdata,
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class ChangePassNotifier extends StateNotifier<ApiState<String>> {
  ChangePassNotifier(this.repo) : super(const ApiState.initial());

  final IProfileRepo repo;

  Future<void> changePassword(
    String current_password,
    String password,
    String password_confirmation,
  ) async {
    state = const ApiState.loading();
    try {
      await repo.changePassword(
        current_password: current_password,
        password: password,
        password_confirmation: password_confirmation,
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
