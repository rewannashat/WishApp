import 'dart:developer';
import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
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

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();


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

    return BlocBuilder<SeriesCubit,SeriesState>(
      builder: (context, state) =>  Column(
        children: [
          SizedBox(height: size.height * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: ColorsManager.whiteColor,
                      size: 30.sp,
                    ),
                    onPressed: () => {},
                  ),
                  SizedBox(width: 2.w), // Adjust spacing
                  Expanded(
                    child: CompositedTransformTarget(
                      link: _layerLink,
                      child: Container(
                        // height: 33.h,
                        width: 280.w,
                        margin: EdgeInsetsDirectional.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _searchController,
                              focusNode: _focusNode,
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: ColorsManager.whiteColor,
                                fontSize: AppSize.s15.sp,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  fontFamily: FontManager.fontFamilyAPP,
                                  color: ColorsManager.whiteColor,
                                  fontWeight: FontWightManager.fontWeightLight,
                                  fontSize: AppSize.s15.sp,
                                ),
                                border: InputBorder.none,
                                prefixIcon:
                                Icon(Icons.search, color: Colors.white),
                              ),
                              onChanged: (value) {
                                cubit.searchSeries(value);
                                if (value.isNotEmpty) {
                                  _showOverlay(context, cubit);
                                } else {
                                  _removeOverlay();
                                }
                              },
                              onSubmitted: (value) {
                                cubit.searchSeries(value);  // Perform the search
                                FocusScope.of(context).unfocus(); // Close the keyboard
                                _removeOverlay();  // Close the dropdown
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSize.s10),

              // Dropdown
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 45.w),
                  // Align with search bar start point
                  Expanded(
                    child: Container(
                      height: 40.h,
                      width: 280.w,
                      margin: EdgeInsetsDirectional.symmetric(horizontal: 15),
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5.r)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 24.sp),
                          ),
                          barrierColor: Colors.black.withOpacity(0.5),
                          items: cubit.categories
                              .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(fontSize: 14.sp, color: Colors.white),
                            ),
                          ))
                              .toList(),
                          value: cubit.selectedCategory,
                          onChanged: (String? value) {
                            if (value != null) {
                              cubit.changeCategory(value);
                            }
                            cubit.toggleDropdown();
                          },

                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
          SizedBox(height: size.height * 0.03),
          /////
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
      ),
    );
  }

  void _showOverlay(BuildContext context, SeriesCubit cubit) {
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 310.w,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, 50.0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 280.w,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: cubit.categories.map((category) {  // Use cubit.categories here
                  return InkWell(
                    onTap: () {
                      cubit.changeCategory(category);
                      FocusScope.of(context).unfocus();
                      _removeOverlay();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: category == cubit.selectedCategory
                            ? Colors.grey[700]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      width: 280.w,
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Text(
                        category,  // Display category name
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }


  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }
}
