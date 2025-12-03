import 'package:flutter/material.dart';
import 'package:laundrymart/features/address/add_address.dart';
import 'package:laundrymart/features/address/manage_address.dart';
import 'package:laundrymart/features/address/model/address_list_model/address.dart';
import 'package:laundrymart/features/auth/login_otp_screen.dart';
import 'package:laundrymart/features/auth/login_screen.dart';
import 'package:laundrymart/features/auth/password_change_screen.dart';
import 'package:laundrymart/features/auth/password_recovery.dart';
import 'package:laundrymart/features/auth/sign_up_screen.dart';
import 'package:laundrymart/features/cart/my_cart.dart';
import 'package:laundrymart/features/core/bottom_navbar.dart';
import 'package:laundrymart/features/core/model/all_stores_model/store.dart';
import 'package:laundrymart/features/core/service_base_store.dart';
import 'package:laundrymart/features/onBoarding/on_boarding.dart';
import 'package:laundrymart/features/onBoarding/splash_screen.dart';
import 'package:laundrymart/features/order/order_details.dart';
import 'package:laundrymart/features/others/about_us_screen.dart';
import 'package:laundrymart/features/others/privacy_policy_screen.dart';
import 'package:laundrymart/features/others/terms_conditions.dart';
import 'package:laundrymart/features/payment/model/all_order_model/order.dart';
import 'package:laundrymart/features/payment/schedule/delivery_schedule_picker.dart';
import 'package:laundrymart/features/payment/schedule/schedule_picker.dart';
import 'package:laundrymart/features/payment/shipping_payment.dart';
import 'package:laundrymart/features/profile/create_password_screen.dart';
import 'package:laundrymart/features/profile/my_profile_screen.dart';
import 'package:laundrymart/features/services/service_details.dart';
import 'package:laundrymart/features/store/model/service_model/service.dart';
import 'package:laundrymart/features/store/store_details_screen.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  /*We are mapping all th eroutes here
  so that we can call any named route
  without making typing mistake
  */
  Routes._();
  //core
  static const splash = '/';
  static const loginScreen = '/loginScreen';
  static const onBoardingScreen = '/onBoardingScreen';
  static const signUpScreen = '/signUpScreen';
  static const profileCompleteScreen = '/profileCompleteScreen';
  static const pdfviewer = '/pdfviewer';
  static const signviewer = '/signviewer';
  static const bottomnavScreen = '/bottomnavScreen';
  static const storedetailsScreen = '/storedetailsScreen';
  static const servicedetailsScreen = '/servicedetailsScreen';
  static const myCartScreen = '/myCartScreen ';
  static const shippingPaymentScreen = '/shippingPaymentScreen ';
  static const manageAddressScreen = '/manageAddressScreen ';
  static const addAddressScreen = '/addAddressScreen ';
  static const orderDetailsScreen = '/orderDetailsScreen ';
  static const myProfileScreen = '/myProfileScreen ';
  static const aboutusScreen = '/aboutusScreen ';
  static const privacyPolicyScreen = '/privacyPolicyScreen ';
  static const termsandConditionsScreen = '/termsandConditionsScreen ';

  /// Requries phone Number [AuthRouteDataModel]
  static const loginOtpScreen = '/loginOtpScreen';

  //Authorized Routes
  static const homeScreen = '/homeScreen';
  static const chatScreen = '/chatScreen';
  static const profileScreen = '/profileScreen';
  static const fileDetailsScreen = '/fileDetailsScreen';
  static const onboardingScreen = '/onboardingScreen';
  static const searchresultsScreen = '/searchresultsScreen';
  static const classRoutineScreen = '/classRoutineScreen';
  static const examRoutineScreen = '/examRoutineScreen';
  static const attendanceSummaryScreen = '/attendanceSummaryScreen';
  static const attendanceDetailsScreen = '/attendanceDetailsScreen';
  static const resultScreen = '/resultScreen';
  static const paymentInfoScreen = '/paymentInfoScreen';
  static const noticeScreen = '/noticeScreen';
  static const noticePdfScreen = '/noticePdfScreen';
  static const digitalContentScreen = '/digitalContentScreen';
  static const profilePageScreen = '/profilePageScreen';
  static const changePasswordScreen = '/changePasswordScreen';
  static const schedulePickerScreen = '/schedulePickerScreen';
  static const deilverySchedulePickerScreen = '/deilverySchedulePickerScreen';
  static const recoveryPasswordStageOne = '/recoveryPasswordStageOne';
  static const changePass = '/changePass';
  static const serviceBasedStores = '/serviceBasedStores';
}

Route generatedRoutes(RouteSettings settings) {
  Widget child;

  switch (settings.name) {
    //core
    case Routes.splash:
      child = const SplashScreen();
      break;
    case Routes.onBoardingScreen:
      child = OnBoardingScreen();
      break;
    case Routes.loginScreen:
      child = const LoginScreen();
      break;
    case Routes.signUpScreen:
      child = const SignUpScreen();
      break;
    case Routes.bottomnavScreen:
      child = const BottomNavBar();
      break;
    case Routes.changePasswordScreen:
      child = const CreatePasswordScreen();
      break;
    case Routes.storedetailsScreen:
      final arguments = settings.arguments as Map<String, dynamic>;
      final storeIndex = arguments['storeindex'] as int;
      final store = arguments['store'] as Store;
      child = StoreDetailsScreen(
        storeindex: storeIndex,
        store: store,
      );
      break;
    case Routes.servicedetailsScreen:
      final arguments = settings.arguments as Map<String, dynamic>;
      final storeid = arguments['storeid'] as int;
      final service = arguments['service'] as Service;
      final storeName = arguments['storeName'] as String;
      child = ServiceDetailsScreen(
        service: service,
        storeid: storeid,
        storeName: storeName,
      );
      break;
    case Routes.myCartScreen:
      child = const MyCartScreen();
      break;
    case Routes.shippingPaymentScreen:
      child = ShippingAndPaymentScreen(
        address: settings.arguments as Address?,
      );
      break;
    case Routes.manageAddressScreen:
      child = ManageAddressScreen(
        isprofile: settings.arguments as bool,
      );
      break;
    case Routes.addAddressScreen:
      child = AddAddress(
        address: settings.arguments as Address?,
      );
      break;
    case Routes.orderDetailsScreen:
      child = OrderDetails(
        order: settings.arguments as Order,
      );
      break;
    case Routes.myProfileScreen:
      child = const MyProfileScreen();
      break;
    case Routes.aboutusScreen:
      child = const AboutUsScreen();
      break;
    case Routes.schedulePickerScreen:
      child = const SchedulerPicker();
      break;
    case Routes.deilverySchedulePickerScreen:
      child = const DeliverySchedulerPicker();
      break;
    case Routes.privacyPolicyScreen:
      child = const PrivacyPolicyScreen();
      break;
    case Routes.termsandConditionsScreen:
      child = const TermsConditionsScreen();
      break;
    case Routes.loginOtpScreen:
      final Map<String, dynamic> args =
          settings.arguments as Map<String, dynamic>;

      child = LoginOtpScreen(
        contact: args['contact'] as String,
        isSignUp: args['isSignUp'] as bool,
      );
      break;
    case Routes.recoveryPasswordStageOne:
      child = RecoverPasswordStageOne();
      break;
    case Routes.changePass:
      child = PasswordChangeScreen(
        token: settings.arguments as String,
      );
      break;
    case Routes.serviceBasedStores:
      final arguments = settings.arguments as Map<String, dynamic>;
      final serviceId = arguments['serviceId'] as int;
      final service = arguments['service'] as Service;
      child = ServiceBasedStores(
        serviceId: serviceId,
        service: service,
      );
      break;
    default:
      throw Exception('Invalid route: ${settings.name}');
  }
  debugPrint("Route: ${settings.name}");
  return PageTransition(
    child: child,
    type: PageTransitionType.fade,
    settings: settings,
    duration: 500.milisec,
    reverseDuration: 500.milisec,
  );
}
