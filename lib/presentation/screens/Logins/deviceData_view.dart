import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wish/presentation/screens/Logins/logins_viewModel/login_cubit.dart';
import 'package:wish/presentation/screens/Logins/logins_viewModel/login_states.dart';
import 'package:wish/presentation/screens/Logins/splash_view.dart';

import '../../../domian/local/sharedPref.dart';
import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-button-constant.dart';
import '../../resources/constants/custom-staticwidget.dart';
import '../../resources/font-manager.dart';
import '../../resources/styles-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';
import 'm3u_view.dart';

class DeviceDataView extends StatefulWidget {
  const DeviceDataView({super.key});

  @override
  State<DeviceDataView> createState() => _DeviceDataViewState();
}

class _DeviceDataViewState extends State<DeviceDataView> {

  String? macAddress;
  String? device ;
  void loadData() async {
    String? mac = await SharedPreferencesHelper.getData(key: 'macAddress');
    String? deviceKey = await SharedPreferencesHelper.getData(key: 'deviceKey');

    print('$mac');

    setState(() {
      macAddress = mac;
      device = deviceKey;
    });
  }


  @override
  void initState() {
    super.initState();
    loadData();
  }


  @override
  Widget build(BuildContext context)  {
    LoginCubit cubit = LoginCubit.get(context);

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
                  onTap: () async {
                    final Uri url = Uri.parse("https://haythamelbadwy.github.io/Wish");

                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                      throw 'Could not launch $url';
                    }
                  },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Mac address',
                          style: getMediumTextStyle(color: Colors.white, fontSize:  20.sp),
                        ),
                        Text(
                          macAddress ?? 'loading',
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
                          device ?? 'loading',
                          style: getMediumTextStyle(color: Color(0xffABB2C0), fontSize:  20.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 35.h),
                rowDiv(120.w),
                SizedBox(height: 30.h),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
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
                    onPressed: () async {
                      NavAndRemove(ctx: context,screen: AddPlaylistScreen());

                      // final result = await cubit.login();
                      // if(await result) {
                      //   NavAndRemove(ctx: context,screen: AddPlaylistScreen());
                      // }/* else {
                      //   AwesomeDialog(
                      //     context: context,
                      //     dialogType: DialogType.warning,
                      //     animType: AnimType.scale,
                      //     headerAnimationLoop: false,
                      //     title: 'Trial Period Expired',
                      //     desc: 'You need to subscribe to continue using the app.',
                      //     btnOkText: 'OK',
                      //     btnOkOnPress: () {
                      //       Navigator.pushReplacement(
                      //         context,
                      //         MaterialPageRoute(builder: (_) => SplashView()),
                      //       );
                      //     },
                      //     btnOkColor: Colors.redAccent,
                      //     customHeader: Lottie.asset(
                      //       'assets/animation/Animation - 1743562215054.json',
                      //       height: 150,
                      //       repeat: true,
                      //     ),
                      //   )..show();
                      // }*/
                    },
                  ),
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    width: 350.w,
                    high: 40.h,
                    txt: ' Free Trial',
                    fontSize: FontSize.s15.sp,
                    colorTxt: ColorsManager.whiteColor,
                    colorButton: ColorsManager.buttonColor,
                    outLineBorder: false,
                    fontWeight: FontWightManager.fontWeightRegular,
                    borderRadius: 5.r,
                    fontFamily: FontManager.fontFamAPP,
                    onPressed: ()  async{
                      NavAndRemove(ctx: context , screen: BottomNavBar());

                     /* final result = await cubit.login();
                      if(await result) {
                        NavAndRemove(ctx: context , screen: BottomNavBar());
                      } *//*else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.scale,
                          headerAnimationLoop: false,
                          title: 'Trial Period Expired',
                          desc: 'You need to subscribe to continue using the app.',
                          btnOkText: 'OK',
                          btnOkOnPress: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => SplashView()),
                            );
                          },
                          btnOkColor: Colors.redAccent,
                          customHeader: Lottie.asset(
                            'assets/animation/Animation - 1743562215054.json',
                            height: 150,
                            repeat: true,
                          ),
                        )..show();
                      }*/
                    },
                  ),
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