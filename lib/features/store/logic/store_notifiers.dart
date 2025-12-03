import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/store/logic/store_repo.dart';
import 'package:laundrymart/features/store/model/all_ratinngs_model/all_ratinngs_model.dart';
import 'package:laundrymart/features/store/model/order_options_model/order_options_model.dart';
import 'package:laundrymart/features/store/model/service_model/service_model.dart';
import 'package:laundrymart/services/api_state.dart';
import 'package:laundrymart/services/network_exceptions.dart';

class ServiceNotifier extends StateNotifier<ApiState<ServiceModel>> {
  ServiceNotifier(this.repo, this.id) : super(const ApiState.initial()) {
    getService();
  }
  final IStoreRepo repo;
  final String id;
  Future<void> getService() async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
        data: await repo.getServices(id),
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class AllRatingsNotifier extends StateNotifier<ApiState<AllRatinngsModel>> {
  AllRatingsNotifier(this.repo, this.id) : super(const ApiState.initial()) {
    getAllRating();
  }
  final IStoreRepo repo;
  final String id;
  Future<void> getAllRating() async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
        data: await repo.getRatings(id),
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class OrderOptionsNotifier extends StateNotifier<ApiState<OrderOptionsModel>> {
  OrderOptionsNotifier(this.repo, this.id) : super(const ApiState.initial()) {
    getAllOption();
  }
  final IStoreRepo repo;
  final String id;
  Future<void> getAllOption() async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
        data: await repo.getOptions(id),
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}
