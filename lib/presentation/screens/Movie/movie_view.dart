import 'dart:developer';
import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  final TextEditingController _searchController = TextEditingController();

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
                              // Add Favorite category manually at the top
                              DropdownMenuItem<String>(
                                value: 'fav',
                                child: Text(
                                  'Favorite',
                                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                ),
                              ),
                              ...cubit.categories
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
                                  // Handle "Favorite" category separately if needed
                                  cubit.changeCategory(value, 'Favorite');
                                  // You can add logic to load favorite movies here
                                } else {
                                  final category = cubit.categories.firstWhere(
                                          (cat) => cat['id'] == value);
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
                    ),
                  ],
                )

              ],
            ),
          ),

          SizedBox(height: size.height * 0.03),

          if (state is MovieInitial)  Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SpinKitFadingCircle(
                color: Colors.white,
                size: 50.0,
              ),
            ),


          /// Movie Grid
         /* Expanded(
            child: BlocBuilder<MovieCubit, MovieState>(
              builder: (context, state) {
                final isFavorite = cubit.selectedCategoryName == 'Favorite';
                final movies = isFavorite
                    ? cubit.favoriteMovies
                    : (_searchController.text.isNotEmpty || cubit.filteredMovies.isNotEmpty
                    ? cubit.filteredMovies
                    : cubit.allMovies);

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    // Parse movie ID
                    final movieId = int.tryParse(movie['id'] ?? '');
                    final isFav = cubit.isFavorite(index);

                    // Check if the movie ID is valid
                    if (movieId == null || movieId < 0 || movieId >= movies.length) {
                      // Invalid movie ID, use fallback (e.g., the current index)
                      final fallbackIndex = index;
                      final isFav = cubit.isFavorite(fallbackIndex);
                    } else {
                      final isFav = cubit.isFavorite(movieId);
                    }

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
                                    // Pass the movie details to the MovieDetailScreen
                                  ),
                                ),
                              );
                              if (result != null) {
                                setState(() {});
                                log('Updated: isFav = ${result['isFav']}, id = ${result['id']}');
                              }
                            } catch (e) {
                              // Handle any errors (e.g., show an error message if the fetch fails)
                              print('Error fetching movie details: $e');
                              // Optionally, show an error message or retry logic here.
                            }

                            if (movieDetail != null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(
                                    movieDetail: movieDetail,
                                  ),
                                ),
                              );

                              if (result != null) {
                                setState(() {});
                                log('Updated: isFav = ${result['isFav']}, id = ${result['id']}');
                              }
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
                                        : const AssetImage('assets/images/movie.png') as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (isFav)
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
                );
              },
            ),
          )*/
          /// Show animation when no favorites
          if (cubit.selectedCategoryId == 'fav' && cubit.favoriteMovies.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Text(
                    'No Favorites Yet!',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                  SizedBox(height: 10.h),
                  SpinKitFadingCircle(
                    color: Colors.white,
                    size: 50.0,
                  ),
                ],
              ),
            ),

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
                                // Pass the movie details to the MovieDetailScreen
                              ),
                            ),
                          );
                          if (result != null) {
                            setState(() {});
                            log('Updated: isFav = ${result['isFav']}, id = ${result['id']}');
                          }
                        } catch (e) {
                          // Handle any errors (e.g., show an error message if the fetch fails)
                          print('Error fetching movie details: $e');
                          // Optionally, show an error message or retry logic here.
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
          )



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
                children: cubit.categories.map((item) {
                  return InkWell(
                    onTap: () {
                      cubit.changeCategory(item['id']!, item['name']!);
                      FocusScope.of(context).unfocus();
                      _removeOverlay();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: item['id'] == cubit.selectedCategoryId
                            ? Colors.grey[700]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      width: 280.w,
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      child: Text(
                        item['name']!,
                        style: const TextStyle(color: Colors.white, fontSize: 16.0),
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
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }
}