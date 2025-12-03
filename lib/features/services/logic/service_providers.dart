import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/services/logic/service_notifiers.dart';
import 'package:laundrymart/features/services/logic/service_repo.dart';
import 'package:laundrymart/features/services/model/product_list_model/product_list_model.dart';
import 'package:laundrymart/features/services/model/variant_list_model/variant_list_model.dart';
import 'package:laundrymart/services/api_state.dart';

final serviceRepoProvider = Provider<IServiceRepo>((ref) {
  return ServiceRepo();
});

final servicesVariationsProvider = StateNotifierProvider.autoDispose<
    ServiceVariationsNotifier, ApiState<VariantListModel>>((ref) {
  return ServiceVariationsNotifier(
      ref.watch(serviceRepoProvider), ref.watch(variantfilterProvider));
});
final variationProductsProvider = StateNotifierProvider.autoDispose<
    VariationProductsNotifier, ApiState<ProductListModel>>((ref) {
  return VariationProductsNotifier(
      ref.watch(serviceRepoProvider), ref.watch(productfilterProvider));
});
final variantfilterProvider =
    StateProvider<ProducServiceVariavtionDataModel>((ref) {
  return ProducServiceVariavtionDataModel(servieID: '', storeID: '');
});
final productfilterProvider = StateProvider<ServiceVariavtionDataModel>((ref) {
  return ServiceVariavtionDataModel(serviceID: '', variantID: '');
});
