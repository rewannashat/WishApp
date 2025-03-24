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
import '../BottomNav/bottomnav_cubit.dart';
import '../BottomNav/bottomnavbar_view.dart';

class SeriesDetailsView extends StatelessWidget {
  int index;

  SeriesDetailsView({required this.index});

  @override
  Widget build(BuildContext context) {
    final cubit = BottomNavBarCubit.get(context);
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black54,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              'assets/images/seriess.png',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              margin: const EdgeInsetsDirectional.symmetric(vertical: 20),
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back, color: Colors.white , size: 30,),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                  BlocBuilder<SeriesCubit, Set<int>>(
                                    builder: (context, state) {
                                      final cubit = context.read<SeriesCubit>();
                                      return Container(
                                        height: 30.h,
                                        width: 250.w,
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            dropdownColor: Colors.black.withOpacity(0.5),
                                            isExpanded: true,
                                            value: cubit.selectedcategoriesDetails,
                                            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                            style: const TextStyle(color: Colors.white),
                                            items: cubit.categoriesDetails.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value,
                                                    style: getRegularTitleStyle(
                                                        color: ColorsManager.whiteColor,
                                                        fontSize: 12.sp)),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                cubit.changeCategoryDetails(newValue);
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.favorite, color: Colors.white , size: 30,),
                                    onPressed: () {
                                      // Handle favorite
                                    },
                                  ),
                                ],
                              ),
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
                        SizedBox(height: 10.h,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cast',
                                style: getRegularTitleStyle(
                                    color: ColorsManager.whiteColor,
                                    fontSize: 20.sp)),
                            SizedBox(height: 12.h),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildCastItem('Hisham maged', 'assets/images/persons.png'),
                                  SizedBox(width: 10.w),
                                  _buildCastItem('Asmaa galal', 'assets/images/persons1.png'),
                                  SizedBox(width: 10.w),
                                  _buildCastItem('Mohamed Farag', 'assets/images/person.png'),
                                  SizedBox(width: 10.w),
                                  _buildCastItem('Mostafa gharib', 'assets/images/persons2.png'),

                                ],
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            ClipRect(
                              child: Image.asset(
                                'assets/images/seriess.png',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.8),
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
                                  height: 62.h,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Episode ${index + 1}',
                                          style: getRegularTitleStyle(
                                            color: ColorsManager.whiteColor,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.play_circle_filled, color: Color(0xff97A6C0), size: 28),
                                            SizedBox(width: 12.w), // Space between icons
                                            Icon(Icons.remove_red_eye, color: Colors.white, size: 28),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.live_tv, 'Live', 0, cubit),
                    _buildNavItem(Icons.movie, 'Movie', 1, cubit),
                    _buildNavItem(Icons.tv, 'Series', 2, cubit),
                    _buildNavItem(Icons.more_horiz, 'More', 3, cubit),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCastItem(String name, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(imageUrl),
        ),
        SizedBox(height: 8.h),
        Center(
          child: Text(
            name,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, BottomNavBarCubit cubit) {
    bool isSelected = cubit.currentIndex == index;
    return GestureDetector(
      onTap: () => cubit.changePage(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? ColorsManager.blackColor : ColorsManager.greyColor),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? ColorsManager.blackColor : ColorsManager.greyColor,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

}
