import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/domian/Lang/helper_lang.dart';
import 'package:wish/presentation/resources/colors-manager.dart';
import 'package:wish/presentation/resources/font-manager.dart';

import '../../resources/constants/custom-button-constant.dart';
import '../../resources/styles-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';

class MovieDetailScreen extends StatelessWidget {
  int index;

  MovieDetailScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/img.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding:
                    EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('404 رحلة',
                            style: getSemiBoldTextStyle(
                                color: ColorsManager.whiteColor,
                                fontSize: FontSize.s15.sp)),
                        SizedBox(height: 5.h),
                        Text(
                          'قبل أيام من سفرها إلى (مكة) لأداء فريضة الحج، تتورط غادة في مشكلة طارئة... ',
                          textDirection: TextDirection.rtl,
                          style: getRegularTextStyle(
                              color: ColorsManager.whiteColor,
                              fontSize: FontSize.s12.sp),
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "عائلي",
                              style: getRegularTextStyle(
                                  color: ColorsManager.whiteColor,
                                  fontSize: FontSize.s12.sp),
                            ),
                            SizedBox(width: 6.w),
                            Text("|", style: TextStyle(color: Colors.white70, fontSize: 14)),
                            SizedBox(width: 6.w),
                            Text(
                              "سينمائي",
                              style: getRegularTextStyle(
                                  color: ColorsManager.whiteColor,
                                  fontSize: FontSize.s12.sp),
                            ),
                            SizedBox(width: 6.w),
                            Text("|", style: TextStyle(color: Colors.white70, fontSize: 14)),
                            SizedBox(width: 6.w),
                            Text(
                              "أكشن",
                              style: getRegularTextStyle(
                                  color: ColorsManager.whiteColor,
                                  fontSize: FontSize.s12.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star_border, color: Colors.amber),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  CustomButton(
                    width: 300.w,high: 40.h,
                    txt: getTranslated(context, 'Watch'),
                    fontSize: FontSize.s15.sp,
                    colorTxt: ColorsManager.whiteColor,
                    colorButton: ColorsManager.buttonColor,
                    outLineBorder: false,
                    fontWeight: FontWightManager.fontWeightRegular,
                    borderRadius: 10.r,
                    fontFamily: FontManager.fontFamilyAPP,
                    onPressed: (){},
                  ),
                  SizedBox(height: 10.h,),
                  CustomButton(
                    width: 300.w,high: 40.h,
                    txt: getTranslated(context, 'Trailer'),
                    fontSize: FontSize.s15.sp,
                    colorTxt: ColorsManager.whiteColor,
                    colorButton: ColorsManager.buttonColor,
                    outLineBorder: false,
                    fontWeight: FontWightManager.fontWeightRegular,
                    borderRadius: 10.r,
                    fontFamily: FontManager.fontFamilyAPP,
                    onPressed: (){},
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cast',
                      style: getBoldTextStyle(color: ColorsManager.whiteColor, fontSize: 20.sp)),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCastItem(
                          'Mona Zaki', 'assets/images/cast.png'),
                      _buildCastItem(
                          'Sheren Reda', 'assets/images/casts.png'),
                      _buildCastItem(
                          'Mohamed Farag', 'assets/images/person.png'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildCastItem(String name, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(imageUrl),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
