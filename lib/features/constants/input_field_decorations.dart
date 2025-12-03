import 'package:flutter/material.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/constants/theme.dart';

class AppInputDecor {
  final BuildContext context;
  AppInputDecor(this.context); // This class is not meant to be instantiated.
  InputDecoration get loginPageInputDecor => InputDecoration(
    isDense: false,
    contentPadding: const EdgeInsets.all(15),
    hintStyle: const TextStyle(color: AppColor.gray, fontSize: 16),
    filled: true,
    labelStyle: AppTextStyle(context).bodyTextSmal,
    fillColor: Theme.of(context).scaffoldBackgroundColor,
    errorStyle: AppTextStyle(
      context,
    ).bodyTextExtraSmall.copyWith(color: AppColor.red),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: colors(context).bodyTextColor!.withOpacity(0.3),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: colors(context).bodyTextColor!.withOpacity(0.3),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: colors(context).primaryColor ?? Theme.of(context).primaryColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: AppColor.red),
    ),
  );
  InputDecoration get loginPageInputDecor2 => InputDecoration(
    isDense: false,
    contentPadding: const EdgeInsets.all(15),
    hintStyle: const TextStyle(color: AppColor.gray, fontSize: 16),
    filled: true,
    labelStyle: AppTextStyle(
      context,
    ).bodyTextSmal.copyWith(color: AppColor.gray),
    fillColor: Theme.of(context).scaffoldBackgroundColor,
    errorStyle: AppTextStyle(
      context,
    ).bodyTextExtraSmall.copyWith(color: AppColor.red),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: colors(context).bodyTextColor!.withOpacity(0.3),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: colors(context).bodyTextColor!.withOpacity(0.4),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: colors(context).primaryColor ?? Theme.of(context).primaryColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: AppColor.red),
    ),
  );
}
