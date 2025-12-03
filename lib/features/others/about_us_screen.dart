import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/others/logic/settings_provider.dart';
import 'package:laundrymart/features/others/widgets/app_nav_bar.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/features/widgets/text_button.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends ConsumerStatefulWidget {
  const AboutUsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends ConsumerState<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).abtus),
        leading: InkWell(
          onTap: () => context.nav.pop(),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        ),
      ),
      body: ScreenWrapper(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            AppSpacerH(44.h),

            AppSpacerH(8.h),
            ref
                .watch(aboutProvidre)
                .map(
                  initial: (_) => const SizedBox(),
                  loading: (_) => const Center(child: LoadingWidget()),
                  loaded: (d) => Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.h,
                          vertical: 8.h,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              AppSpacerH(12.h),
                              SvgPicture.asset('assets/svgs/abouUsIcon.svg'),
                              AppSpacerH(12.h),
                              Text(
                                d.data.data.title ?? '',
                                style: AppTextStyle(context).bodyTextH1,
                              ),
                              AppSpacerH(12.h),
                              // Text(
                              //   'Your Trusted Business Partner',
                              //   style: AppTextStyle(context)
                              //       .bodyTextSmal
                              //       .copyWith(fontSize: 18),
                              // ),
                              AppSpacerH(12.h),
                              Text(
                                d.data.data.desceiption ?? '',
                                style: AppTextStyle(context).bodyTextSmal,
                                textAlign: TextAlign.center,
                              ),
                              AppSpacerH(40.h),
                              AppTextButton(
                                icon: 'assets/svgs/callIcon.svg',
                                onTap: () {
                                  final Uri uri = Uri(
                                    scheme: 'tel',
                                    path: d.data.data.phone,
                                  );
                                  _launchUrl(uri);
                                },
                                iconheight: 25.h,
                                height: 50.h,
                                width: 240.w,
                                title: d.data.data.phone ?? '',
                                buttonColor: AppColor.red.withOpacity(0.8),
                                borderRadius: 50,
                              ),
                              AppSpacerH(20.h),
                              AppTextButton(
                                icon: 'assets/svgs/whatsAppIcon.svg',
                                onTap: () async {
                                  // await FlutterLaunch.launchWhatsapp(
                                  //   phone: _.data.data.whatsapp ?? '',
                                  //   message: "",
                                  // );
                                },
                                height: 50.h,
                                width: 240.w,
                                title: d.data.data.whatsapp ?? '',
                                buttonColor: AppColor.blue,
                                borderRadius: 50,
                              ),
                              AppSpacerH(20.h),
                              AppTextButton(
                                icon: 'assets/svgs/emailIcon.svg',
                                onTap: () async {
                                  if (!await launchUrl(
                                    Uri.parse('mailto:${d.data.data.email}'),
                                  )) {
                                    EasyLoading.showError("Couldn't Find Mail");
                                  }
                                },
                                height: 50.h,
                                width: 240.w,
                                title: d.data.data.email ?? '',
                                buttonColor: AppColor.blue.withGreen(150),
                                borderRadius: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  error: (e) => ErrorTextWidget(error: e.error),
                ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl(Uri url) async {
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  } catch (_) {}
}
