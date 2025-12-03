import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/address/logic/address_repo.dart';
import 'package:laundrymart/features/address/model/address_list_model/address_list_model.dart';
import 'package:laundrymart/services/api_state.dart';
import 'package:laundrymart/services/network_exceptions.dart';

class AddressListNotifier extends StateNotifier<ApiState<AddressListModel>> {
  AddressListNotifier(this._repo) : super(const ApiState.initial()) {
    getAddress();
  }
  final IAddressRepo _repo;
  Future<void> getAddress() async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(data: await _repo.getAddresses());
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class AddAddressNotifier extends StateNotifier<ApiState<String>> {
  AddAddressNotifier(this._repo) : super(const ApiState.initial());
  final IAddressRepo _repo;
  Future<void> addAddress({required Map<String, dynamic> address}) async {
    state = const ApiState.loading();
    try {
      await _repo.addAddress(address);
      state = const ApiState.loaded(data: 'Successs');
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class UpdateAddressNotifier extends StateNotifier<ApiState<String>> {
  UpdateAddressNotifier(this._repo) : super(const ApiState.initial());
  final IAddressRepo _repo;
  Future<void> updateAddress({
    required Map<String, dynamic> address,
    required String addressID,
  }) async {
    state = const ApiState.loading();
    try {
      await _repo.updateAddress(address, addressID);
      state = const ApiState.loaded(data: 'Successs');
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}
