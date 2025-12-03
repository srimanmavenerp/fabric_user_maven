import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/duration_constants.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/constants/theme.dart';
import 'package:laundrymart/features/core/home_screen.dart';
import 'package:laundrymart/features/core/model/all_stores_model/store.dart';
import 'package:laundrymart/features/services/logic/service_providers.dart';
import 'package:laundrymart/features/services/model/hive_cart_item_model.dart';
import 'package:laundrymart/features/store/logic/store_providers.dart';
import 'package:laundrymart/features/store/widgets/google_map_view.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher_string.dart';

class StoreDetailsScreen extends ConsumerStatefulWidget {
  const StoreDetailsScreen({
    super.key,
    required this.storeindex,
    required this.store,
  });
  final int storeindex;
  final Store store;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends ConsumerState<StoreDetailsScreen> {
  int selectedIndex = 0;
  bool isLoading = false;
  LatLng? currentLocation;
  bool isTextExpanded = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      selectedIndex = widget.storeindex;
    });
  }

  List<String> serviceImages = [
    "assets/images/png/iron_icon.png",
    "assets/images/png/shoe_icon.png",
    "assets/images/png/iron_icon.png",
    "assets/images/png/shoe_icon.png",
    "assets/images/png/iron_icon.png",
  ];
  List<String> services = [
    "Iron Service",
    "Shoe Service",
    "Iron Service",
    "Shoe Service",
    "Shoe Service",
  ];

  @override
  Widget build(BuildContext context) {
    ref.watch(serviceProvider(widget.store.id.toString()));
    List<String> index = [
      S.of(context).srvc,
      S.of(context).abt,
      S.of(context).rvw,
    ];
    return ScreenWrapper(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: Hive.box(AppHSC.cartBox).listenable(),
            builder: (BuildContext context, Box cartBox, Widget? child) {
              final List<CarItemHiveModel> cartItems = [];
              for (var i = 0; i < cartBox.length; i++) {
                final Map<String, dynamic> processedData = {};
                final Map<dynamic, dynamic> unprocessedData =
                    cartBox.getAt(i) as Map<dynamic, dynamic>;

                unprocessedData.forEach((key, value) {
                  processedData[key.toString()] = value;
                });

                cartItems.add(CarItemHiveModel.fromMap(processedData));
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 114.h,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppSpacerH(34.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              context.nav.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: colors(context).bodyTextColor,
                            ),
                          ),
                          if (selectedIndex == 0)
                            Container(
                              width: 260.w,
                              height: 44.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.offWhite,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      style: AppTextStyle(context).bodyTextSmal,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Search",
                                        hintStyle: AppTextStyle(context)
                                            .bodyTextSmal
                                            .copyWith(color: AppColor.gray),
                                        contentPadding: EdgeInsets.only(
                                          left:
                                              Hive.box(AppHSC.appSettingsBox)
                                                      .get(AppHSC.appLocal)
                                                      .toString() ==
                                                  "ar"
                                              ? 0.w
                                              : 15.w,
                                          right:
                                              Hive.box(AppHSC.appSettingsBox)
                                                      .get(AppHSC.appLocal)
                                                      .toString() ==
                                                  "ar"
                                              ? 15.w
                                              : 0.w,
                                          bottom: 8.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right:
                                          Hive.box(AppHSC.appSettingsBox)
                                                  .get(AppHSC.appLocal)
                                                  .toString() ==
                                              "ar"
                                          ? 0.w
                                          : 15.w,
                                      left:
                                          Hive.box(AppHSC.appSettingsBox)
                                                  .get(AppHSC.appLocal)
                                                  .toString() ==
                                              "ar"
                                          ? 15.w
                                          : 0.w,
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/svgs/search_icon.svg",
                                      fit: BoxFit.cover,
                                      color: AppColor.gray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.nav.pushNamed(Routes.myCartScreen);
                                },
                                child: const HomeTopContainer(
                                  icon: "assets/svgs/cart_icon.svg",
                                ),
                              ),
                              if (cartItems.isNotEmpty)
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    width: 16.h,
                                    height: 12.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: AppColor.red,
                                    ),
                                    child: Center(
                                      child: Text(
                                        cartItems.length < 10
                                            ? cartItems.length.toString()
                                            : "9+",
                                        style: AppTextStyle(context)
                                            .bodyTextExtraSmall
                                            .copyWith(
                                              fontSize: 10.sp,
                                              color: AppColor.offWhite,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 104.h,
                color:
                    Theme.of(context).scaffoldBackgroundColor == AppColor.black
                    ? AppColor.black
                    : AppColor.white,
                // color: AppColors.black.withOpacity(0.5),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(
                      0.5,
                    ), // Adjust the opacity value as needed
                    BlendMode.srcOver,
                  ),
                  child: Image.network(
                    widget.store.bannerId!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.h,
                    vertical: 16.h,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.store.logo!,
                          fit: BoxFit.fill,
                          width: 72.w,
                          height: 72.h,
                        ),
                      ),
                      AppSpacerW(8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.store.name ?? "",
                                  style: AppTextStyle(context).bodyTextH1,
                                ),
                                Container(
                                  width: 42.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    color: widget.store.owner!.isActive == 1
                                        ? AppColor.green
                                        : AppColor.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.store.owner!.isActive == 1
                                          ? "Open"
                                          : "Closed",
                                      style: AppTextStyle(context)
                                          .bodyTextExtraSmall
                                          .copyWith(
                                            color: AppColor.white,
                                            fontSize: 10.sp,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AppSpacerH(6.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_sharp,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                                AppSpacerW(4.w),
                                Text(
                                  widget.store.address?.addressName ?? "",
                                  style: AppTextStyle(
                                    context,
                                  ).bodyTextExtraSmall,
                                ),
                              ],
                            ),
                            AppSpacerH(6.h),
                            Row(
                              children: [
                                Text(
                                  widget.store.distance ?? "",
                                  style: AppTextStyle(
                                    context,
                                  ).bodyTextExtraSmall,
                                ),
                                SizedBox(
                                  height: 14.h,
                                  child: VerticalDivider(
                                    color: colors(context).bodyTextColor,
                                    thickness: 1,
                                  ),
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svgs/rating_icon.svg",
                                    ),
                                    AppSpacerW(5.45.w),
                                    Text(
                                      widget.store.rating ?? "",
                                      style: AppTextStyle(
                                        context,
                                      ).bodyTextExtraSmall,
                                    ),
                                    AppSpacerW(5.45.w),
                                    Text(
                                      "(${widget.store.totalRating})",
                                      style: AppTextStyle(
                                        context,
                                      ).bodyTextExtraSmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          AppSpacerH(8.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.h),
            child: Row(
              children: index
                  .asMap()
                  .entries
                  .map(
                    (e) => Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = e.key;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.h),
                          child: Container(
                            width: 104.w,
                            height: 36.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: selectedIndex == e.key
                                  ? Theme.of(context).primaryColor
                                  : AppColor.offWhite,
                              boxShadow: [
                                if (selectedIndex == e.key)
                                  BoxShadow(
                                    color: AppColor.black.withOpacity(0.08),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                e.value,
                                style: selectedIndex == e.key
                                    ? AppTextStyle(context).bodyTextSmal
                                          .copyWith(color: AppColor.white)
                                    : AppTextStyle(context).bodyTextSmal
                                          .copyWith(color: AppColor.gray),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          AppSpacerH(8.h),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).scaffoldBackgroundColor == AppColor.black
                  ? AppColor.black
                  : AppColor.white,
              child: IndexedStack(
                index: selectedIndex,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        AppSpacerH(12.h),
                        ref
                            .watch(serviceProvider(widget.store.id.toString()))
                            .map(
                              initial: (_) {
                                return const LoadingWidget();
                              },
                              loading: (_) {
                                return const LoadingWidget();
                              },
                              loaded: (d) {
                                return GridView.count(
                                  controller: ScrollController(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  padding: EdgeInsets.zero,
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.78.sp,
                                  mainAxisSpacing: 12.sp,
                                  crossAxisSpacing: 12.sp,
                                  children: List.generate(
                                    d.data.data!.services!.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          ref.invalidate(variantfilterProvider);
                                          ref.invalidate(productfilterProvider);
                                          context.nav.pushNamed(
                                            Routes.servicedetailsScreen,
                                            arguments: {
                                              "service":
                                                  d.data.data!.services![index],
                                              "storeid": widget.store.id,
                                              "storeName": widget.store.name,
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 104.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: AppColor.offWhite,
                                              width: 1,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.h,
                                              vertical: 8.h,
                                            ),
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: 45,
                                                  backgroundColor: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                  backgroundImage: NetworkImage(
                                                    d
                                                        .data
                                                        .data!
                                                        .services![index]
                                                        .imagePath
                                                        .toString(),
                                                  ),
                                                ),
                                                AppSpacerH(8.w),
                                                Text(
                                                  d
                                                      .data
                                                      .data!
                                                      .services![index]
                                                      .name
                                                      .toString(),
                                                  style: AppTextStyle(
                                                    context,
                                                  ).bodyTextExtraSmall,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                );
                              },
                              error: (d) => ErrorTextWidget(error: d.error),
                            ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 16.h,
                    ),
                    child: SingleChildScrollView(
                      physics: !isTextExpanded
                          ? const NeverScrollableScrollPhysics()
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSpacerH(12.h),
                          Text(
                            S.of(context).abtus,
                            style: AppTextStyle(context).bodyTextSmal.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          AppSpacerH(12.h),
                          SingleChildScrollView(
                            child: ReadMoreText(
                              widget.store.description!,
                              trimLines: 5,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              callback: (bool value) {
                                setState(() {
                                  isTextExpanded = !value;
                                });
                              },
                              moreStyle: AppTextStyle(context).bodyText
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                              lessStyle: AppTextStyle(context).bodyText
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                              style: AppTextStyle(
                                context,
                              ).bodyTextSmal.copyWith(color: AppColor.gray),
                            ),
                          ),
                          AppSpacerH(40.h),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Map Location",
                                  style: AppTextStyle(context).bodyTextSmal
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_sharp,
                                      color: Theme.of(context).primaryColor,
                                      size: 20,
                                    ),
                                    AppSpacerW(4.w),
                                    SizedBox(
                                      width: 186.w,
                                      child: Text(
                                        "Nurjahan Road, Mohammadpur, Dhaka-1207",
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: launchDirections,
                                  child: Container(
                                    width: 118.w,
                                    height: 32.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svgs/arrow_icon.svg",
                                        ),
                                        AppSpacerW(4.w),
                                        Text(
                                          S.of(context).getdirection,
                                          style: AppTextStyle(context)
                                              .bodyTextExtraSmall
                                              .copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppSpacerH(12.h),
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 350.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: FutureBuilder(
                                      future: Future.delayed(
                                        AppDurConst.halfSecDuration,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          SchedulerBinding.instance
                                              .addPostFrameCallback((_) {
                                                // Use setState to rebuild the widget with the GoogleMap
                                                setState(() {});
                                              });
                                        }
                                        return GoogleMapView(
                                          latitude:
                                              double.tryParse(
                                                widget.store.latitude ?? '0.0',
                                              ) ??
                                              0,
                                          longitude:
                                              double.tryParse(
                                                widget.store.longitude ?? '0.0',
                                              ) ??
                                              0,
                                          shopName: widget.store.name ?? '',
                                        );
                                      },
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  ref
                      .watch(allRatingsProvider(widget.store.id.toString()))
                      .map(
                        initial: (_) {
                          return const LoadingWidget();
                        },
                        loading: (_) {
                          return const LoadingWidget();
                        },
                        loaded: (d) {
                          return Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppSpacerH(32.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 17.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              d.data.data!.average!,
                                              style: AppTextStyle(context)
                                                  .bodyTextH1
                                                  .copyWith(fontSize: 26),
                                            ),
                                            RatingBarIndicator(
                                              unratedColor: AppColor.gray,
                                              rating: double.parse(
                                                d.data.data!.average!,
                                              ),
                                              itemBuilder: (context, index) =>
                                                  SizedBox(
                                                    width: 13.21.w,
                                                    height: 12.65.h,
                                                    child: SvgPicture.asset(
                                                      "assets/svgs/star_icon.svg",
                                                    ),
                                                  ),
                                              itemCount: 5,
                                              itemSize: 20.0,
                                              direction: Axis.horizontal,
                                              itemPadding: EdgeInsets.only(
                                                left: 5.h,
                                              ),
                                            ),
                                            AppSpacerH(4.h),
                                            Text(
                                              "(${d.data.data!.ratings!.length})",
                                              style: AppTextStyle(
                                                context,
                                              ).bodyTextSmal,
                                            ),
                                          ],
                                        ),
                                        AppSpacerW(12.w),
                                        SizedBox(
                                          width: 220.w,
                                          child: Column(
                                            children: [
                                              RatingBarRow(
                                                num: '5',
                                                percentage:
                                                    "${d.data.data!.star5!}%",
                                                val:
                                                    double.parse(
                                                      d.data.data!.star5!,
                                                    ) /
                                                    100,
                                              ),
                                              RatingBarRow(
                                                num: '4',
                                                percentage:
                                                    "${d.data.data!.star4!}%",
                                                val:
                                                    double.parse(
                                                      d.data.data!.star4!,
                                                    ) /
                                                    100,
                                              ),
                                              RatingBarRow(
                                                num: '3',
                                                percentage:
                                                    "${d.data.data!.star3!}%",
                                                val:
                                                    double.parse(
                                                      d.data.data!.star3!,
                                                    ) /
                                                    100,
                                              ),
                                              RatingBarRow(
                                                num: '2',
                                                percentage:
                                                    "${d.data.data!.star2!}%",
                                                val:
                                                    double.parse(
                                                      d.data.data!.star2!,
                                                    ) /
                                                    100,
                                              ),
                                              RatingBarRow(
                                                num: '1',
                                                percentage:
                                                    "${d.data.data!.star1!}%",
                                                val:
                                                    double.parse(
                                                      d.data.data!.star1!,
                                                    ) /
                                                    100,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              AppSpacerH(21.h),
                              const Divider(
                                color: AppColor.offWhite,
                                thickness: 1,
                              ),
                              Expanded(
                                child: SizedBox(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: d.data.data!.ratings!.length,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.h,
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 8.h),
                                          width: MediaQuery.of(
                                            context,
                                          ).size.width,
                                          decoration: BoxDecoration(
                                            color: AppColor.offWhite,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: AppColor.offWhite,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.h,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppSpacerH(12.h),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          child: Image.network(
                                                            d
                                                                .data
                                                                .data!
                                                                .ratings![index]
                                                                .img!,
                                                            width: 40.w,
                                                            height: 40.w,
                                                          ),
                                                        ),
                                                        AppSpacerW(10.w),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              d
                                                                  .data
                                                                  .data!
                                                                  .ratings![index]
                                                                  .name!,
                                                              style: AppTextStyle(context)
                                                                  .bodyTextSmal
                                                                  .copyWith(
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: AppColor
                                                                        .black,
                                                                  ),
                                                            ),
                                                            AppSpacerH(4.h),
                                                            Text(
                                                              d
                                                                  .data
                                                                  .data!
                                                                  .ratings![index]
                                                                  .date!,
                                                              style: AppTextStyle(context)
                                                                  .bodyTextExtraSmall
                                                                  .copyWith(
                                                                    color:
                                                                        AppColor
                                                                            .gray,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    RatingBarIndicator(
                                                      rating: double.parse(
                                                        d
                                                            .data
                                                            .data!
                                                            .ratings![index]
                                                            .rating
                                                            .toString(),
                                                      ),
                                                      itemBuilder:
                                                          (
                                                            context,
                                                            index,
                                                          ) => SizedBox(
                                                            width: 13.21.w,
                                                            height: 12.65.h,
                                                            child: SvgPicture.asset(
                                                              "assets/svgs/star_icon.svg",
                                                            ),
                                                          ),
                                                      itemCount: 5,
                                                      itemSize: 20.0,
                                                      direction:
                                                          Axis.horizontal,
                                                      unratedColor: AppColor
                                                          .gray
                                                          .withOpacity(0.5),
                                                    ),
                                                  ],
                                                ),
                                                AppSpacerH(9.h),
                                                SizedBox(
                                                  width: 302.w,
                                                  child: Text(
                                                    d
                                                        .data
                                                        .data!
                                                        .ratings![index]
                                                        .content!,
                                                    style: AppTextStyle(context)
                                                        .bodyTextExtraSmall
                                                        .copyWith(
                                                          color: AppColor.black,
                                                        ),
                                                  ),
                                                ),
                                                AppSpacerH(12.h),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        error: (e) => ErrorTextWidget(error: e.error),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void launchDirections() async {
    final String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=${widget.store.latitude},${widget.store.longitude}';
    final String appleMapUrl =
        'https://maps.apple.com/?daddr=${widget.store.latitude},${widget.store.longitude}';
    if (Platform.isIOS) {
      UrlLauncher.launchUrl(
        Uri.parse(appleMapUrl),
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } else if (Platform.isAndroid) {
      UrlLauncher.launchUrl(
        Uri.parse(googleMapsUrl),
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } else {
      throw 'Unsupported platform';
    }
  }
}

class RatingBarRow extends StatelessWidget {
  const RatingBarRow({
    super.key,
    required this.num,
    required this.val,
    required this.percentage,
  });
  final String num;
  final double val;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(num, style: AppTextStyle(context).bodyTextSmal),
        LinearPercentIndicator(
          width: 156.w,
          animation: true,
          lineHeight: 6.h,
          animationDuration: 400,
          percent: val,
          barRadius: const Radius.circular(12),
          progressColor: Colors.orangeAccent,
          backgroundColor: AppColor.offWhite,
        ),
        Text(
          percentage,
          style: AppTextStyle(
            context,
          ).bodyTextExtraSmall.copyWith(color: AppColor.gray),
        ),
      ],
    );
  }
}
