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
    MovieCubit cubit = MovieCubit.get(context);

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
                                //  _showOverlay(context, cubit);
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
                        child: cubit.movieCategories.isEmpty
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
                          width: 280.w,
                          padding: EdgeInsets.symmetric(horizontal: 5),
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
                              items: cubit.movieCategories
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
                              value: cubit.selectedMovieCategory,
                              onChanged: (String? value) {
                                if (value != null) {
                                  cubit.changeMovieCategory(value);
                                }
                                cubit.toggleDropdown();
                              },
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


            /// Movie Grid
            Expanded(
              child: BlocBuilder<MovieCubit, MovieState>(
                builder: (context, state) {
                  // Handle loading state
                  if (state is MovieLoadingState) {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    );
                  }

                  // Handle no data state
                  if (state is MovieErrorState || cubit.filteredMovies.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Text(
                              'No Movies Found!',
                              style: TextStyle(color: Colors.white, fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Display the GridView with movies
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: cubit.filteredMovies.length, // Use filteredMovies here
                    itemBuilder: (context, index) {
                      final movieItem = cubit.filteredMovies[index];
                     /* final isFavorite = cubit.favoriteMoviesList.any(
                            (item) => item['title'] == movieItem.title,
                      );
                      final isRecent = cubit.recentMoviesList.any(
                            (item) => item['title'] == movieItem.title,
                      );*/

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final movieId = movieItem['id'].toString(); // Ensure movie_id is available

                              if (movieId == null) {
                                print("Movie ID is missing.");
                                return;
                              }

                              // Call getMovieDetails method from MovieCubit
                             // context.read<MovieCubit>().getMovieDetails(movieId);

                             /* final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailsView(movie: movieItem), // Pass the Movie model here
                                ),
                              );

                              // Optionally refresh after interaction
                              if (result != null) {
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
                                  child: movieItem['image'] != null && movieItem['image']!.startsWith('http')
                                      ? Image.network(
                                    movieItem['image']!,
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
                               /* if (isFavorite)
                                  Positioned(
                                    bottom: 10,
                                    right: 5,
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                if (isRecent)
                                  Positioned(
                                    bottom: 10,
                                    left: 5,
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
                              movieItem['title'] ?? 'Unknown',
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


          ],
        );
      },
    );
  }



  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}