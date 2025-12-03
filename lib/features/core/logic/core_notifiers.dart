import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/core/logic/core_repo.dart';
import 'package:laundrymart/features/core/model/all_stores_model/all_stores_model.dart';
import 'package:laundrymart/features/core/model/promotions_model/promotions_model.dart';
import 'package:laundrymart/features/store/model/service_model/service_model.dart';
import 'package:laundrymart/services/api_state.dart';
import 'package:laundrymart/services/network_exceptions.dart';

class AllPromotionsNotifier extends StateNotifier<ApiState<PromotionsModel>> {
  AllPromotionsNotifier(this.repo) : super(const ApiState.initial()) {
    getAllpromotions();
  }

  final ICoreRepo repo;

  Future<void> getAllpromotions() async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
        data: await repo.getPromotions(),
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class AllServicerNotifier extends StateNotifier<ApiState<ServiceModel>> {
  AllServicerNotifier(this.repo) : super(const ApiState.initial()) {
    getAllServices();
  }

  final ICoreRepo repo;

  Future<void> getAllServices() async {
    state = const ApiState.loading();
    // try {
      state = ApiState.loaded(
        data: await repo.getServices(),
      );
    // } catch (e) {
    //   state = ApiState.error(error: NetworkExceptions.errorText(e));
    // }
  }
}

class AllStoresNotifier extends StateNotifier<ApiState<AllStoresModel>> {
  AllStoresNotifier(this.repo) : super(const ApiState.initial()) {
    getAllStores();
  }
  final ICoreRepo repo;
  final Box locationBox = Hive.box(AppHSC.locationBox);

  Future<void> getAllStores() async {
    double lat = locationBox.get('latitude');
    double lng = locationBox.get('longitude');
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
          data: await repo.getStores(lat: lat.toString(), lng: lng.toString()));
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class SearchStoreNotifier extends StateNotifier<bool> {
  SearchStoreNotifier(this.repo) : super(false);
  final ICoreRepo repo;
  final Box locationBox = Hive.box(AppHSC.locationBox);

  Future<AllStoresModel> searchStore({required String? query}) {
    double lat = locationBox.get('latitude');
    double lng = locationBox.get('longitude');
    state = true;
    try {
      var data = repo.searchStore(
          lat: lat.toString(), lng: lng.toString(), query: query!);
      state = false;
      return data;
    } catch (e) {
      state = false;
      throw NetworkExceptions.errorText(e);
    }
  }
}

class ServiceBasedStoresNotifier
    extends StateNotifier<ApiState<AllStoresModel>> {
  ServiceBasedStoresNotifier(this.repo, this.serviceId)
      : super(const ApiState.initial()) {
    getServiceBasedStores();
  }
  final ICoreRepo repo;
  final int serviceId;
  final Box locationBox = Hive.box(AppHSC.locationBox);

  Future<void> getServiceBasedStores() async {
    double lat = locationBox.get('latitude');
    double lng = locationBox.get('longitude');
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
          data: await repo.getServiceBasedStores(
              lat: lat.toString(), lng: lng.toString(), serviceId: serviceId));
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}
