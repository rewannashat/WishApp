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
import 'package:wish/presentation/screens/Movie/movie_viewModel/movie_states.dart';

import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-textfield-constant.dart';
import '../../resources/styles-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';
import 'movieDetails_view.dart';
import 'movie_viewModel/movie_cubit.dart';

class MovieView extends StatefulWidget {
  const MovieView({super.key});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // lang
    Locale myLocale = Localizations.localeOf(context);

    // data
    MovieCubit cubit = MovieCubit.get(context);

    // input
    final TextEditingController _searchController = TextEditingController();

    return BlocBuilder<MovieCubit,MovieState>(
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
                                cubit.searchMovies(value);
                                if (value.isNotEmpty) {
                                  _showOverlay(context, cubit);
                                } else {
                                  _removeOverlay();
                                }
                              },
                              onSubmitted: (value) {
                                cubit.searchMovies(value);
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
          Expanded(
            child: BlocBuilder<MovieCubit, MovieState>(
              builder: (context, state) {
                final movies = cubit.selectedCategory == 'Favorite'
                    ? cubit.favoriteMovies
                    : (cubit.filteredMovies.isNotEmpty || _searchController.text.isNotEmpty
                    ? cubit.filteredMovies
                    : cubit.allMovies);
                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    final isFavorite = cubit.isFavorite(index);
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailScreen(index: index),
                              ),
                            );
                            if (result != null) {
                              setState(() {});
                              log('Updated: isFav = ${result['isFav']}, id = ${result['id']}');
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: 130.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(AppSize.s15.r),
                                  image: DecorationImage(
                                    image: AssetImage(movie['image'] ?? 'assets/images/movie.png'),
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
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text( movie['title'] ?? 'Unknown',
                            style: getRegularTitleStyle(
                                color: ColorsManager.whiteColor, fontSize: AppSize.s12.sp)),
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
  void _showOverlay(BuildContext context, MovieCubit cubit) {
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
                children: cubit.categories.map((item) {
                  return InkWell(
                    onTap: () {
                      cubit.changeCategory(item);
                      FocusScope.of(context).unfocus();
                      _removeOverlay();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: item == cubit.selectedCategory
                            ? Colors.grey[700]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      // height: 33.h,
                      width: 280.w,
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Text(
                        item,
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
