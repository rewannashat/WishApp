import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domian/Lang/helper_lang.dart';
import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-staticwidget.dart';
import '../../resources/constants/custom-textfield-constant.dart';
import '../../resources/font-manager.dart';
import '../../resources/styles-manager.dart';
import '../../resources/values-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';
import 'live_viewModel/live_cubit.dart';

class LiveView extends StatelessWidget {
  const LiveView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Locale myLocale = Localizations.localeOf(context);

    // Data
    List<String> items = List.generate(12, (index) => 'Bein sport');

    return Column(
      children: [
        SizedBox(height: size.height * 0.05),
        Padding(
          padding: EdgeInsets.only(left: AppSize.s15, right: AppSize.s15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s20.r),
                ),
                child: Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSize.s10),
                        child: Icon(Icons.arrow_back, color: ColorsManager.whiteColor),
                      ),
                      Expanded(
                        child: Container(
                          height: size.height * 0.05,
                          //width: size.width * 0.08,
                          margin: EdgeInsetsDirectional.symmetric(horizontal: 20),
                          child: CustomTextFormField(
                           // hintTxt: getTranslated(context, 'Search'),
                            hintStyle: TextStyle(
                              fontFamily: FontManager.fontFamilyAPP,
                              color: ColorsManager.whiteColor,
                              fontWeight: FontWightManager.fontWeightLight,
                              fontSize: AppSize.s15.sp,
                            ),
                            radius: AppSize.s20.r,
                            colorBorder: Colors.transparent,
                            prefixIcon: Icons.search,
                            prefixIconColor: ColorsManager.whiteColor,
                            fillColor: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSize.s10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s20.r),
                ),
                child: Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSize.s20),
                        child: SizedBox(),
                      ),
                      Expanded(
                        child:BlocBuilder<LiveCubit, Set<int>>(
                          builder: (context, state) {
                            final cubit = context.read<LiveCubit>();
                            return Center(
                              child: Container(
                                height: size.height * 0.05,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: AppSize.s15),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(AppSize.s12.r),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    dropdownColor: Colors.black.withOpacity(0.5),
                                    isExpanded: true,
                                    value: cubit.selectedCategory,
                                    items: cubit.categories
                                        .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: TextStyle(color: ColorsManager.whiteColor),
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
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10),
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    height: 130.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          AppSize.s15.r),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/bein.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(items[index],
                      style: getRegularTitleStyle(
                          color: ColorsManager.whiteColor,
                          fontSize: AppSize.s12.sp)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
