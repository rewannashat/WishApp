import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/domian/Lang/helper_lang.dart';
import 'package:wish/presentation/resources/constants/custom-staticwidget.dart';
import 'package:wish/presentation/resources/font-manager.dart';
import 'package:wish/presentation/resources/values-manager.dart';
import 'package:wish/presentation/screens/series/seriesDetails_view.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_cubit.dart';

import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-textfield-constant.dart';
import '../../resources/styles-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';


class SeriesView extends StatelessWidget {
  const SeriesView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // lang
    Locale myLocale = Localizations.localeOf(context);

    // data
    List<String> items = List.generate(12, (index) => 'أشغال شاقة');


    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background content
            Container(
              color: ColorsManager.transportColor,
              child: Center(
                child: Text(
                  'Background',
                  style: TextStyle(color: Colors.white, fontSize: AppSize.s20.sp),
                ),
              ),
            ),
            // Transparent overlay with blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0), // Fully transparent
              ),
            ),
            // Foreground content
            Column(
              children: [
                SizedBox(height: size.height * 0.05),
                Padding(
                  padding: myLocale.languageCode == 'en'
                      ? EdgeInsets.only(left: AppSize.s15)
                      : EdgeInsets.only(right: AppSize.s15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_back, color: ColorsManager.whiteColor),
                      SizedBox(width: AppSize.s10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                              //  color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(AppSize.s20.r),
                              ),
                              height: size.height * 0.08,
                              width: size.width * 0.8,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(AppSize.s20.r),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: CustomTextFormField(
                                    hintTxt: getTranslated(context, 'Search'),
                                    hintStyle: TextStyle(
                                      fontFamily: FontManager.fontFamilyAPP,
                                      color: ColorsManager.whiteColor,
                                      fontWeight: FontWightManager.fontWeightLight,
                                      fontSize: AppSize.s15.sp,
                                    ),
                                    radius: AppSize.s20.r,
                                    colorBorder: ColorsManager.blackColor,
                                    prefexIcon: Icons.search,
                                    prefexIconColor: ColorsManager.whiteColor,
                                    fillColor: Colors.black.withOpacity(0.2),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: AppSize.s10),
                            BlocBuilder<SeriesCubit, Set<int>>(
                              builder: (context, state) {
                                final cubit = context.read<SeriesCubit>();
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(AppSize.s12.r),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      height: size.height * 0.07,
                                      width: size.width * 0.8,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSize.s15,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(AppSize.s12.r),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          dropdownColor: ColorsManager.blackColor,
                                          isExpanded: true,
                                          value: cubit.selectedCategory,
                                          items: cubit.categories
                                              .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e,
                                              style: getRegularTitleStyle(
                                                  color: ColorsManager.whiteColor,
                                                  fontSize: 12.sp),
                                            ),
                                          ))
                                              .toList(),
                                          onChanged: (newValue) {
                                            if (newValue != null) {
                                              cubit.changeCategory(newValue);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              NormalNav(ctx: context, screen: SeriesDetailsView(index: index));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 100.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(AppSize.s15.r),
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/series.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      context.read<SeriesCubit>().toggleFavorite(index);
                                      toast(
                                        msg: context.read<SeriesCubit>().state.contains(index)
                                            ? 'Added to favorites'
                                            : 'Removed from favorites',
                                        state: StatusCase.SUCCES,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black54,
                                            blurRadius: 6.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                      ),
                                      child: BlocBuilder<SeriesCubit, Set<int>>(
                                        builder: (context, favorites) {
                                          return Icon(
                                            favorites.contains(index)
                                                ? Icons.favorite
                                                : Icons.favorite,
                                            color: favorites.contains(index) ? Colors.red : Colors.white,
                                            size: AppSize.s30.sp,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(items[index],
                              style: getRegularTitleStyle(
                                  color: ColorsManager.whiteColor, fontSize: AppSize.s12.sp)),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );

  }
}
