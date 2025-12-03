import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/address/logic/addresss_providers.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/order/my_order_sceen.dart';
import 'package:laundrymart/features/payment/shipping_payment.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';

// ignore: must_be_immutable
class ManageAddressScreen extends ConsumerStatefulWidget {
  ManageAddressScreen({super.key, required this.isprofile});
  bool isprofile;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageAddressScreenState();
}

class _ManageAddressScreenState extends ConsumerState<ManageAddressScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.invalidate(addresListProvider);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).mngaddrs)),
      body: ScreenWrapper(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ValueListenableBuilder(
          valueListenable: Hive.box(AppHSC.authBox).listenable(),
          builder: (BuildContext context, Box authbox, Widget? child) {
            return Column(
              children: [
                if (authbox.get(AppHSC.authToken) != null) ...[
                  Expanded(
                    child: Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ref
                              .watch(addresListProvider)
                              .map(
                                initial: (_) {
                                  return const SizedBox();
                                },
                                loading: (_) {
                                  return const LoadingWidget();
                                },
                                loaded: (d) {
                                  if (d.data.data!.addresses!.isNotEmpty) {
                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: d.data.data!.addresses!.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.h,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 8.h),
                                            child: GestureDetector(
                                              onTap: () {
                                                widget.isprofile == true
                                                    ? context.nav.pushNamed(
                                                        Routes.addAddressScreen,
                                                        arguments: d
                                                            .data
                                                            .data!
                                                            .addresses![index],
                                                      )
                                                    : context.nav.pushNamedAndRemoveUntil(
                                                        Routes
                                                            .shippingPaymentScreen,
                                                        (route) {
                                                          return false;
                                                        },
                                                        arguments: d
                                                            .data
                                                            .data!
                                                            .addresses![index],
                                                      );
                                              },
                                              child: AddressContainer(
                                                change: widget.isprofile == true
                                                    ? true
                                                    : false,
                                                buttonTitle: S.of(context).edt,
                                                address: d
                                                    .data
                                                    .data!
                                                    .addresses![index],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: Text(
                                        "No saved addresses",
                                        style: AppTextStyle(context).bodyTextH1,
                                      ),
                                    );
                                  }
                                },
                                error: (e) => ErrorTextWidget(error: e.error),
                              ),
                        ),
                        Positioned(
                          right: 16.w,
                          bottom: 16.h,
                          child: GestureDetector(
                            onTap: () {
                              context.nav.pushNamed(Routes.addAddressScreen);
                            },
                            child: Container(
                              width: 54.w,
                              height: 54.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColor.offWhite,
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.add, color: AppColor.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const NotSignedInwidget(),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
