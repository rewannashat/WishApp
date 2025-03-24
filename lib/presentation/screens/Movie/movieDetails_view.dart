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
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black54,
                      Colors.black87,
                      Colors.black54,
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
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
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: Container(color: Colors.black.withOpacity(0.3)),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                  'قبل أيام من سفرها إلى (مكة) لأداء فريضة الحج، تتورط غادة في مشكلة طارئة...',
                                  textDirection: TextDirection.rtl,
                                  style: getRegularTextStyle(
                                    color: ColorsManager.whiteColor,
                                    fontSize: FontSize.s12.sp,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cast',
                            style: getBoldTextStyle(
                              color: ColorsManager.whiteColor,
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildCastItem('Mona Zaki', 'assets/images/cast.png'),
                              _buildCastItem('Sheren Reda', 'assets/images/casts.png'),
                              _buildCastItem('Mohamed Farag', 'assets/images/person.png'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
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
