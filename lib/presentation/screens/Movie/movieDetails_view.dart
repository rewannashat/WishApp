import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/presentation/resources/constants/custom-staticwidget.dart';
import 'package:wish/presentation/screens/Movie/movie_view.dart';
import 'package:wish/presentation/screens/Movie/movie_viewModel/movie_cubit.dart';
import 'package:wish/presentation/screens/Movie/movie_viewModel/movie_states.dart';

import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-button-constant.dart';
import '../../resources/font-manager.dart';
import '../../resources/styles-manager.dart';
import '../../../domian/Lang/helper_lang.dart';

class MovieDetailScreen extends StatelessWidget {
  final int index;

  const MovieDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        bool isFavorite = MovieCubit.get(context).isFavorite(index);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context, {'isFav': isFavorite, 'id': index}),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  MovieCubit.get(context).toggleFavorite(index);
                },
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          backgroundColor:  Colors.black54,
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
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.7), // Shadow color
                              blurRadius: 10,
                              offset: Offset(0, 4), // Shadow direction: horizontal, vertical
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '404 رحلة',
                                style: getSemiBoldTextStyle(
                                  color: ColorsManager.whiteColor,
                                  fontSize: FontSize.s15.sp,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                'قبل أيام من سفرها إلى (مكة) لأداء فريضة الحج، تتورط غادة في مشكلة طارئة... ',
                                textDirection: TextDirection.rtl,
                                style: getRegularTextStyle(
                                  color: ColorsManager.whiteColor,
                                  fontSize: FontSize.s12.sp,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "عائلي",
                                    style: getRegularTextStyle(
                                      color: ColorsManager.whiteColor,
                                      fontSize: FontSize.s12.sp,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text("|", style: TextStyle(color: Colors.white70, fontSize: 14)),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "سينمائي",
                                    style: getRegularTextStyle(
                                      color: ColorsManager.whiteColor,
                                      fontSize: FontSize.s12.sp,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text("|", style: TextStyle(color: Colors.white70, fontSize: 14)),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "أكشن",
                                    style: getRegularTextStyle(
                                      color: ColorsManager.whiteColor,
                                      fontSize: FontSize.s12.sp,
                                    ),
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
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      CustomButton(
                        width: 300.w,
                        high: 40.h,
                        txt: getTranslated(context, 'Watch'),
                        fontSize: FontSize.s15.sp,
                        colorTxt: ColorsManager.whiteColor,
                        colorButton: ColorsManager.buttonColor,
                        outLineBorder: false,
                        fontWeight: FontWightManager.fontWeightRegular,
                        borderRadius: 10.r,
                        fontFamily: FontManager.fontFamilyAPP,
                        onPressed: () {},
                      ),
                      SizedBox(height: 10.h),
                      CustomButton(
                        width: 300.w,
                        high: 40.h,
                        txt: getTranslated(context, 'Trailer'),
                        fontSize: FontSize.s15.sp,
                        colorTxt: ColorsManager.whiteColor,
                        colorButton: ColorsManager.buttonColor,
                        outLineBorder: false,
                        fontWeight: FontWightManager.fontWeightRegular,
                        borderRadius: 10.r,
                        fontFamily: FontManager.fontFamilyAPP,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                      child: Text(
                        'Cast',
                        style: getRegularTextStyle(
                          color: ColorsManager.whiteColor,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildCastItem('Mona Zaki', 'assets/images/cast.png'),
                          _buildCastItem('Sheren Reda', 'assets/images/casts.png'),
                          _buildCastItem('Mohamed Farag', 'assets/images/person.png'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
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
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
