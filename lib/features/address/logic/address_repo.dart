import 'package:dio/dio.dart';
import 'package:laundrymart/features/address/model/address_list_model/address_list_model.dart';
import 'package:laundrymart/services/api_service.dart';

abstract class IAddressRepo {
  Future<AddressListModel> getAddresses();
  Future<void> addAddress(Map<String, dynamic> address);
  Future<void> updateAddress(Map<String, dynamic> address, String addressID);
}

class AddressRepo implements IAddressRepo {
  final Dio _dio = getDio();
  @override
  Future<AddressListModel> getAddresses() async {
    final Response response = await _dio.get(
      '/addresses',
    );
    return AddressListModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> addAddress(Map<String, dynamic> address) async {
    await _dio.post('/addresses', data: FormData.fromMap(address));
  }

  @override
  Future<void> updateAddress(
    Map<String, dynamic> address,
    String addressID,
  ) async {
    await _dio.post(
      '/addresses/$addressID',
      data: FormData.fromMap(address),
    );
  }
}
