import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_cubit.dart';

import '../../../domian/Lang/helper_lang.dart';
import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-button-constant.dart';
import '../../resources/font-manager.dart';
import '../../resources/styles-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';

class SeriesDetailsView extends StatelessWidget {
  int index;

  SeriesDetailsView({required this.index});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsetsDirectional.symmetric(
                              vertical: 30),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8.0),
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                    Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              BlocBuilder<SeriesCubit, Set<int>>(
                                builder: (context, state) {
                                  final cubit = context.read<SeriesCubit>();
                                  return Container(
                                    height: 40,
                                    width: 150,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        dropdownColor: ColorsManager.blackColor,
                                        isExpanded: true,
                                        value: cubit.selectedcategoriesDetails,
                                        icon: const Icon(Icons.arrow_drop_down,
                                            color: Colors.white),
                                        style: const TextStyle(
                                            color: Colors.white),
                                        items: cubit.categoriesDetails.map((
                                            String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,
                                                style: getRegularTitleStyle(
                                                    color: ColorsManager
                                                        .whiteColor,
                                                    fontSize: 12.sp)),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            cubit.changeCategoryDetails(
                                                newValue);
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                    Icons.favorite, color: Colors.white),
                                onPressed: () {
                                  // Handle favorite
                                },
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 10),
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
                                      ),]),
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
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cast',
                              style: getBoldTextStyle(
                                  color: ColorsManager.whiteColor,
                                  fontSize: 20.sp)),
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16),
                            title: Text(
                              'Episode ${index + 1}',
                              style: getRegularTitleStyle(
                                  color: ColorsManager.whiteColor,
                                  fontSize: 16.sp),
                            ),
                            leading: const Icon(Icons.play_circle_filled,
                                color: Colors.white),
                            trailing: const Icon(
                                Icons.remove_red_eye, color: Colors.white),
                            onTap: () {
                              // Handle episode click
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            BottomNavBar(), // Bottom Nav outside Expanded keeps it at the bottom
          ],
        ),
      ),
    );
  }
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