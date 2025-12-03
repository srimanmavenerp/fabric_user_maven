import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/auth/logic/auth_providers.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/utils/entensions.dart';
import 'package:laundrymart/utils/routes.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  Location location = Location();
  Box? locationBox;
  late ScrollController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool startCurveAnimation = false;
  Box appSettingsBox = Hive.box(AppHSC.appSettingsBox);

  @override
  void initState() {
    super.initState();
    locationBox = Hive.box(AppHSC.locationBox);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initAppSettingData();
    });
    requestLocationPermission();
    _controller = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    scroll();
  }

  void scroll() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 1), () {
        setState(() {
          startCurveAnimation = true;
        });
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: const Duration(minutes: 1),
          curve: Curves.linear,
        );
      });
      setState(() {
        startCurveAnimation = false;
      });
    });
  }

  void initAppSettingData() {
    ref.read(appSettingsProvider.notifier).getAppSettings().then((appSettings) {
      ref.read(appSettingDataProvider.notifier).state = appSettings;
    });
  }

  Future<void> requestLocationPermission() async {
    ph.PermissionStatus status = await ph.Permission.location.request();
    if (status == ph.PermissionStatus.granted) {
      await getLocation();
    } else if (status == ph.PermissionStatus.permanentlyDenied) {
      // ignore: use_build_context_synchronously
      showAlertDialog(context);
    } else {
      bool isEnable = await ph.openAppSettings();

      if (isEnable) {
        await getLocation();
      }
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text("Location Permission"),
      content: const Text("Please enable your location first."),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> getLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      bool serviceStatus = await location.requestService();
      if (!serviceStatus) {
        return;
      }
    }

    ph.PermissionStatus permissionStatus = await ph.Permission.location.status;

    if (permissionStatus == ph.PermissionStatus.granted) {
      LocationData locationData = await location.getLocation();
      double? latitude = locationData.latitude;
      double? longitude = locationData.longitude;
      locationBox!.putAll({"latitude": latitude, "longitude": longitude});

      //ignore: use_build_context_synchronously
      context.nav.pushNamedAndRemoveUntil(
        appSettingsBox.get(AppHSC.hasSeenSplashScreen) != null
            ? Routes.bottomnavScreen
            : Routes.onBoardingScreen,
        (route) => false,
      );
    } else {
      requestLocationPermission();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          Center(
            child: Hero(
              tag: 'logo',
              child: ScaleTransition(
                scale: _animation,
                child: Image.asset(
                  Theme.of(context).scaffoldBackgroundColor == AppColor.black
                      ? "assets/images/png/fabric.png"
                      : "assets/images/png/fabric_touch logo app (1).png",
                  height: 100.h,
                  width: 195.w,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: AnimatedOpacity(
              opacity: startCurveAnimation ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                height: 20,
                width: 1.sw,
                child: SingleChildScrollView(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      15,
                      (index) => SizedBox(
                        child: Image.asset(
                          "assets/images/png/curve.png",
                          fit: BoxFit.fitWidth,
                          width: 1.2.sw,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
