import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wish/presentation/screens/Logins/logins_viewModel/login_cubit.dart';
import 'package:wish/presentation/screens/Logins/logins_viewModel/login_states.dart';

import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-button-constant.dart';
import '../../resources/constants/custom-staticwidget.dart';
import '../../resources/font-manager.dart';
import '../../resources/styles-manager.dart';
import 'm3u_view.dart';

class DeviceDataView extends StatelessWidget {
  const DeviceDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1d1d1d),Color(0xff171717), Color(0xFF2e3949)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200.h,),
                Text(
                  'Please follow',
                  style: getMediumTextStyle(color: Colors.white, fontSize: 20.sp),
                ),
                SizedBox(height: 5.h),
                GestureDetector(
                  onTap: () {},
                  child:  Text(
                    'https://Wish.com',
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Roboto',
                      fontSize: 20.sp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'to add/manage playlist just add',
                  style: getMediumTextStyle(color: Colors.white, fontSize: 20.sp),
                ),
                const SizedBox(height: 20),
                BlocBuilder<LoginCubit,LoginState>(
                  builder: (context, state) {
                    LoginCubit cubit = LoginCubit.get(context);
                    return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Mac address',
                            style: getMediumTextStyle(color: Colors.white, fontSize:  20.sp),
                          ),
                          Text(
                            cubit.macAddress ?? 'Unknown',
                            style: getMediumTextStyle(color: Color(0xffABB2C0), fontSize:  20.sp),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Device key',
                            style: getMediumTextStyle(color: Colors.white, fontSize:  20.sp),
                          ),
                          Text(
                            '123456',
                            style: getMediumTextStyle(color: Color(0xffABB2C0), fontSize:  20.sp),
                          ),
                        ],
                      ),
                    ],
                  );
                  },
                ),
                SizedBox(height: 35.h),
                rowDiv(120.w),
                SizedBox(height: 30.h),
                CustomButton(
                  width: 350.w,
                  high: 40.h,
                  txt: ' M3U URL',
                  fontSize: FontSize.s15.sp,
                  colorTxt: ColorsManager.whiteColor,
                  colorButton: ColorsManager.buttonColor,
                  outLineBorder: false,
                  fontWeight: FontWightManager.fontWeightRegular,
                  borderRadius: 5.r,
                  fontFamily: FontManager.fontFamAPP,
                  onPressed: () {
                    NavAndRemove(ctx: context,screen: AddPlaylistScreen());
                  },
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    final Uri whatsappUrl = Uri.parse("https://wa.me/4571653898");
                    final Uri webUrl = Uri.parse("https://web.whatsapp.com/send?phone=4571653898");

                    // Store context before async call to avoid issues with widget deactivation
                    final ctx = context;

                    if (await canLaunchUrl(whatsappUrl)) {
                      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                    } else if (await canLaunchUrl(webUrl)) {
                      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
                    } else {
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('Could not open WhatsApp')),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Contact us for Support',
                    style: TextStyle(
                      color: Color(0xffD6D6D6),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xffD6D6D6),
                      fontFamily: FontManager.fontFamAPP,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}