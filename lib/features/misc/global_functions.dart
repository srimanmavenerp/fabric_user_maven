// ignore_for_file: require_trailing_commas

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:laundrymart/features/services/model/hive_cart_item_model.dart';

class AppGFunctions {
  AppGFunctions._();
  static void changeStatusBarColor({
    required Color color,
    Brightness? iconBrightness,
    Brightness? brightness,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color, //or set color with: Color(0xFF0000FF)
        statusBarIconBrightness:
            iconBrightness ?? Brightness.dark, // For Android (dark icons)
        statusBarBrightness: brightness ?? Brightness.light,
      ),
    );
  }

  static Logger log() {
    final logger = Logger();
    return logger;
  }

  static double calculateTotal(List<CarItemHiveModel> cartItems) {
    double amount = 0;
    for (final element in cartItems) {
      amount += element.productsQTY * element.unitPrice;
    }
    return amount;
  }
}
