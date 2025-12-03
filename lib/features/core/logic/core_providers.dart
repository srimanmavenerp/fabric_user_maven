import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/core/logic/core_notifiers.dart';
import 'package:laundrymart/features/core/logic/core_repo.dart';
import 'package:laundrymart/features/core/model/all_stores_model/all_stores_model.dart';
import 'package:laundrymart/features/core/model/promotions_model/promotions_model.dart';
import 'package:laundrymart/features/store/model/service_model/service_model.dart';
import 'package:laundrymart/services/api_state.dart';

final coreRepoProvider = Provider<ICoreRepo>((ref) {
  return CoreRepo();
});

final allPromotionsProvider =
    StateNotifierProvider<AllPromotionsNotifier, ApiState<PromotionsModel>>(
        (ref) {
  return AllPromotionsNotifier(ref.watch(coreRepoProvider));
});

final allServicesProvider =
    StateNotifierProvider<AllServicerNotifier, ApiState<ServiceModel>>((ref) {
  return AllServicerNotifier(ref.watch(coreRepoProvider));
});

final allStoresProvider =
    StateNotifierProvider<AllStoresNotifier, ApiState<AllStoresModel>>((ref) {
  return AllStoresNotifier(ref.watch(coreRepoProvider));
});

final searchStoreProvider =
    StateNotifierProvider<SearchStoreNotifier, bool>((ref) {
  return SearchStoreNotifier(ref.watch(coreRepoProvider));
});

final serviceBasedStoresProvider = StateNotifierProvider.family<
    ServiceBasedStoresNotifier,
    ApiState<AllStoresModel>,
    int>((ref, serviceId) {
  return ServiceBasedStoresNotifier(ref.watch(coreRepoProvider), serviceId);
});
