import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/services/logic/service_repo.dart';
import 'package:laundrymart/features/services/model/product_list_model/product_list_model.dart';
import 'package:laundrymart/features/services/model/variant_list_model/variant_list_model.dart';
import 'package:laundrymart/services/api_state.dart';
import 'package:laundrymart/services/network_exceptions.dart';

class ServiceVariationsNotifier
    extends StateNotifier<ApiState<VariantListModel>> {
  ServiceVariationsNotifier(this.repo, this.data)
      : super(const ApiState.initial()) {
    getAllVariations();
  }

  final IServiceRepo repo;
  final ProducServiceVariavtionDataModel data;

  Future<void> getAllVariations() async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
        data: await repo.getVariations(data.storeID, data.servieID),
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class VariationProductsNotifier
    extends StateNotifier<ApiState<ProductListModel>> {
  VariationProductsNotifier(this.repo, this.data)
      : super(const ApiState.initial()) {
    getAllProducts();
  }

  final IServiceRepo repo;
  final ServiceVariavtionDataModel data;

  Future<void> getAllProducts() async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
        data: await repo.getProducts(data.serviceID, data.variantID),
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class ProducServiceVariavtionDataModel {
  String servieID;
  String storeID;
  ProducServiceVariavtionDataModel({
    required this.servieID,
    required this.storeID,
  });

  ProducServiceVariavtionDataModel copyWith({
    String? servieID,
    String? storeID,
  }) {
    return ProducServiceVariavtionDataModel(
      servieID: servieID ?? this.servieID,
      storeID: storeID ?? this.storeID,
    );
  }
}

class ServiceVariavtionDataModel {
  String serviceID;
  String variantID;
  ServiceVariavtionDataModel({
    required this.serviceID,
    required this.variantID,
  });

  ServiceVariavtionDataModel copyWith({
    String? serviceID,
    String? variantID,
  }) {
    return ServiceVariavtionDataModel(
      serviceID: serviceID ?? this.serviceID,
      variantID: variantID ?? this.variantID,
    );
  }
}
