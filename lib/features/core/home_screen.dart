import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/address/logic/addresss_providers.dart';
import 'package:laundrymart/features/address/model/address_list_model/address.dart'
    as addres;
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/core/logic/core_providers.dart';
import 'package:laundrymart/features/core/model/all_stores_model/store.dart';
import 'package:laundrymart/features/core/widgets/misc_providers.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/profile/logic/profile_providers.dart';
import 'package:laundrymart/features/services/model/hive_cart_item_model.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;
  bool isShowAvailable = false;
  bool isShowNearBy = false;

  Store? aguguguggu;

  addres.Address? address;

  String processAddess(addres.Address address) {
    String addres = '';

    if (address.houseNo != null) {
      addres = '$addres${address.houseNo}, ';
    }
    if (address.roadNo != null) {
      addres = '$addres${address.roadNo}, ';
    }
    if (address.block != null) {
      addres = '$addres${address.block}, ';
    }
    if (address.addressLine != null) {
      addres = '$addres${address.addressLine}, ';
    }
    if (address.addressLine2 != null) {
      addres = '$addres${address.addressLine2}, ';
    }
    if (address.area != null) {
      addres = '$addres${address.area}, ';
    }
    if (address.postCode != null) {
      addres = '$addres${address.postCode}';
    }
    return addres;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(profileInfoProvider);
    ref
        .watch(allPromotionsProvider)
        .whenOrNull(
          loaded: (d) {
            setState(() {
              selectedIndex = d.data!.promotions!.length;
            });
          },
        );
    ref
        .watch(addresListProvider)
        .maybeWhen(
          orElse: () {},
          loaded: (d) {
            for (var element in d.data!.addresses!) {
              if (element.isDefault == 1) {
                setState(() {
                  address = element;
                });
              }
            }
          },
        );
    return ScreenWrapper(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              AppSpacerH(124.h),

              Container(
                width: MediaQuery.of(context).size.width,
                color:
                    Theme.of(context).scaffoldBackgroundColor == AppColor.black
                    ? AppColor.black
                    : AppColor.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacerH(12.h),
                      Visibility(
                        visible: isShowAvailable,
                        child: Text(
                          "Popular Services",
                          style: AppTextStyle(
                            context,
                          ).bodyTextSmal.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      AppSpacerH(8.h),
                      SizedBox(
                        height: 150.h,
                        child: ref
                            .watch(allServicesProvider)
                            .map(
                              initial: (_) => const SizedBox(),
                              loading: (_) => const LoadingWidget(),
                              loaded: (d) {
                                Future.delayed(20.milisec, () {
                                  setState(() {
                                    isShowAvailable = true;
                                  });
                                });
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: d.data.data!.services!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        context.nav.pushNamed(
                                          Routes.serviceBasedStores,
                                          arguments: {
                                            "serviceId": d
                                                .data
                                                .data!
                                                .services![index]
                                                .id,
                                            "service":
                                                d.data.data!.services![index],
                                          },
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: index == 0 ? 0.h : 8.h,
                                        ),
                                        width: 104.w,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.h,
                                            vertical: 8.h,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: AppColor.white,
                                                radius: 42.r,
                                                backgroundImage: NetworkImage(
                                                  d
                                                      .data
                                                      .data!
                                                      .services![index]
                                                      .imagePath
                                                      .toString(),
                                                ),
                                              ),
                                              AppSpacerH(8.h),
                                              Flexible(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    d
                                                        .data
                                                        .data!
                                                        .services![index]
                                                        .name
                                                        .toString(),
                                                    style: AppTextStyle(
                                                      context,
                                                    ).bodyTextExtraSmall,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              error: (e) => ErrorTextWidget(error: e.error),
                            ),
                      ),
                      Visibility(
                        visible: isShowNearBy,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).nearbystore,
                              style: AppTextStyle(context).bodyTextSmal
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            GestureDetector(
                              onTap: () {
                                ref
                                    .watch(homeScreenIndexProvider.notifier)
                                    .update((state) => 1);
                              },
                              child: Text(
                                S.of(context).vewall,
                                style: AppTextStyle(context).bodyTextExtraSmall
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSpacerH(12.h),
                      ref
                          .watch(allStoresProvider)
                          .map(
                            initial: (_) {
                              return const LoadingWidget(showBG: true);
                            },

                            loading: (_) => const SizedBox(),
                            loaded: (d) {
                              Future.delayed(20.milisec, () {
                                setState(() {
                                  isShowNearBy = true;
                                });
                              });
                              return GridView.count(
                                controller: ScrollController(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.zero,
                                crossAxisCount: 2,
                                childAspectRatio: 0.76.h,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                children: List.generate(
                                  d.data.data!.stores!.length > 6
                                      ? 6
                                      : d.data.data!.stores!.length,
                                  (index) {
                                    setState(() {
                                      aguguguggu = d.data.data!.stores![index];
                                    });

                                    return Builder(
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () {
                                            context.nav.pushNamed(
                                              Routes.storedetailsScreen,
                                              arguments: {
                                                'storeindex': 0,
                                                "store":
                                                    d.data.data!.stores![index],
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: 158.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor.withOpacity(0.2),
                                                width: 1,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColor.black
                                                      .withOpacity(0.08),
                                                  offset: const Offset(0, 2),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                              color: AppColor.white,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 12.w,
                                                top: 12.h,
                                                right: 12.w,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          child: Container(
                                                            height: 150.h,
                                                            width: 145.w,
                                                            color:
                                                                AppColor.white,
                                                            child: Stack(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              children: [
                                                                Positioned.fill(
                                                                  child: Image.network(
                                                                    d
                                                                        .data
                                                                        .data!
                                                                        .stores![index]
                                                                        .logo
                                                                        .toString(),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 24.h,
                                                                  color: AppColor
                                                                      .black
                                                                      .withOpacity(
                                                                        0.7,
                                                                      ),
                                                                  child: Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          3.0.r,
                                                                        ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          d
                                                                              .data
                                                                              .data!
                                                                              .stores![index]
                                                                              .distance
                                                                              .toString(),
                                                                          style:
                                                                              AppTextStyle(
                                                                                context,
                                                                              ).bodyTextExtraSmall.copyWith(
                                                                                color: AppColor.white,
                                                                              ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              14.h,
                                                                          child: const VerticalDivider(
                                                                            color:
                                                                                AppColor.offWhite,
                                                                            thickness:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            SvgPicture.asset(
                                                                              "assets/svgs/rating_icon.svg",
                                                                            ),
                                                                            SizedBox(
                                                                              width: 4.w,
                                                                            ),
                                                                            Text(
                                                                              d.data.data!.stores![index].rating.toString(),
                                                                              style:
                                                                                  AppTextStyle(
                                                                                    context,
                                                                                  ).bodyTextExtraSmall.copyWith(
                                                                                    color: AppColor.white,
                                                                                  ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 3.h,
                                                        right: 3.h,
                                                        child: Container(
                                                          width: 32.w,
                                                          height: 16.h,
                                                          decoration: BoxDecoration(
                                                            color:
                                                                d
                                                                        .data
                                                                        .data!
                                                                        .stores![index]
                                                                        .owner!
                                                                        .isActive ==
                                                                    1
                                                                ? AppColor.green
                                                                : AppColor.red,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  4,
                                                                ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              d
                                                                          .data
                                                                          .data!
                                                                          .stores![index]
                                                                          .owner!
                                                                          .isActive ==
                                                                      1
                                                                  ? "Open"
                                                                  : "Closed",
                                                              style: AppTextStyle(context)
                                                                  .bodyTextExtraSmall
                                                                  .copyWith(
                                                                    color: AppColor
                                                                        .white,
                                                                    fontSize:
                                                                        10.sp,
                                                                  ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  AppSpacerH(8.h),
                                                  Text(
                                                    d
                                                        .data
                                                        .data!
                                                        .stores![index]
                                                        .name
                                                        .toString(),
                                                    style: AppTextStyle(context)
                                                        .bodyText
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColor.black,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  AppSpacerH(6.h),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on_sharp,
                                                        color: Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                        size: 20,
                                                      ),
                                                      AppSpacerW(4.w),
                                                      Expanded(
                                                        child: Text(
                                                          d
                                                                      .data
                                                                      .data
                                                                      ?.stores?[index]
                                                                      .address !=
                                                                  null
                                                              ? d
                                                                    .data
                                                                    .data!
                                                                    .stores![index]
                                                                    .address!
                                                                    .addressName!
                                                              : "",
                                                          style: AppTextStyle(context)
                                                              .bodyTextExtraSmall
                                                              .copyWith(
                                                                color: AppColor
                                                                    .black,
                                                              ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  AppSpacerH(6.h),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ).toList(),
                              );
                            },
                            error: (e) => ErrorTextWidget(error: e.error),
                          ),
                      AppSpacerH(20.h),
                    ],
                  ),
                ),
              ),
              AppSpacerH(120.h),
            ],
          ),
          Positioned(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 112.h,
              color: Theme.of(context).scaffoldBackgroundColor == AppColor.black
                  ? AppColor.black
                  : AppColor.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: ValueListenableBuilder(
                  valueListenable: Hive.box(AppHSC.authBox).listenable(),
                  builder: (context, Box authBox, Widget? child) {
                    return ValueListenableBuilder(
                      valueListenable: Hive.box(AppHSC.userBox).listenable(),
                      builder: (context, Box box, Widget? child) {
                        return SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppSpacerH(24.h),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Profile photo
                                    box.get('profile_photo_path') != null
                                        ? CircleAvatar(
                                            backgroundColor: AppColor.white,
                                            radius: 24.r,
                                            backgroundImage: NetworkImage(
                                              box.get('profile_photo_path')!
                                                  as String,
                                            ),
                                          )
                                        : Image.asset(
                                            Theme.of(
                                                      context,
                                                    ).scaffoldBackgroundColor ==
                                                    AppColor.black
                                                ? "assets/images/png/fabric.png"
                                                : "assets/images/png/fabric_touch logo app (1).png",
                                            height: 50.h,
                                          ),
                                    AppSpacerW(5.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            box.get('name') != null
                                                ? '${box.get('name')}'
                                                : "",
                                            style: AppTextStyle(
                                              context,
                                            ).bodyTextH1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          AppSpacerH(6.h),
                                          box.get('name') == null
                                              ? const SizedBox()
                                              : Row(
                                                  children: [
                                                    if (address != null)
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                        size: 14.sp,
                                                      ),
                                                    if (address != null)
                                                      AppSpacerW(6.45.w),
                                                    if (address != null)
                                                      Expanded(
                                                        child: Text(
                                                          processAddess(
                                                            address!,
                                                          ),
                                                          style: AppTextStyle(
                                                            context,
                                                          ).bodyTextExtraSmall,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                    AppSpacerW(10.w),
                                    // Cart Icon
                                    if (address != null)
                                      ValueListenableBuilder(
                                        valueListenable: Hive.box(
                                          AppHSC.cartBox,
                                        ).listenable(),
                                        builder: (context, cartBox, child) {
                                          final List<CarItemHiveModel>
                                          cartItems = [];
                                          for (
                                            var i = 0;
                                            i < cartBox.length;
                                            i++
                                          ) {
                                            final Map<String, dynamic>
                                            processedData = {};
                                            final Map<dynamic, dynamic>
                                            unprocessedData =
                                                cartBox.getAt(i)
                                                    as Map<dynamic, dynamic>;
                                            unprocessedData.forEach(
                                              (key, value) =>
                                                  processedData[key
                                                          .toString()] =
                                                      value,
                                            );
                                            cartItems.add(
                                              CarItemHiveModel.fromMap(
                                                processedData,
                                              ),
                                            );
                                          }
                                          return Stack(
                                            children: [
                                              GestureDetector(
                                                onTap: () =>
                                                    context.nav.pushNamed(
                                                      Routes.myCartScreen,
                                                    ),
                                                child: const HomeTopContainer(
                                                  icon:
                                                      "assets/svgs/cart_icon.svg",
                                                ),
                                              ),
                                              if (cartItems.isNotEmpty)
                                                Positioned(
                                                  right: 0,
                                                  child: Container(
                                                    width: 16.h,
                                                    height: 12.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16.r,
                                                          ),
                                                      color: AppColor.red,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        cartItems.length < 10
                                                            ? cartItems.length
                                                                  .toString()
                                                            : "9+",
                                                        style: AppTextStyle(context)
                                                            .bodyTextExtraSmall
                                                            .copyWith(
                                                              fontSize: 10.sp,
                                                              color: AppColor
                                                                  .offWhite,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          );
                                        },
                                      ),
                                    // Notification Icon
                                    const HomeTopContainer(
                                      icon: "assets/svgs/notification_icon.svg",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTopContainer extends StatelessWidget {
  const HomeTopContainer({super.key, required this.icon});
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 44.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.gray.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(21.r),
      ),
      child: Center(child: SvgPicture.asset(icon, color: AppColor.gray)),
    );
  }
}

class SplashAnimatedDot extends ConsumerWidget {
  const SplashAnimatedDot({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = ref.watch(journeyStepProvider);
    final isActive = activeIndex == index;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w),
      child: AnimatedContainer(
        height: 6.h,
        width: 6,
        duration: 100.milisec,
        curve: Curves.easeInCirc,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
            ..withOpacity(isActive ? 1 : 0.25),
          borderRadius: BorderRadius.circular(5.h),
        ),
      ),
    );
  }
}
