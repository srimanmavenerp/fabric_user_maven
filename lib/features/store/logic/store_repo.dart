import 'package:dio/dio.dart';
import 'package:laundrymart/features/store/model/all_ratinngs_model/all_ratinngs_model.dart';
import 'package:laundrymart/features/store/model/order_options_model/order_options_model.dart';
import 'package:laundrymart/features/store/model/service_model/service_model.dart';
import 'package:laundrymart/services/api_service.dart';

abstract class IStoreRepo {
  Future<ServiceModel> getServices(String id);
  Future<AllRatinngsModel> getRatings(String id);
  Future<OrderOptionsModel> getOptions(String id);
}

class StoreRepo extends IStoreRepo {
  final Dio _dio = getDio();
  @override
  Future<ServiceModel> getServices(String id) async {
    final Response response = await _dio.get("/services?store_id=$id");
    return ServiceModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<AllRatinngsModel> getRatings(String id) async {
    try {
      final Response response = await _dio.get("/shop/ratings/$id");
      return AllRatinngsModel.fromMap(response.data as Map<String, dynamic>);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<OrderOptionsModel> getOptions(String id) async {
    final Response response = await _dio.get("/order-conditions/$id");
    return OrderOptionsModel.fromMap(response.data as Map<String, dynamic>);
  }
}
