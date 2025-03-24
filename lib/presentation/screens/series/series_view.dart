import 'dart:developer';
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
import 'package:wish/presentation/screens/series/seris_viewModel/series_states.dart';

import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-textfield-constant.dart';
import '../../resources/styles-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';

class SeriesView extends StatefulWidget {
  const SeriesView({super.key});

  @override
  State<SeriesView> createState() => _SeriesViewState();
}

class _SeriesViewState extends State<SeriesView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // lang
    Locale myLocale = Localizations.localeOf(context);

    // data
    List<String> items = List.generate(12, (index) => 'أشغال شاقة');

    // data
    SeriesCubit cubit = SeriesCubit.get(context);

    // input
    final TextEditingController _searchController = TextEditingController();

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
                        child: Icon(Icons.arrow_back,
                            color: ColorsManager.whiteColor),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CustomTextFormField(
                            size: Size(double.infinity, size.height * 0.05),
                            controller: _searchController,
                            hintStyle: TextStyle(
                              fontFamily: FontManager.fontFamilyAPP,
                              color: ColorsManager.whiteColor,
                              fontWeight: FontWightManager.fontWeightLight,
                              fontSize: AppSize.s15.sp,
                            ),
                            radius: AppSize.s10.r,
                            colorBorder: Colors.transparent,
                            prefixIcon: Icons.search,
                            prefixIconColor: Colors.white,
                            fillColor: Colors.black.withOpacity(0.5),
                            onSubmitted: (value) => cubit.searchSeries(value),
                            cursorColor: Colors.white,
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
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSize.s20),
                      child: SizedBox(),
                    ),
                    Expanded(
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
                                        style: TextStyle(
                                            color: ColorsManager.whiteColor),
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
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Expanded(
          child: BlocBuilder<SeriesCubit, SeriesState>(
            builder: (context, state) {
              final series = cubit.selectedCategory == 'Favorite'
                  ? cubit.favoriteSeries
                  : (cubit.filteredSeries.isNotEmpty ||
                          _searchController.text.isNotEmpty
                      ? cubit.filteredSeries
                      : cubit.allSeries);
              return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: series.length,
                itemBuilder: (context, index) {
                  final seriess = series[index];
                  final isFavorite = cubit.isFavorite(index);
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SeriesDetailsView(index: index),
                            ),
                          );
                          if (result != null) {
                            setState(() {});
                            log('Updated: isFav = ${result['isFav']}, id = ${result['id']}');
                          }
                        },
                        child: Stack(children: [
                          Container(
                            height: 130.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppSize.s15.r),
                              image: DecorationImage(
                                image: AssetImage(seriess['image'] ??
                                    'assets/images/movie.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (isFavorite)
                            Positioned(
                              bottom: 10,
                              right: 5,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                        ]),
                      ),
                      SizedBox(height: 10.h),
                      Text(seriess['title'] ?? 'Unknown',
                          style: getRegularTitleStyle(
                              color: ColorsManager.whiteColor,
                              fontSize: AppSize.s12.sp)),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
