import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/constants/theme.dart';
import 'package:laundrymart/features/core/home_screen.dart';
import 'package:laundrymart/features/misc/misc_global_variables.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/services/logic/service_notifiers.dart';
import 'package:laundrymart/features/services/logic/service_providers.dart';
import 'package:laundrymart/features/services/model/hive_cart_item_model.dart';
import 'package:laundrymart/features/services/model/product_list_model/product.dart';
import 'package:laundrymart/features/services/model/variant_list_model/variant.dart';
import 'package:laundrymart/features/store/model/service_model/service.dart';
import 'package:laundrymart/features/widgets/icon_button.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/features/widgets/text_button.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';

class ServiceDetailsScreen extends ConsumerStatefulWidget {
  const ServiceDetailsScreen({
    super.key,
    required this.storeid,
    required this.service,
    required this.storeName,
  });
  final int storeid;
  final Service service;
  final String storeName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends ConsumerState<ServiceDetailsScreen> {
  int selectedIndex = 0;
  int num = 0;
  List<Variant>? variant;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(variationProductsProvider);
      ref.invalidate(servicesVariationsProvider);
      ref.watch(variantfilterProvider.notifier).state =
          ProducServiceVariavtionDataModel(servieID: '', storeID: '');
      ref.watch(productfilterProvider.notifier).state =
          ServiceVariavtionDataModel(serviceID: '', variantID: '');
    });
  }

  @override
  void dispose() {
    ref.invalidate(variationProductsProvider);
    ref.invalidate(servicesVariationsProvider);
    variant = null;
    selectedIndex = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("this is the store id ${ref.watch(storeIdProvider)}");
    final ProducServiceVariavtionDataModel variantFilter = ref.watch(
      variantfilterProvider,
    );
    if (variantFilter.servieID == "") {
      Future.delayed(buildDuration).then((value) {
        ref.watch(variantfilterProvider.notifier).update((state) {
          return state.copyWith(servieID: widget.service.id.toString());
        });
      });
    }
    if (variantFilter.storeID == "") {
      Future.delayed(buildDuration).then((value) {
        ref.watch(variantfilterProvider.notifier).update((state) {
          return state.copyWith(storeID: widget.storeid.toString());
        });
      });
    }
    final ServiceVariavtionDataModel productFilter = ref.watch(
      productfilterProvider,
    );
    if (productFilter.serviceID == "") {
      Future.delayed(buildDuration).then((value) {
        ref.watch(productfilterProvider.notifier).update((state) {
          return state.copyWith(serviceID: widget.service.id.toString());
        });
      });
    }
    if (productFilter.variantID == '') {
      ref
          .watch(servicesVariationsProvider)
          .maybeWhen(
            orElse: () {},
            loaded: (d) {
              Future.delayed(buildDuration).then((value) {
                ref.watch(productfilterProvider.notifier).update((state) {
                  final List<Variant> variations = d.data!.variants!;
                  variant = d.data!.variants;
                  variations.sort((a, b) => a.id!.compareTo(b.id!));
                  return state.copyWith(
                    variantID: variations.first.id!.toString(),
                  );
                });
              });
            },
          );
    }
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () {
            // ref.watch(variantfilterProvider.notifier).state =
            //     ProducServiceVariavtionDataModel(servieID: '', storeID: '');
            // ref.watch(productfilterProvider.notifier).state =
            //     ServiceVariavtionDataModel(serviceID: '', variantID: '');
            return Future.value(true);
          },
          child: ScreenWrapper(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                AppSpacerH(38.h),
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
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Row(
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
                          // InkWell(
                          //   onTap: () {
                          //     context.nav.pop(context);
                          //   },
                          //   child: Hive.box(AppHSC.appSettingsBox)
                          //               .get(AppHSC.appLocal)
                          //               .toString() ==
                          //           "ar"
                          //       ? RotatedBox(
                          //           quarterTurns: 2,
                          //           child: SvgPicture.asset(
                          //             "assets/svgs/back_arrow_icon.svg",
                          //             fit: BoxFit.cover,
                          //             color: colors(context).bodyTextColor,
                          //           ),
                          //         )
                          //       : SvgPicture.asset(
                          //           "assets/svgs/back_arrow_icon.svg",
                          //           fit: BoxFit.cover,
                          //           color: colors(context).bodyTextColor,
                          //         ),
                          // ),
                          AppSpacerW(0.w),
                          SizedBox(
                            width: 174.w,
                            child: Text(
                              widget.storeName,
                              style: AppTextStyle(
                                context,
                              ).bodyText.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          const HomeTopContainer(
                            icon: "assets/svgs/search_icon.svg",
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
                              AppSpacerW(12.w),
                              if (cartItems.isNotEmpty)
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    width: 20.h,
                                    height: 16.h,
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
                                              color: AppColor.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                AppSpacerH(12.h),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40.h,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColor.gray, width: 1),
                    ),
                  ),
                  child: ref
                      .watch(servicesVariationsProvider)
                      .map(
                        initial: (_) {
                          return const LoadingWidget();
                        },
                        loading: (_) {
                          return const LoadingWidget();
                        },
                        loaded: (d) {
                          if (d.data.data!.variants!.isNotEmpty) {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: d.data.data!.variants!.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0 ? 16.h : 8.h,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      ref
                                          .watch(productfilterProvider.notifier)
                                          .update((state) {
                                            return state.copyWith(
                                              variantID: d
                                                  .data
                                                  .data!
                                                  .variants![index]
                                                  .id
                                                  .toString(),
                                            );
                                          });

                                      // ref.refresh(variationProductsProvider);
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                      ),
                                      // width: 73.6.w,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: selectedIndex == index
                                              ? const BorderSide(
                                                  color: AppColor.blue,
                                                  width: 1,
                                                )
                                              : const BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          d.data.data!.variants![index].name
                                              .toString()
                                              .toUpperCase(),
                                          style: selectedIndex == index
                                              ? AppTextStyle(
                                                  context,
                                                ).bodyTextExtraSmall.copyWith(
                                                  color: AppColor.blue,
                                                  fontWeight: FontWeight.w700,
                                                )
                                              : AppTextStyle(
                                                  context,
                                                ).bodyTextExtraSmall.copyWith(
                                                  color: AppColor.gray,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Text(
                                "No Variants",
                                style: AppTextStyle(context).bodyTextExtraSmall
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.red,
                                    ),
                              ),
                            );
                          }
                        },
                        error: (e) {
                          print("errorrrrr");
                          return ErrorTextWidget(error: e.error);
                        },
                      ),
                ),
                if (variant != null)
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ref
                          .watch(variationProductsProvider)
                          .map(
                            initial: (_) {
                              return const LoadingWidget();
                            },
                            loading: (_) {
                              return const LoadingWidget();
                            },
                            loaded: (d) {
                              if (d.data.data!.products!.isNotEmpty) {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  addAutomaticKeepAlives: true,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: d.data.data!.products!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.h,
                                      ),
                                      child: ServiceDetailsContainer(
                                        product: d.data.data!.products![index],
                                        storeID: widget.storeid,
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    "No Products Available",
                                    style: AppTextStyle(context)
                                        .bodyTextExtraSmall
                                        .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.red,
                                        ),
                                  ),
                                );
                              }
                            },
                            error: (e) {
                              print("error 2");
                              return ErrorTextWidget(error: e.error);
                            },
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: Hive.box(AppHSC.authBox).listenable(),
          builder: (BuildContext context, Box authBox, Widget? child) {
            return Positioned(
              bottom: 10.h,
              right: 20.w,
              child: Container(
                width: 120.w,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.blue.withOpacity(0.4),
                      offset: const Offset(0, 2),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: AppIconButton(
                  onTap: () {
                    if (authBox.get("token") != null) {
                      context.nav.pushNamed(Routes.myCartScreen);
                    } else {
                      context.nav.pushNamed(Routes.loginScreen);
                    }
                  },
                  width: 120.w,
                  title: S.of(context).cntinue,
                  buttonColor: AppColor.blue,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

double calculateTotal(List<CarItemHiveModel> cartItems) {
  double amount = 0;
  for (final element in cartItems) {
    amount += element.productsQTY * element.unitPrice;
  }

  return amount;
}

class ServiceDetailsContainer extends ConsumerStatefulWidget {
  const ServiceDetailsContainer({
    super.key,
    required this.product,
    required this.storeID,
  });
  final Product product;
  final int storeID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ServiceDetailsContainerState();
}

class _ServiceDetailsContainerState
    extends ConsumerState<ServiceDetailsContainer>
    with AutomaticKeepAliveClientMixin {
  int num = 0;

  bool inCart = false;
  bool issame = false;
  final List<CarItemHiveModel> cartItems = [];

  int? keyAt;
  int? cartStoreID;
  bool canAddToCart = true;

  @override
  Widget build(BuildContext context) {
    final String currency = ref
        .read(appSettingDataProvider.notifier)
        .state
        .currency;
    super.build(context);
    // print("DDDDD ${widget.product.toMap()}");

    final appSettingsBox = Hive.box(AppHSC.appSettingsBox);
    return ValueListenableBuilder(
      valueListenable: Hive.box(AppHSC.cartBox).listenable(),
      builder: (context, Box cartsBox, Widget? child) {
        inCart = false;
        issame = false;

        for (int i = 0; i < cartsBox.length; i++) {
          debugPrint(cartsBox.getAt(i).toString());
          final Map<String, dynamic> processedData = {};
          final Map<dynamic, dynamic> unprocessedData =
              cartsBox.getAt(i) as Map<dynamic, dynamic>;

          unprocessedData.forEach((key, value) {
            processedData[key.toString()] = value;
          });
          final data = CarItemHiveModel.fromMap(processedData);
          if (data.productsId == widget.product.id) {
            inCart = true;
            keyAt = i;
            // cartStoreID = data.storeId;
            break;
          }

          if (data.storeId != null && data.storeId != widget.storeID) {
            canAddToCart = false;
          }
          // if (widget.storeID == data.storeId && data.storeId == null) {
          //   issame = true;
          // }
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.gray.withOpacity(0.3), width: 1),
            color: AppColor.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.product.imagePath!,
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
                        SizedBox(
                          width: 170.w,
                          child: Text(
                            widget.product.service!.name!,
                            style: AppTextStyle(context).bodyTextExtraSmall
                                .copyWith(
                                  fontSize: 10.sp,
                                  color: AppColor.gray,
                                ),
                          ),
                        ),
                        Text(
                          widget.product.name!,
                          style: AppTextStyle(context).bodyTextSmal.copyWith(
                            color: AppColor.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: widget.product.oldPrice != null
                                    ? "$currency ${widget.product.oldPrice}"
                                    : "",
                                style: AppTextStyle(context).bodyTextExtraSmall
                                    .copyWith(
                                      color: AppColor.gray,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                              ),
                              TextSpan(
                                text:
                                    " $currency ${widget.product.currentPrice} /${S.of(context).item}",
                                style: AppTextStyle(context).bodyTextSmal
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.gray,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.product.discountPercentage != null)
                      Container(
                        padding: EdgeInsets.all(2.5.r),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColor.red,
                        ),
                        child: Center(
                          child: Text(
                            "${widget.product.discountPercentage}% OFF",
                            style: AppTextStyle(context).bodyTextExtraSmall
                                .copyWith(
                                  color: AppColor.white,
                                  fontSize: 10.sp,
                                ),
                          ),
                        ),
                      ),
                    AppSpacerH(
                      widget.product.discountPercentage != null ? 12.h : 24.h,
                    ),
                    ValueListenableBuilder(
                      valueListenable: Hive.box(AppHSC.cartBox).listenable(),
                      builder: (context, Box cartbox, Widget? child) {
                        if (inCart) {
                          final Map<String, dynamic> processedData = {};
                          final Map<dynamic, dynamic> unprocessedData =
                              cartbox.getAt(keyAt!) as Map<dynamic, dynamic>;

                          unprocessedData.forEach((key, value) {
                            processedData[key.toString()] = value;
                          });

                          final CarItemHiveModel data =
                              CarItemHiveModel.fromMap(processedData);
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (inCart) {
                                    if (data.productsQTY <= 1) {
                                      cartbox.deleteAt(keyAt!);
                                      keyAt = null;
                                      inCart = false;
                                    } else {
                                      cartbox.putAt(
                                        keyAt!,
                                        data
                                            .copyWith(
                                              productsQTY: data.productsQTY - 1,
                                            )
                                            .toMap(),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  width: 28.w,
                                  height: 28.h,
                                  decoration: BoxDecoration(
                                    color: AppColor.offWhite,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.remove, size: 24),
                                  ),
                                ),
                              ),
                              AppSpacerW(8.w),
                              Text(
                                data.productsQTY.toString(),
                                style: AppTextStyle(context).bodyText.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.black,
                                ),
                              ),
                              AppSpacerW(8.w),
                              GestureDetector(
                                onTap: () {
                                  cartbox.putAt(
                                    keyAt!,
                                    data
                                        .copyWith(
                                          productsQTY: data.productsQTY + 1,
                                        )
                                        .toMap(),
                                  );
                                },
                                child: Container(
                                  width: 28.w,
                                  height: 28.h,
                                  decoration: BoxDecoration(
                                    color: AppColor.blue,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: AppColor.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              if (!inCart) {
                                if (!canAddToCart) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(20.w),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColor.white,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            height: 200.h,
                                            width: 335.w,
                                            padding: EdgeInsets.all(20.h),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "You cannot add products from different stores to the cart.",
                                                  style: AppTextStyle(context)
                                                      .bodyText
                                                      .copyWith(
                                                        color: AppColor.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                AppSpacerH(10.h),
                                                Text(
                                                  "Want to clear your Cart?",
                                                  style: AppTextStyle(context)
                                                      .bodyTextSmal
                                                      .copyWith(
                                                        color: AppColor.black,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                AppSpacerH(20.h),
                                                SizedBox(
                                                  height: 50.h,
                                                  width: 335.w,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: AppTextButton(
                                                          title: S
                                                              .of(context)
                                                              .no,
                                                          buttonColor:
                                                              AppColor.gray,
                                                          titleColor:
                                                              AppColor.black,
                                                          onTap: () {
                                                            context.nav.pop();
                                                          },
                                                        ),
                                                      ),
                                                      AppSpacerW(10.w),
                                                      Expanded(
                                                        child: AppTextButton(
                                                          title: "Clear Cart",
                                                          onTap: () {
                                                            context.nav.pop();
                                                            cartsBox.clear();
                                                            ref.invalidate(
                                                              variationProductsProvider,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else if (!inCart && canAddToCart) {
                                  final newCartItem = CarItemHiveModel(
                                    storeId: widget.storeID,
                                    productsId: widget.product.id!,
                                    productsName: widget.product.name!,
                                    productsImage: widget.product.imagePath!,
                                    productsQTY: 1,
                                    unitPrice: widget.product.currentPrice!,
                                    serviceName: widget.product.service!.name!,
                                  );
                                  cartbox.add(newCartItem.toMap());
                                  Hive.box(
                                    AppHSC.appSettingsBox,
                                  ).put("storeid", widget.storeID.toString());

                                  Future.delayed(transissionDuration).then(
                                    (value) => ref
                                        .watch(storeIdProvider.notifier)
                                        .update((state) => widget.storeID),
                                  );
                                }
                              }
                            },
                            child: Container(
                              width: 28.w,
                              height: 28.h,
                              decoration: BoxDecoration(
                                color: AppColor.blue,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: AppColor.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
