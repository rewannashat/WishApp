import 'dart:developer';
import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
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

class _MovieViewState extends State<MovieView>  with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    MovieCubit().loadFavorites();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // This will repeat the animation back and forth

    // Create the pulse animation
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = MovieCubit.get(context);

    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(height: size.height * 0.05),

            /// Search + Dropdown Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  /// Search Bar
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: ColorsManager.whiteColor, size: 30.sp),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: CompositedTransformTarget(
                          link: _layerLink,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _focusNode,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white, fontSize: AppSize.s15.sp),
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  fontFamily: FontManager.fontFamilyAPP,
                                  color: Colors.white,
                                  fontWeight: FontWightManager.fontWeightLight,
                                  fontSize: AppSize.s15.sp,
                                ),
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search, color: Colors.white),
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
                                FocusScope.of(context).unfocus();
                                _removeOverlay();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.s10),

                  /// Dropdown
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 45.w),
                      Expanded(
                        child: cubit.categories.isEmpty
                            ? Container(
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
                        )
                            : Container(
                          height: 40.h,
                          width: 300.w,
                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              value: cubit.selectedCategoryId,
                              items: [
                                // Add the 'fav' category at the start of the list
                                DropdownMenuItem<String>(
                                  value: 'fav',
                                  child: Text(
                                    'Favorite',
                                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                  ),
                                ),
                                // Add other categories after the "Favorite"
                                ...cubit.categories
                                    .where((item) => item['id'] != 'fav') // Avoid adding 'fav' again
                                    .map((item) => DropdownMenuItem<String>(
                                  value: item['id'],
                                  child: Text(
                                    item['name'] ?? '',
                                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                  ),
                                ))
                                    .toList(),
                              ],
                              onChanged: (String? value) {
                                if (value != null) {
                                  if (value == 'fav') {
                                    cubit.changeCategory(value, 'Favorite');
                                    cubit.loadFavorites(); // Ensure favorites are loaded when selected
                                  } else {
                                    final category = cubit.categories.firstWhere((cat) => cat['id'] == value);
                                    cubit.changeCategory(value, category['name']!);
                                  }
                                }
                              },

                              iconStyleData: IconStyleData(
                                icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 24.sp),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )

                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: size.height * 0.03),

            /// Show animation when no favorites
            if (cubit.selectedCategoryId == 'fav' && cubit.favoriteMovies.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        'No Favorites Yet!',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                      SizedBox(height: 10.h),
                  Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value, // Apply the pulse scaling
                          child: SvgPicture.asset(
                            'assets/images/folder-error-svgrepo-com.svg', // Your SVG file path
                            width: 200, // Adjust the size
                            height: 200,
                            color: Colors.white, // Set the color of the SVG if needed
                          ),
                        );
                      },
                    ),),
                    ],
                  ),
                ),
              ),




            /// Movie Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: cubit.selectedCategoryId == 'fav'
                    ? cubit.favoriteMovies.length
                    : cubit.allMovies.length,
                itemBuilder: (context, index) {
                  final movie = cubit.selectedCategoryId == 'fav'
                      ? cubit.favoriteMovies[index]
                      : cubit.allMovies[index];

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final streamId = movie['id'].toString(); // Extract the movie ID
                          try {
                            // Fetch movie details using the streamId
                            final movieDetail = await cubit.fetchMovieDetails(streamId);

                            // Navigate to MovieDetailScreen once movie details are fetched
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailScreen(
                                  movieDetail: movieDetail!,
                                  index: index,
                                ),
                              ),
                            );
                            if (result != null) {
                              setState(() {});
                              log('Updated: isFav = ${result['isFav']}, id = ${result['id']}');
                            }
                          } catch (e) {
                            print('Error fetching movie details: $e');
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
                                  image: (movie['image']?.isNotEmpty ?? false)
                                      ? NetworkImage(movie['image']!)
                                      : const AssetImage('assets/images/movie.png')
                                  as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (cubit.selectedCategoryId == 'fav')
                              const Positioned(
                                bottom: 10,
                                right: 5,
                                child: Icon(Icons.favorite, color: Colors.white, size: 28),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Flexible(
                        child: Text(
                          movie['title'] ?? 'Unknown',
                          style: getRegularTitleStyle(
                            color: ColorsManager.whiteColor,
                            fontSize: AppSize.s12.sp,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
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
          offset: const Offset(0.0, 50.0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 280.w,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: cubit.categories.map((category) {
                  return InkWell(
                    onTap: () {
                      _searchController.text = category['name']!;
                      cubit.changeCategory(category['id']!, category['name']!);
                      _removeOverlay();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        category['name']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
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
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
