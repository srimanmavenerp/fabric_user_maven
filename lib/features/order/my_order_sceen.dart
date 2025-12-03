import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/core/home_screen.dart';
import 'package:laundrymart/features/order/widget/filter_dialougue.dart';
import 'package:laundrymart/features/payment/logic/order_providers.dart';
import 'package:laundrymart/features/payment/model/all_order_model/order.dart';
import 'package:laundrymart/features/payment/shipping_payment.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/features/widgets/text_button.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';

class MyOrderScreen extends ConsumerStatefulWidget {
  const MyOrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends ConsumerState<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(allOrdersProvider);

    return ValueListenableBuilder(
      valueListenable: Hive.box(AppHSC.authBox).listenable(),
      builder: (BuildContext context, Box authBox, Widget? child) {
        return ScreenWrapper(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                color:
                    Theme.of(context).scaffoldBackgroundColor == AppColor.black
                    ? AppColor.black
                    : AppColor.white,
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      AppSpacerH(44.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 30.w),
                          Expanded(
                            child: Center(
                              child: Text(
                                S.of(context).myorder,
                                style: AppTextStyle(context).bodyTextH1,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          if (authBox.get('token') != null)
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const FilterDialog(),
                                );
                              },
                              child: const HomeTopContainer(
                                icon: "assets/svgs/sort_icon.svg",
                              ),
                            ),
                        ],
                      ),
                      AppSpacerH(8.h),
                    ],
                  ),
                ),
              ),

              // Orders / Not Signed In
              Expanded(
                child: authBox.get('token') != null
                    ? ref
                          .watch(allOrdersProvider)
                          .map(
                            initial: (_) => const SizedBox(),
                            loading: (_) => const LoadingWidget(),
                            loaded: (d) {
                              if (d.data.data!.orders!.isEmpty) {
                                return Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const MessageTextWidget(
                                          msg: 'No Order Found',
                                        ),
                                        AppSpacerH(20.h),
                                        SizedBox(
                                          height: 154.h,
                                          width: 154.w,
                                          child: Image.asset(
                                            'assets/images/png/hibernation.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: d.data.data!.orders!.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index < d.data.data!.orders!.length) {
                                      final Order data =
                                          d.data.data!.orders![index];
                                      return OrderTile(order: data);
                                    } else {
                                      // Add bottom padding after last item
                                      return SizedBox(height: 140.h);
                                    }
                                  },
                                );
                              }
                            },
                            error: (e) => ErrorTextWidget(error: e.error),
                          )
                    : Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            child: const NotSignedInwidget(),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
      child: GestureDetector(
        onTap: () {
          context.nav.pushNamed(Routes.orderDetailsScreen, arguments: order);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            children: [
              AppSpacerH(21.h),
              SummaryContainer(
                type: S.of(context).ordrid,
                amount: "#${order.orderCode}",
                style2: AppTextStyle(context).bodyTextSmal.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColor.gray,
                ),
                style: AppTextStyle(context).bodyTextSmal.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
              AppSpacerH(8.h),
              SummaryContainer(
                type: S.of(context).dlvryat,
                amount: order.deliveryDate!,
                style2: AppTextStyle(
                  context,
                ).bodyTextSmal.copyWith(color: AppColor.gray),
                style: AppTextStyle(
                  context,
                ).bodyTextSmal.copyWith(color: AppColor.black),
              ),
              AppSpacerH(8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).status,
                    style: AppTextStyle(
                      context,
                    ).bodyTextSmal.copyWith(color: AppColor.gray),
                  ),
                  StatusContainer(
                    color: getOrderStatusColor(context),
                    status: order.orderStatus!,
                  ),
                ],
              ),
              AppSpacerH(14.h),
              Row(
                children: List.generate(
                  800 ~/ 10,
                  (index) => Expanded(
                    child: Container(
                      color: index % 2 == 0
                          ? Colors.transparent
                          : AppColor.gray,
                      height: 1,
                    ),
                  ),
                ),
              ),
              AppSpacerH(12.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                    size: 14,
                  ),
                  AppSpacerW(6.45.w),
                  Expanded(
                    child: Text(
                      processAddess(),
                      style: AppTextStyle(
                        context,
                      ).bodyTextExtraSmall.copyWith(color: AppColor.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              AppSpacerH(21.h),
            ],
          ),
        ),
      ),
    );
  }

  String processAddess() {
    String address = '';
    if (order.address!.flatNo != null)
      address += 'Flat: ${order.address!.flatNo}, ';
    if (order.address!.houseNo != null)
      address += 'House: ${order.address!.houseNo}, ';
    if (order.address!.roadNo != null)
      address += 'Road: ${order.address!.roadNo}, ';
    if (order.address!.block != null)
      address += 'Block: ${order.address!.block}, ';
    if (order.address!.addressLine != null)
      address += '${order.address!.addressLine}, ';
    if (order.address!.addressLine2 != null)
      address += '${order.address!.addressLine2}, ';
    if (order.address!.postCode != null)
      address += '${order.address!.postCode}';
    return address;
  }

  Color getOrderStatusColor(context) {
    final status = order.orderStatus!.toLowerCase().replaceAll(' ', '');
    if (status == 'pending') return AppColor.gray;
    if (status == 'processing') return Theme.of(context).primaryColor;
    if (status == 'cancelled') return AppColor.red;
    return AppColor.green;
  }
}

class NotSignedInwidget extends ConsumerWidget {
  const NotSignedInwidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/png/not_found.png'),
        AppSpacerH(16.h),
        Text(
          S.of(context).yourntsignedin,
          style: AppTextStyle(
            context,
          ).bodyText.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        AppSpacerH(35.h),
        AppTextButton(
          title: S.of(context).login,
          buttonColor: Theme.of(context).primaryColor,
          onTap: () => context.nav.pushNamed(Routes.loginScreen),
        ),
      ],
    );
  }
}

class StatusContainer extends StatelessWidget {
  const StatusContainer({super.key, required this.color, required this.status});
  final Color color;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color,
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 2.h),
      child: Text(
        status,
        style: AppTextStyle(
          context,
        ).bodyTextExtraSmall.copyWith(color: AppColor.white),
      ),
    );
  }
}
