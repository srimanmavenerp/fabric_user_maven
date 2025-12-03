import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laundrymart/features/Notification/notification_screen.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/core/home_screen.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/order/my_order_sceen.dart';
import 'package:laundrymart/features/profile/profile_screen.dart';
import 'package:laundrymart/features/store/nearby_store.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(homeScreenIndexProvider);

    return Scaffold(
      extendBody: true,
      body: _getChild(selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(color: AppColor.black.withOpacity(0.1), blurRadius: 12),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: const [
              BoxShadow(
                color: AppColor.offWhite,
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0, -1),
              ),
            ],
          ),
          height: 72.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _text.length,
              (index) => GestureDetector(
                onTap: () {
                  ref.read(homeScreenIndexProvider.notifier).state = index;
                },
                child: bottomContainer(
                  isActive: selectedIndex == index,
                  selectedIcon: _selectedIcon[index],
                  unselectedIcon: _unSelectedIcon[index],
                  text: _text[index],
                  index: index,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column bottomContainer({
    required bool isActive,
    required String selectedIcon,
    required String unselectedIcon,
    required String text,
    required int index,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isActive ? 40.h : 0.h,
              width: isActive ? 40.h : 0.h,
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(8.r),
            ),
            Container(
              height: 40.h,
              width: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(8.r),
              child: SvgPicture.asset(isActive ? selectedIcon : unselectedIcon),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: AppTextStyle(context).bodyTextExtraSmall.copyWith(
                color: isActive
                    ? Theme.of(context).primaryColor
                    : AppColor.gray,
                fontSize: 10.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  final List<String> _unSelectedIcon = [
    "assets/svgs/home.svg",
    "assets/svgs/shop.svg",
    "assets/svgs/order.svg",
    "assets/svgs/notification.svg",
    "assets/svgs/user.svg",
  ];
  final List<String> _selectedIcon = [
    "assets/svgs/home_selected.svg",
    "assets/svgs/shop_selected.svg",
    "assets/svgs/order_selected.svg",
    "assets/svgs/notification_selected.svg",
    "assets/svgs/user_selected.svg",
  ];

  final List<String> _text = [
    "Home",
    "Nearby Store",
    "My Order",
    "Notification",
    "Profile",
  ];

  Widget _getChild(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const NearbyStoreScreen();
      case 2:
        return const MyOrderScreen();
      case 3:
        return const NotificationScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}
