import 'package:dio/dio.dart';
import 'package:laundrymart/features/services/model/product_list_model/product_list_model.dart';
import 'package:laundrymart/features/services/model/variant_list_model/variant_list_model.dart';
import 'package:laundrymart/services/api_service.dart';

abstract class IServiceRepo {
  Future<VariantListModel> getVariations(String storeid, String serviceid);
  Future<ProductListModel> getProducts(String serviceid, String varientid);
}

class ServiceRepo implements IServiceRepo {
  final Dio _dio = getDio();

  @override
  Future<VariantListModel> getVariations(
      String storeid, String serviceid) async {
    try {
      final Response reponse =
          await _dio.get('/variants?service_id=$serviceid&store_id=$storeid');
      return VariantListModel.fromMap(reponse.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductListModel> getProducts(
      String serviceid, String varientid) async {
    final Response response =
        await _dio.get("/products?service_id=$serviceid&variant_id=$varientid");

    return ProductListModel.fromMap(response.data as Map<String, dynamic>);
  }
}
