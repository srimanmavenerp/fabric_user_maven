import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/profile/logic/profile_notifiers.dart';
import 'package:laundrymart/features/profile/logic/profile_repo.dart';
import 'package:laundrymart/features/profile/model/profile_info_model/profile_info_model.dart';
import 'package:laundrymart/services/api_state.dart';

final profileRepoProvider = Provider<IProfileRepo>(
  (ref) => ProfileRepo(),
);
final profileUpdateProvider =
    StateNotifierProvider<UpdateProfileNotifier, ApiState<String>>((ref) {
  return UpdateProfileNotifier(ref.watch(profileRepoProvider));
});

final profileInfoProvider =
    StateNotifierProvider<ProfileInfoNotifier, ApiState<ProfileInfoModel>>(
        (ref) {
  return ProfileInfoNotifier(ref.watch(profileRepoProvider));
});

final changePassProvider =
    StateNotifierProvider<ChangePassNotifier, ApiState<String>>((ref) {
  return ChangePassNotifier(ref.watch(profileRepoProvider));
});
