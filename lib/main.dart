import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/misc_providers.dart';
import 'package:laundrymart/features/constants/theme.dart';
import 'package:laundrymart/features/profile/profile_screen.dart';
import 'package:laundrymart/firebase_options.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }

  // await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message ${message.messageId}');
}

// /// Create a [AndroidNotificationChannel] for heads up notifications
// late AndroidNotificationChannel channel;

// bool isFlutterLocalNotificationsInitialized = false;

// Future<void> setupFlutterNotifications() async {
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }
//   channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );

//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// Create an Android Notification Channel.
///
/// We use this channel in the `AndroidManifest.xml` file to override the
/// default FCM channel to enable heads up notifications.
// await flutterLocalNotificationsPlugin
//     .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//     ?.createNotificationChannel(channel);
// await flutterLocalNotificationsPlugin
//     .resolvePlatformSpecificImplementation<
//         IOSFlutterLocalNotificationsPlugin>()
//     ?.requestPermissions(
//       alert: true,
//       badge: true,
//     );

/// Update the iOS foreground notification presentation options to allow
/// heads up notifications.
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   isFlutterLocalNotificationsInitialized = true;
// }

void showFlutterNotification(RemoteMessage message) {
  final RemoteNotification? notification = message.notification;
  final AndroidNotification? android = message.notification?.android;
  final AppleNotification? iOS = message.notification?.apple;
  if (notification != null && (android != null || iOS != null) && !kIsWeb) {
    // flutterLocalNotificationsPlugin.show(
    //   notification.hashCode,
    //   notification.title,
    //   notification.body,
    //   // NotificationDetails(
    //   //   android: AndroidNotificationDetails(
    //   //     channel.id,
    //   //     channel.name, channelDescription: channel.description,
    //   //     // TODO add a proper drawable resource to android, for now using
    //   //     //      one that already exists in example app.
    //   //     icon: '@drawable/ic_stat_launcher',
    //   //   ),
    //   //   iOS: const DarwinNotificationDetails(
    //   //     presentAlert: true,
    //   //     presentBadge: true,
    //   //     presentSound: true,
    //   //   ),
    //   // ),
    // );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await setupFlutterNotifications();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((event) {
    debugPrint(event.data.toString());
    debugPrint(event.toString());
    debugPrint('Handling a ForeGround message ${event.messageId}');
    debugPrint('Handling a ForeGround message ${event.notification}');

    showFlutterNotification(event);
  });

  // final token = await FirebaseMessaging.instance.getToken();
  await Hive.initFlutter();
  await Hive.openBox(AppHSC.appSettingsBox);
  await Hive.openBox(AppHSC.authBox);
  await Hive.openBox(AppHSC.userBox);
  await Hive.openBox(AppHSC.cartBox);
  await Hive.openBox(AppHSC.locationBox);
  runApp(ProviderScope(child: MyApp()));
}

Future<void> getPlayerID(WidgetRef ref) async {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // Request permission to receive notifications (required for iOS devices)
  await firebaseMessaging.requestPermission();

  // Get the FCM token
  String? fcmToken = await firebaseMessaging.getToken();

  if (fcmToken == null) {
    // If the token is null, try again to get the FCM token
    return getPlayerID(ref);
  } else {
    ref.watch(onesignalDeviceIDProvider.notifier).state = fcmToken;
  }
}

// ignore: must_be_immutable
class MyApp extends ConsumerWidget {
  MyApp({super.key});
  Locale resolveLocale(String? langCode) {
    if (langCode != null) {
      return Locale(langCode);
    } else {
      return const Locale('en');
    }
  }

  bool isDarkTheme = false;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final playerID = ref.watch(onesignalDeviceIDProvider);
    // if (playerID == '') {
    //   // getPlayerID(ref);
    // }
    return ScreenUtilInit(
      designSize: const Size(390, 844), // XD Design Size
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder(
          valueListenable: Hive.box(AppHSC.appSettingsBox).listenable(),
          builder: (BuildContext context, Box appSettingsBox, Widget? child) {
            final isDark = appSettingsBox.get(AppHSC.isDarkTheme);
            if (isDark == null) {
              setTheme(value: isDarkTheme);
            }
            final selectedLocal = appSettingsBox.get(AppHSC.appLocal);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Fabric Touch',
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                FormBuilderLocalizations.delegate,
              ],
              locale: resolveLocale(selectedLocal as String?),
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                if (selectedLocal == null || selectedLocal == '') {
                  appSettingsBox.put(
                    AppHSC.appLocal,
                    deviceLocale?.languageCode,
                  );
                }
                for (final locale in supportedLocales) {
                  if (locale.languageCode == deviceLocale!.languageCode) {
                    return deviceLocale;
                  }
                }
                return supportedLocales.first;
              },
              supportedLocales: S.delegate.supportedLocales,
              theme: getAppTheme(
                context: context,
                isDarkTheme: isDark ?? isDarkTheme,
              ),
              navigatorKey: ContextLess
                  .navigatorkey, //Setting Global navigator key to navigate from anywhere without Context
              onGenerateRoute: generatedRoutes,
              initialRoute: Routes.splash,
              builder: EasyLoading.init(),
            );
          },
        );
      },
    );
  }
}
