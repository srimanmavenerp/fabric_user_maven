import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:laundrymart/features/core/home_screen.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/order/my_order_sceen.dart';
import 'package:laundrymart/features/profile/profile_screen.dart';
import 'package:laundrymart/features/store/nearby_store.dart';

class HomeTabSreen extends ConsumerStatefulWidget {
  const HomeTabSreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTabSreenState();
}

class _HomeTabSreenState extends ConsumerState<HomeTabSreen> {
  Location location = Location();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build home tab");
    return PageView(
      controller: ref.watch(homeScreenPageControllerProvider),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        HomeScreen(),
        NearbyStoreScreen(),
        MyOrderScreen(),
        ProfileScreen()
      ],
    );
  }
}
