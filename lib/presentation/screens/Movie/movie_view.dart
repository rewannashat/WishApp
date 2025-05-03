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
                                  //_showOverlay(context, cubit);
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
                        child: Container(
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
                              items: cubit.categories!.isEmpty
                                  ? [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Center(
                                    child: Text(
                                      'No Data Available',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ]
                                  : cubit.categories!
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
                              value: cubit.categories!.isEmpty ? null : cubit.selectedCategory,
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
                  )
                ],
              ),
            ),
            SizedBox(height: size.height * 0.03),

            /// Movie Grid
            Expanded(
              child: BlocBuilder<MovieCubit, MovieState>(
                builder: (context, state) {
                  final cubit = context.read<MovieCubit>();


                  // Loading spinner
                  if (state is MovieLoaded) {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    );
                  }

                  // Empty state
                  if (cubit.filteredLive.isEmpty) {
                    return Center(
                      child: Text(
                        'No streams available.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  // Show movie grid
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: cubit.filteredLive.length,
                    itemBuilder: (context, index) {
                      final stream = cubit.filteredLive[index];
                      final movieItem = cubit.filteredLive[index];
                      final isFavorite = cubit.favoriteSeriesList.any(
                            (item) => item['title'] == movieItem.name,
                      );
                      final isRecent = cubit.recentSeriesList.any(
                            (item) => item['title'] == movieItem.name,
                      );


                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final streamId = stream.streamId.toString(); // Extract the movie ID

                              log('the push data ${movieItem.plot}');

                              // تحقق إذا كانت البيانات غير فارغة
                              if (movieItem != null && movieItem.plot != null && movieItem.name != null) {
                                await cubit.fetchMovieDetails(streamId);
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      movieDetail: movieItem,
                                      index: index,
                                    ),
                                  ),
                                );
                              } else {
                                // يمكن إضافة رسالة خطأ أو عملية بديلة هنا إذا كانت البيانات غير صالحة
                                log('Data is invalid or null!');
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
                                  ),
                                  child: stream.movieImage.startsWith('http')
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(AppSize.s15.r),
                                    child: Image.network(
                                      stream.movieImage,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(child: CircularProgressIndicator());
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/Asset.png', fit: BoxFit.cover);
                                      },
                                    ),
                                  )
                                      : Center(child: Image.asset('assets/images/Asset.png',fit: BoxFit.cover,width:300.w,height: 300.h,)),
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
                          Flexible(
                            child: Text(
                              stream.name,
                              textAlign: TextAlign.center,
                              style: getRegularTitleStyle(
                                color: ColorsManager.whiteColor,
                                fontSize: 12.sp,
                              ),
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
            )
          ],
        );
      },
    );
  }

  /*void _showOverlay(BuildContext context, MovieCubit cubit) {
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
  }*/

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}