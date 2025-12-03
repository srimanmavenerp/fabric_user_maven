import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/address/logic/address_notifiers.dart';
import 'package:laundrymart/features/address/logic/address_repo.dart';
import 'package:laundrymart/features/address/model/address_list_model/address_list_model.dart';
import 'package:laundrymart/services/api_state.dart';

final addresRepoProvider = Provider<IAddressRepo>((ref) {
  return AddressRepo();
});

///
///
///
final addresListProvider =
    StateNotifierProvider<AddressListNotifier, ApiState<AddressListModel>>(
        (ref) {
  return AddressListNotifier(ref.watch(addresRepoProvider));
});

///
///
///
final addAddresProvider =
    StateNotifierProvider<AddAddressNotifier, ApiState<String>>((ref) {
  return AddAddressNotifier(ref.watch(addresRepoProvider));
});

///
///
///
final updateAddresProvider =
    StateNotifierProvider<UpdateAddressNotifier, ApiState<String>>((ref) {
  return UpdateAddressNotifier(ref.watch(addresRepoProvider));
});
