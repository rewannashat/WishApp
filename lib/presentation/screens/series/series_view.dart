import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
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
import '../Live/live_view.dart';

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
                    onPressed: () => {
                      NormalNav(ctx: context , screen: LiveView()),
                    },
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
                              /*  cubit.searchSeries(value);
                                if (value.isNotEmpty) {
                                  _showOverlay(context, cubit);
                                } else {
                                  _removeOverlay();
                                }*/
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
                  Expanded(
                    child: cubit.categories.isEmpty ? Container(
                      height: 40.h,
                      width: 280.w,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<Map<String, dynamic>>(
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
                          items: [
                            DropdownMenuItem<Map<String, dynamic>>(
                              value: null,
                              child: Text(
                                'No Data Available',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                          value: null,
                          onChanged: null,
                        ),
                      ),
                    ) :
                    Container(
                      height: 40.h,
                      width: 280.w,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
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
                              .map(
                                (String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(fontSize: 14.sp, color: Colors.white),
                              ),
                            ),
                          )
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
            child: RefreshIndicator(
              color: Colors.white,
              backgroundColor: Colors.black,
              onRefresh: () async {
                await cubit.refreshSeries();
              },
              child: BlocBuilder<SeriesCubit, SeriesState>(
                builder: (context, state) {
                  // Handle loading state
                  if (state is SeriesLoadingState) {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    );
                  }

                  // Handle no data state
                  if (state is SeriesErrorState || cubit.filteredSeries.isEmpty ) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                              SpinKitFadingCircle(
                              color: Colors.white,
                              size: 50.0,
                            ),
                            Text(
                              'No Series Found!',
                              style: TextStyle(color: Colors.white, fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is SeriesLoadingState) {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    );
                  }
                  // Display the GridView with series
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: cubit.filteredSeries.length, // Use filteredSeries here
                    itemBuilder: (context, index) {
                      final seriesItem = cubit.filteredSeries[index];
                      final isFavorite = cubit.favoriteSeriesList.any(
                            (item) => item['title'] == seriesItem.title,
                      );
                      final isRecent = cubit.recentSeriesList.any(
                            (item) => item['title'] == seriesItem.title,
                      );

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final seriesId = seriesItem.seriesId; // Ensure series_id is available
                              final serieeposid = seriesItem.episodes.toString() ;

                              print('here $serieeposid');

                              if (seriesId == null) {
                                print("Series ID is missing.");
                                return;
                              }

                              // Call getSeriesDetails method from SeriesCubit
                             // context.read<SeriesCubit>().getSeriesDetails(seriesId);
                              // Debug: print all cast member names
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: context.read<SeriesCubit>(),
                                    child: SeriesDetailsView(series: seriesItem),
                                  ),
                                ),
                              );
                              /*final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SeriesDetailsView(series: seriesItem), // Pass the Series model here
                                ),
                              );*/

                              /* if (result != null) {
                                cubit.loadFavoritesFromPrefs(); // Refresh lists after interaction
                              }*/
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 130.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(AppSize.s15.r),
                                  ),
                                  child: seriesItem.imageUrl != null && seriesItem.imageUrl!.startsWith('http')
                                      ? Image.network(
                                    seriesItem.imageUrl!,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child; // Show the image when it's loaded
                                      }
                                      return Center(child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/images/Asset.png'); // Fallback image URL
                                    },
                                  )
                                      : Image.asset('assets/images/Asset.png', fit: BoxFit.cover), // Default local image
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
                               /* if (isRecent)
                                  Positioned(
                                    bottom: 10,
                                    right: 5,
                                    child: Icon(
                                      Icons.history,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),*/
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Flexible(
                            child: Text(
                              seriesItem.title ?? 'Unknown',
                              style: getRegularTitleStyle(
                                color: ColorsManager.whiteColor,
                                fontSize: AppSize.s12.sp,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          )







        ],
      ),
    );
  }

  void _showOverlay(BuildContext context, SeriesCubit cubit) {
    _removeOverlay(); // Remove previous overlay if exists

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width * 0.9,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height * 0.1), // adjust based on where you want the overlay to appear
            child: Material(
              elevation: 4.0,
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cubit.filteredSeries.length,
                itemBuilder: (context, index) {
                  final item = cubit.filteredSeries[index];
                  return ListTile(
                    leading: item.imageUrl != null && item.imageUrl!.startsWith('http')
                        ? Image.network(item.imageUrl!, width: 40, height: 60, fit: BoxFit.cover)
                        : Image.asset('assets/images/movie.png', width: 40, height: 60),
                    title: Text(
                      item.title ?? 'Unknown',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () async {
                      FocusScope.of(context).unfocus(); // close keyboard
                      _removeOverlay();
                      context.read<SeriesCubit>().getSeriesDetails(item.seriesId!);

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeriesDetailsView(series: item),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _removeOverlay(); // remove overlay safely
    super.dispose();
  }

}