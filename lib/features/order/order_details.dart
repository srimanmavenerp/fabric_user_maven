import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/address/model/address_list_model/address.dart'
    as address;
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/constants/theme.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/order/my_order_sceen.dart';
import 'package:laundrymart/features/payment/logic/order_providers.dart';
import 'package:laundrymart/features/payment/model/all_order_model/order.dart';
import 'package:laundrymart/features/payment/shipping_payment.dart';
import 'package:laundrymart/features/widgets/icon_button.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../payment/model/order_details_model/product.dart';

class OrderDetails extends ConsumerStatefulWidget {
  const OrderDetails({super.key, required this.order});
  final Order order;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends ConsumerState<OrderDetails> {
  final Box settingsBox = Hive.box(AppHSC.appSettingsBox);
  final ExpandableController controller = ExpandableController();
  final TextEditingController feedbackController = TextEditingController();
  bool isexpanded = true;
  double ratings = 3;
  bool downloading = false;
  bool isDownloaded = false;
  String progress = '0';
  bool isFileExists = false;
  String orderStatus = '';
  @override
  void initState() {
    super.initState();
    checkIfFileExists();
  }

  Future<void> checkIfFileExists() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    int androidSdkVersion = androidInfo.version.sdkInt;
    PermissionStatus status;
    if (Platform.isAndroid && androidSdkVersion > 29) {
      status = await Permission.manageExternalStorage.request();
    } else {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      var directory = "/storage/emulated/0/Laundry";
      var dirDownloadExists = await Directory(directory).exists();
      if (!dirDownloadExists) {
        await Directory(directory).create(recursive: true);
      } else {
        final file = File('$directory/${widget.order.orderCode}.pdf');
        if (await file.exists()) {
          setState(() {
            isFileExists = true;
          });
        }
      }
    } else {
      setState(() {
        isFileExists = false;
      });
      debugPrint('Permission Denied');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    isDownloaded = false;
    downloading = false;
    isFileExists = false;
    progress = '0';
    super.dispose();
  }

  Future<void> downloadFile(String url, String savePath) async {
    debugPrint(savePath);
    setState(() {
      downloading = true;
    });
    try {
      final response = await Dio()
          .download(
            url,
            savePath,
            onReceiveProgress: (count, total) {
              setState(() {
                progress = ((count / total) * 100).toStringAsFixed(0);
              });

              if (progress == '100') {
                setState(() {
                  isDownloaded = true;
                });
              } else if (double.parse(progress) < 100) {}
            },
            deleteOnError: true,
          )
          .then((_) async {
            setState(() {
              if (progress == '100') {
                isDownloaded = true;
              }

              downloading = false;
            });
            await checkIfFileExists();
          });
      debugPrint(response.statusCode);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currency = ref
        .read(appSettingDataProvider.notifier)
        .state
        .currency;
    return Stack(
      children: [
        ScreenWrapper(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 104.h,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).scaffoldBackgroundColor ==
                          AppColor.black
                      ? AppColor.black
                      : AppColor.white,
                  border: const Border(
                    bottom: BorderSide(color: AppColor.offWhite, width: 1),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Column(
                    children: [
                      AppSpacerH(50.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.nav.pop(context);
                            },
                            child:
                                Hive.box(
                                      AppHSC.appSettingsBox,
                                    ).get(AppHSC.appLocal).toString() ==
                                    "ar"
                                ? RotatedBox(
                                    quarterTurns: 2,
                                    child: SvgPicture.asset(
                                      "assets/svgs/back_arrow_icon.svg",
                                      color: colors(context).bodyTextColor,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    "assets/svgs/back_arrow_icon.svg",
                                    color: colors(context).bodyTextColor,
                                  ),
                          ),
                          SizedBox(
                            child: Text(
                              S.of(context).ordrdtls,
                              style: AppTextStyle(context).bodyTextH1,
                            ),
                          ),
                          StatusContainer(
                            color: getOrderStatusColor(orderStatus),
                            status: orderStatus,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ref
                  .watch(orderDetailsProvider(widget.order.id.toString()))
                  .map(
                    initial: (value) => const LoadingWidget(),
                    loading: (value) => const LoadingWidget(),
                    error: (e) => ErrorTextWidget(error: e.error),
                    loaded: (data) {
                      final orderDetails = data.data.data!.order;
                      address.Address customerAddress = address.Address.fromMap(
                        orderDetails!.address!.toMap(),
                      );
                      Future.delayed(const Duration(milliseconds: 200), () {
                        setState(() {
                          orderStatus = orderDetails.orderStatus ?? '';
                        });
                      });
                      return Expanded(
                        child: SizedBox(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              AppSpacerH(8.h),
                              ExpandablePanel(
                                controller: controller,
                                theme: const ExpandableThemeData(
                                  tapHeaderToExpand: true,
                                  hasIcon: false,
                                ),
                                header: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isexpanded = !isexpanded;
                                      controller.expanded =
                                          !controller.expanded;
                                    });
                                  },
                                  child: ExpandblePanelHeader(
                                    isexapnded: isexpanded,
                                  ),
                                ),
                                collapsed: const SizedBox(),
                                expanded: SizedBox(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: orderDetails.products!.length,
                                    itemBuilder: (context, index) {
                                      return ExpandblePanelcollapsed(
                                        product: orderDetails.products![index],
                                        qty: orderDetails
                                            .quantity!
                                            .quantity[index]
                                            .quantity,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              AppSpacerH(8.h),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: AppColor.white,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.h,
                                  ),
                                  child: Column(
                                    children: [
                                      AppSpacerH(18.h),
                                      SummaryContainer(
                                        type: S.of(context).ordrid,
                                        amount: "#${orderDetails.orderCode}",
                                        style2: AppTextStyle(context)
                                            .bodyTextSmal
                                            .copyWith(color: AppColor.gray),
                                      ),
                                      AppSpacerH(16.h),
                                      SummaryContainer(
                                        type: S.of(context).pickupat,
                                        amount: orderDetails.pickDate
                                            .toString(),
                                        style2: AppTextStyle(context)
                                            .bodyTextSmal
                                            .copyWith(color: AppColor.gray),
                                      ),
                                      AppSpacerH(16.h),
                                      SummaryContainer(
                                        type: S.of(context).dlvryat,
                                        amount: orderDetails.deliveryDate
                                            .toString(),
                                        style2: AppTextStyle(context)
                                            .bodyTextSmal
                                            .copyWith(color: AppColor.gray),
                                      ),
                                      AppSpacerH(16.h),
                                      SummaryContainer(
                                        type: S.of(context).pymntmthd,
                                        amount: orderDetails.paymentType
                                            .toString(),
                                        style2: AppTextStyle(context)
                                            .bodyTextSmal
                                            .copyWith(color: AppColor.gray),
                                      ),
                                      AppSpacerH(16.h),
                                      SummaryContainer(
                                        type: S.of(context).ttlpybl,
                                        amount:
                                            "$currency${orderDetails.payableAmount}",
                                        style2: AppTextStyle(context)
                                            .bodyTextSmal
                                            .copyWith(color: AppColor.gray),
                                      ),
                                      AppSpacerH(16.h),
                                      SummaryContainer(
                                        type: S.of(context).dscnt,
                                        amount:
                                            "$currency${orderDetails.discount}",
                                        style2: AppTextStyle(context)
                                            .bodyTextSmal
                                            .copyWith(color: AppColor.gray),
                                      ),
                                      AppSpacerH(8.h),
                                      widget.order.invoicePath != null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/svgs/down_icon.svg",
                                                ),
                                                AppSpacerW(8.w),
                                                isFileExists
                                                    ? TextButton(
                                                        onPressed: () async {
                                                          try {
                                                            var directory =
                                                                "/storage/emulated/0/Laundry";
                                                            String fullPath =
                                                                "$directory/${orderDetails.orderCode}.pdf";
                                                            await OpenFile.open(
                                                              fullPath,
                                                            );
                                                          } catch (e) {
                                                            debugPrint(
                                                              "here $e",
                                                            );
                                                          }
                                                        },
                                                        child: Text(
                                                          "Open File",
                                                          style: TextStyle(
                                                            fontSize: 13.sp,
                                                          ),
                                                        ),
                                                      )
                                                    : downloading
                                                    ? Center(
                                                        child: Text(
                                                          "$progress%",
                                                        ),
                                                      )
                                                    : isDownloaded &&
                                                          isFileExists
                                                    ? TextButton(
                                                        onPressed: () async {
                                                          try {
                                                            var directory =
                                                                "/storage/emulated/0/Laundry";
                                                            String fullPath =
                                                                "$directory/${orderDetails.orderCode}.pdf";
                                                            await OpenFile.open(
                                                              fullPath,
                                                            );
                                                          } catch (e) {
                                                            debugPrint(
                                                              "here $e",
                                                            );
                                                          }
                                                        },
                                                        child: const Text(
                                                          "Open File",
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () async {
                                                          if (await Permission
                                                              .storage
                                                              .request()
                                                              .isGranted) {
                                                            final extension =
                                                                path.extension(
                                                                  widget
                                                                      .order
                                                                      .invoicePath!,
                                                                );

                                                            var directory =
                                                                "/storage/emulated/0/Laundry";

                                                            bool
                                                            dirDownloadExists =
                                                                await Directory(
                                                                  directory,
                                                                ).exists();

                                                            if (!dirDownloadExists) {
                                                              await Directory(
                                                                directory,
                                                              ).create(
                                                                recursive: true,
                                                              );
                                                            }
                                                            String fullPath =
                                                                "$directory/${orderDetails.orderCode}$extension";

                                                            downloadFile(
                                                                  widget
                                                                      .order
                                                                      .invoicePath!,
                                                                  fullPath,
                                                                )
                                                                .then(
                                                                  (value) {},
                                                                )
                                                                .catchError(
                                                                  (error) {},
                                                                );
                                                          } else {
                                                            EasyLoading.showError(
                                                              'Permission denied',
                                                            );
                                                          }
                                                        },
                                                        child: Text(
                                                          S
                                                              .of(context)
                                                              .dwnldinvoice,
                                                          style:
                                                              AppTextStyle(
                                                                    context,
                                                                  )
                                                                  .bodyTextExtraSmall
                                                                  .copyWith(
                                                                    color:
                                                                        AppColor
                                                                            .blue,
                                                                  ),
                                                        ),
                                                      ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/svgs/down_icon.svg",
                                                  color: AppColor.gray,
                                                ),
                                                AppSpacerW(8.w),
                                                InkWell(
                                                  onTap: () async {
                                                    debugPrint(
                                                      "No invoice found",
                                                    );
                                                  },
                                                  child: Text(
                                                    S.of(context).dwnldinvoice,
                                                    style: AppTextStyle(context)
                                                        .bodyTextExtraSmall
                                                        .copyWith(
                                                          color: AppColor.gray,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      AppSpacerH(12.h),
                                    ],
                                  ),
                                ),
                              ),
                              AppSpacerH(8.h),
                              AddressContainer(
                                change: false,
                                address: customerAddress,
                              ),
                              AppSpacerH(8.h),
                              if (widget.order.shop != null)
                                ContactContainer(
                                  logo: widget.order.shop!.logo,
                                  color: Theme.of(context).primaryColor,
                                  type: S.of(context).cllthestore,
                                  num: widget.order.shop!.owner.mobile,
                                  padding: 0.w,
                                ),
                              AppSpacerH(8.h),
                              if (orderDetails.rider != null)
                                ContactContainer(
                                  logo: orderDetails.rider!.profilePhoto,
                                  color: Colors.purple,
                                  type: S.of(context).clltherider,
                                  num: orderDetails.rider!.phone,
                                  padding: 8.h,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        ),
        if (orderStatus == 'Pending')
          Positioned(
            bottom: 2,
            left: 0,
            right: 0,
            child: _buildRoundedButton(
              title: 'Cancel Order',
              titleColor: AppColor.red,
              onTap: () {
                _orderCancelDialog(context);
              },
              buttonColor: AppColor.white,
            ),
          ),
        if (orderStatus == "Delivered")
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildRoundedButton(
              onTap: () {
                _buildFeedbackDialog(context);
              },
              title: 'Feedback',
              titleColor: AppColor.white,
              buttonColor: AppColor.blue,
            ),
          ),
      ],
    );
  }

  Future<dynamic> _buildFeedbackDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Center(
            child: Container(
              height: 560.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColor.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Column(
                  children: [
                    AppSpacerH(32.h),
                    SvgPicture.asset("assets/svgs/feedback_icon.svg"),
                    AppSpacerH(16.h),
                    Text(
                      S.of(context).howwasironsrvc,
                      textAlign: TextAlign.center,
                      style: AppTextStyle(context).bodyTextH1.copyWith(
                        fontSize: 20.sp,
                        color: AppColor.black,
                      ),
                    ),
                    AppSpacerH(12.h),
                    Text(
                      S.of(context).urfdbckwillhlp,
                      textAlign: TextAlign.center,
                      style: AppTextStyle(
                        context,
                      ).bodyTextSmal.copyWith(color: AppColor.gray),
                    ),
                    AppSpacerH(12.h),
                    RatingBar.builder(
                      initialRating: 3,
                      itemSize: 20.0,
                      itemCount: 5,
                      allowHalfRating: true,
                      itemBuilder: (context, _) => SizedBox(
                        width: 13.21.w,
                        height: 12.65.h,
                        child: SvgPicture.asset("assets/svgs/star_icon.svg"),
                      ),
                      itemPadding: EdgeInsets.only(left: 5.h),
                      onRatingUpdate: (rating) {
                        ratings = rating;
                      },
                      direction: Axis.horizontal,
                    ),
                    AppSpacerH(14.h),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 96.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.gray, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          controller: feedbackController,
                          name: "feedback",
                          decoration: InputDecoration.collapsed(
                            hintText: S.of(context).writeurcmnt,
                            hintStyle: AppTextStyle(
                              context,
                            ).bodyTextExtraSmall.copyWith(color: AppColor.gray),
                          ),
                        ),
                      ),
                    ),
                    AppSpacerH(24.h),
                    ref.watch(orderReviewProvider)
                        ? const CircularProgressIndicator()
                        : AppIconButton(
                            onTap: () {
                              context.nav.pop(context);
                              ref
                                  .read(orderReviewProvider.notifier)
                                  .addOrderReview(
                                    rating: ratings,
                                    comment: feedbackController.text,
                                    orderId: widget.order.id,
                                  )
                                  .then((message) {
                                    EasyLoading.showSuccess(message);
                                    return context.nav.pop(context);
                                  });
                            },
                            title: S.of(context).sbmt,
                            buttonColor: AppColor.blue,
                          ),
                    AppSpacerH(12.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoundedButton({
    required void Function()? onTap,
    required String title,
    required Color titleColor,
    required Color buttonColor,
  }) {
    return Container(
      color: AppColor.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Material(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(30.r),
            onTap: onTap,
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: AppColor.offWhite, width: 3),
              ),
              child: Center(
                child: Text(
                  title,
                  style: AppTextStyle(context).bodyText.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _orderCancelDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Center(
            child: Container(
              height: 289.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColor.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Column(
                  children: [
                    AppSpacerH(32.h),
                    Image.asset("assets/images/png/cancel_icon.png"),
                    AppSpacerH(20.h),
                    Text(
                      S.of(context).rusureuwnttocnclthisorder,
                      textAlign: TextAlign.center,
                      style: AppTextStyle(context).bodyTextH1.copyWith(
                        fontSize: 24,
                        color: AppColor.black,
                      ),
                    ),
                    AppSpacerH(32.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Row(
                        children: [
                          AppIconButton(
                            width: 140.w,
                            onTap: () {
                              context.nav.pop(context);
                            },
                            title: S.of(context).cncl,
                            titleColor: AppColor.black,
                            buttonColor: AppColor.offWhite,
                          ),
                          AppSpacerW(16.w),
                          ref.watch(cancelOrderProvider)
                              ? const CircularProgressIndicator()
                              : AppIconButton(
                                  width: 140.w,
                                  onTap: () {
                                    ref
                                        .watch(cancelOrderProvider.notifier)
                                        .cancelOrder(widget.order.id)
                                        .then((message) {
                                          EasyLoading.showSuccess(message);
                                          ref.refresh(
                                            orderDetailsProvider(
                                              widget.order.id.toString(),
                                            ),
                                          );
                                          ref.refresh(allOrdersProvider);
                                          return context.nav.pop(context);
                                        });
                                  },
                                  title: S.of(context).cnfirm,
                                  buttonColor: AppColor.red,
                                ),
                        ],
                      ),
                    ),
                    AppSpacerH(12.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color getOrderStatusColor(String orderStatus) {
    if (orderStatus.toLowerCase() == 'pending') {
      return AppColor.gray;
    } else if (orderStatus.replaceAll(' ', '').toLowerCase() ==
        'processing'.toLowerCase()) {
      return AppColor.blue;
    } else if (orderStatus.replaceAll(' ', '').toLowerCase() ==
        'cancelled'.toLowerCase()) {
      return AppColor.red;
    } else {
      return AppColor.black;
    }
  }
}

class ContactContainer extends StatelessWidget {
  const ContactContainer({
    super.key,
    required this.logo,
    required this.type,
    required this.color,
    required this.num,
    required this.padding,
  });
  final String logo;
  final String type;
  final String num;
  final Color color;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColor.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.gray, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: CachedNetworkImage(imageUrl: logo, width: 40.w),
                  ),
                ),
                AppSpacerW(8.w),
                InkWell(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: num));
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: AppTextStyle(
                          context,
                        ).bodyTextSmal.copyWith(color: AppColor.gray),
                      ),
                      AppSpacerH(8.h),
                      Text(
                        num,
                        style: AppTextStyle(context).bodyText.copyWith(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                launchCaller(num);
              },
              child: Container(
                width: 34.w,
                height: 34.h,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                child: Center(
                  child: SvgPicture.asset("assets/svgs/call_icon.svg"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  launchCaller(String num) async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: num);
    await launchUrl(phoneLaunchUri);
  }
}

class ExpandblePanelHeader extends StatelessWidget {
  const ExpandblePanelHeader({super.key, required this.isexapnded});

  final bool isexapnded;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColor.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).itms,
              style: AppTextStyle(context).bodyTextSmal.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColor.black,
              ),
            ),
            Icon(
              isexapnded
                  ? Icons.keyboard_arrow_down_sharp
                  : Icons.keyboard_arrow_up_outlined,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandblePanelcollapsed extends ConsumerStatefulWidget {
  const ExpandblePanelcollapsed({
    super.key,
    required this.product,
    required this.qty,
  });
  final Product product;
  final int qty;

  @override
  ConsumerState<ExpandblePanelcollapsed> createState() =>
      _ExpandblePanelcollapsedState();
}

class _ExpandblePanelcollapsedState
    extends ConsumerState<ExpandblePanelcollapsed> {
  @override
  Widget build(BuildContext context) {
    final String currency = ref
        .read(appSettingDataProvider.notifier)
        .state
        .currency;
    final Box settingsBox = Hive.box(AppHSC.appSettingsBox);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(color: AppColor.offWhite, width: 1),
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 80.h,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColor.offWhite, width: 1),
            ),
            color: AppColor.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 4.w,
                      height: 58.h,
                      child: const VerticalDivider(
                        color: AppColor.black,
                        width: 4,
                      ),
                    ),
                    AppSpacerW(8.w),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.product.imagePath.toString(),
                        width: 56.w,
                        height: 56.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    AppSpacerW(8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.service!.name.toString(),
                          style: AppTextStyle(
                            context,
                          ).bodyTextExtraSmall.copyWith(color: AppColor.gray),
                        ),
                        Text(
                          widget.product.name.toString(),
                          style: AppTextStyle(context).bodyTextSmal.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColor.black,
                          ),
                        ),
                        Text(
                          '${widget.qty}x$currency${widget.product.currentPrice!}',
                          style: AppTextStyle(
                            context,
                          ).bodyTextSmal.copyWith(color: AppColor.black),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '$currency${(widget.product.currentPrice! * widget.qty).toStringAsFixed(2)}',
                  style: AppTextStyle(context).bodyTextSmal.copyWith(
                    color: AppColor.blue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
