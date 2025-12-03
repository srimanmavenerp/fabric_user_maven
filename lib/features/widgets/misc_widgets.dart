import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/widgets/busy_loader.dart';

class AppSpacerH extends StatelessWidget {
  const AppSpacerH(this.height, {super.key});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class AppSpacerW extends StatelessWidget {
  const AppSpacerW(this.width, {super.key});
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

// ignore: must_be_immutable
class CustomSeprator extends StatelessWidget {
  CustomSeprator({super.key, this.color, this.height, this.width});
  Color? color;
  double? height;
  double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 1.h,
      width: width ?? double.infinity,
      color: color ?? AppColor.gray,
    );
  }
}

class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: AppTextStyle(context).bodyTextSmal.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColor.red,
        ),
      ),
    );
  }
}

class MessageTextWidget extends StatelessWidget {
  const MessageTextWidget({super.key, required this.msg});
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(msg, style: AppTextStyle(context).bodyTextH1));
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.showBG = false});
  final bool showBG;

  @override
  Widget build(BuildContext context) {
    return Center(child: BusyLoader(showbackground: showBG));
  }
}

class AppDashedSeparator extends StatelessWidget {
  const AppDashedSeparator({
    Key? key,
    this.height = 1,
    this.color = AppColor.gray,
  }) : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 3.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}

class DelayWidget extends StatelessWidget {
  const DelayWidget({Key? key, required this.child, required this.shouldMove})
    : super(key: key);
  final Widget child;
  final bool shouldMove;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      transform: Matrix4.translationValues(0, shouldMove ? 0 : 200.h, 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: shouldMove ? 1 : 0,
        curve: Curves.easeIn,
        child: child,
      ),
    );
  }
}
