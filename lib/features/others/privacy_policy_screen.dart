import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundrymart/features/constants/theme.dart';
import 'package:laundrymart/features/others/logic/settings_provider.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/features/widgets/text_button.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';

class PrivacyPolicyScreen extends ConsumerStatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends ConsumerState<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).privacyPolicy)),
      body: ScreenWrapper(
        padding: EdgeInsets.zero,
        child: Container(
          height: 812.h,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            children: [
              SizedBox(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ref
                                .watch(privacyProvider)
                                .map(
                                  initial: (_) => const SizedBox(),
                                  loading: (_) => const LoadingWidget(),
                                  loaded: (d) => SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10.0.h),
                                          child: Html(
                                            style: {
                                              '*': Style(
                                                color: colors(
                                                  context,
                                                ).bodyTextColor,
                                                fontSize: FontSize(14.sp),
                                                fontFamily: 'Open Sans',
                                              ),
                                            },
                                            data:
                                                '${d.data.data!.setting!.content!}<p></p><p></p><p></p><p></p><p></p>',
                                          ),
                                        ),
                                        AppSpacerH(60.h),
                                      ],
                                    ),
                                  ),
                                  error: (e) => ErrorTextWidget(error: e.error),
                                ),
                            AppSpacerH(60.h),
                          ],
                        ),
                      ),
                      // error: (_) => ErrorTextWidget(error: _.error),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 375.w,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ),
                  child: AppTextButton(
                    title: S.of(context).cls,
                    onTap: () async {
                      context.nav.pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
