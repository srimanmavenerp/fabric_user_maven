import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/constants/theme.dart';
import 'package:laundrymart/features/core/logic/core_providers.dart';
import 'package:laundrymart/features/core/model/all_stores_model/store.dart';
import 'package:laundrymart/features/store/model/service_model/service.dart';
import 'package:laundrymart/features/store/nearby_store.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/entensions.dart';
import 'package:laundrymart/utils/routes.dart';

class ServiceBasedStores extends ConsumerStatefulWidget {
  const ServiceBasedStores({
    super.key,
    required this.serviceId,
    required this.service,
  });
  final int serviceId;
  final Service service;

  @override
  ConsumerState<ServiceBasedStores> createState() => _ServiceBasedStoresState();
}

class _ServiceBasedStoresState extends ConsumerState<ServiceBasedStores> {
  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          AppBar(
            leading: InkWell(
              onTap: () => context.nav.pop(),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
            ),
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor == AppColor.black
                ? AppColor.black
                : AppColor.white,
            elevation: 0.0,
            title: Text(
              S.of(context).stores,
              style: AppTextStyle(context).bodyTextH1,
            ),
            iconTheme: IconThemeData(color: colors(context).bodyTextColor),
          ),
          Expanded(
            child: ref
                .watch(serviceBasedStoresProvider(widget.serviceId))
                .map(
                  initial: (_) {
                    return const Center(child: CircularProgressIndicator());
                  },
                  loading: (_) {
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (e) {
                    Future.delayed(50.miliSec, () {
                      ref.invalidate(
                        serviceBasedStoresProvider(widget.serviceId),
                      );
                    });
                    return Text(e.error.toString());
                  },
                  loaded: (d) {
                    return d.data.data!.stores!.isEmpty ||
                            d.data.data?.stores == null
                        ? const Center(child: Text("No Store found"))
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: d.data.data!.stores!.length,
                            itemBuilder: (context, index) {
                              final Store store = d.data.data!.stores![index];
                              return NearByStoreContainer(
                                ontap: () {
                                  context.nav.pushNamed(
                                    Routes.servicedetailsScreen,
                                    arguments: {
                                      "service": widget.service,
                                      "storeid": store.id,
                                      "storeName": store.name,
                                    },
                                  );
                                },
                                loc: store.address != null
                                    ? store.address!.addressName!
                                    : "",
                                store: store,
                              );
                            },
                          );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
