import 'package:dio/dio.dart';
import 'package:laundrymart/features/core/model/all_stores_model/all_stores_model.dart';
import 'package:laundrymart/features/core/model/promotions_model/promotions_model.dart';
import 'package:laundrymart/features/store/model/service_model/service_model.dart';
import 'package:laundrymart/services/api_service.dart';

abstract class ICoreRepo {
  Future<PromotionsModel> getPromotions();
  Future<ServiceModel> getServices();
  Future<AllStoresModel> getStores({required String lat, required String lng});
  Future<AllStoresModel> searchStore(
      {required String lat, required String lng, required String query});

  Future<AllStoresModel> getServiceBasedStores(
      {required String lat, required String lng, required int serviceId});
}

class CoreRepo implements ICoreRepo {
  final Dio _dio = getDio();

  @override
  Future<PromotionsModel> getPromotions() async {
    final Response reponse = await _dio.get('/promotions');
    return PromotionsModel.fromMap(reponse.data as Map<String, dynamic>);
  }

  @override
  Future<ServiceModel> getServices() async {
    final Response reponse = await _dio.get('/services');
    return ServiceModel.fromMap(reponse.data as Map<String, dynamic>);
  }

  @override
  Future<AllStoresModel> getStores(
      {required String lat, required String lng}) async {
    final Response response = await _dio
        .get("/shops", queryParameters: {"latitude": lat, "longitude": lng});
    return AllStoresModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<AllStoresModel> searchStore(
      {required String lat, required String lng, required String query}) {
    var response = _dio.get("/shops",
        queryParameters: {"latitude": lat, "longitude": lng, "search": query});

    return response.then(
        (value) => AllStoresModel.fromMap(value.data as Map<String, dynamic>));
  }

  @override
  Future<AllStoresModel> getServiceBasedStores(
      {required String lat, required String lng, required int serviceId}) {
    var response = _dio.get("/shops", queryParameters: {
      "latitude": lat,
      "longitude": lng,
      "service_id": serviceId
    });

    return response.then(
        (value) => AllStoresModel.fromMap(value.data as Map<String, dynamic>));
  }
}
