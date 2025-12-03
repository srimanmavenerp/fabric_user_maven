import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/store/logic/store_notifiers.dart';
import 'package:laundrymart/features/store/logic/store_repo.dart';
import 'package:laundrymart/features/store/model/all_ratinngs_model/all_ratinngs_model.dart';
import 'package:laundrymart/features/store/model/order_options_model/order_options_model.dart';
import 'package:laundrymart/features/store/model/service_model/service_model.dart';
import 'package:laundrymart/services/api_state.dart';

final storeRepoProvider = Provider<IStoreRepo>((ref) {
  return StoreRepo();
});

final serviceProvider = StateNotifierProvider.family<ServiceNotifier,
    ApiState<ServiceModel>, String>((ref, id) {
  return ServiceNotifier(ref.watch(storeRepoProvider), id);
});
final allRatingsProvider = StateNotifierProvider.family<AllRatingsNotifier,
    ApiState<AllRatinngsModel>, String>((ref, id) {
  return AllRatingsNotifier(ref.watch(storeRepoProvider), id);
});

final orderOptionsProvider = StateNotifierProvider.family<OrderOptionsNotifier,
    ApiState<OrderOptionsModel>, String>((ref, id) {
  return OrderOptionsNotifier(ref.watch(storeRepoProvider), id);
});
