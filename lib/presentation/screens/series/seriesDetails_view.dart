import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/presentation/screens/series/seriesPlayer_view.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_cubit.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_details_model.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_states.dart';

import '../../../domian/Lang/helper_lang.dart';
import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-button-constant.dart';
import '../../resources/font-manager.dart';
import '../../resources/styles-manager.dart';
import '../BottomNav/bottomnav_cubit.dart';
import '../BottomNav/bottomnav_state.dart';
import '../BottomNav/bottomnavbar_view.dart';

class SeriesDetailsView extends StatefulWidget {
  final Series series;

  SeriesDetailsView({required this.series});

  @override
  State<SeriesDetailsView> createState() => _SeriesDetailsViewState();
}

class _SeriesDetailsViewState extends State<SeriesDetailsView> {


  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final castNames = widget.series.cast
          .expand((e) => e.name.split(','))
          .map((name) => name.trim())
          .take(4)
          .toList();

      context.read<SeriesCubit>().loadCastData(castNames);
    });
  }
  @override
  Widget build(BuildContext context) {
    final cubit = SeriesCubit.get(context);
    bool isFavorite = cubit.isSeriesFavorite(widget.series.toMap());
    int episodeCount = widget.series.episodes.isNotEmpty ? widget.series.episodes.length : 1;  // Handle the case if episodes list is empty




    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black87,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            // Use the dynamic image from series data
                            Image.network(
                              widget.series.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              margin: const EdgeInsetsDirectional.symmetric(vertical: 20),
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: ColorsManager.whiteColor,
                                      size: 30.sp,
                                    ),
                                    onPressed: () => {
                                      Navigator.pop(context)
                                    },
                                  ),
                                  // Season Dropdown
                                  Container(
                                    height: 30.h,
                                    width: 250.w,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        dropdownColor: Colors.black.withOpacity(0.5),
                                        isExpanded: true,
                                        value: cubit.selectedSeason,
                                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                        style: const TextStyle(color: Colors.white),
                                        items: widget.series.seasons.isNotEmpty
                                            ? widget.series.seasons.map((String season) {
                                          return DropdownMenuItem<String>(
                                            value: season,
                                            child: Text(
                                              season,
                                              style: getRegularTitleStyle(
                                                color: ColorsManager.whiteColor,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          );
                                        }).toList()
                                            : [
                                          DropdownMenuItem<String>(
                                            value: '',
                                            child: Text(
                                              'No Seasons Available',
                                              style: getRegularTitleStyle(
                                                color: ColorsManager.whiteColor,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            cubit.changeSeason(newValue);  // Update the season in cubit
                                          }
                                        },

                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: () async {
                                      // Toggle favorite state using Cubit
                                      await cubit.toggleFavorite(widget.series.toMap());

                                      // Manually update the favorite state and UI
                                      setState(() {
                                        isFavorite = !isFavorite;
                                      });

                                      // Optionally, update the UI of the current list or favorite page
                                      // If you need to update other parts of the UI that depend on favorites
                                      // You can emit another state or call a method to refresh the data.
                                    },
                                  )


                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.7),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.series.title,  // Dynamically set the title
                                        style: getSemiBoldTextStyle(
                                          color: ColorsManager.whiteColor,
                                          fontSize: FontSize.s15.sp,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        widget.series.description,  // Dynamically set the description
                                        textDirection: TextDirection.rtl,
                                        style: getRegularTextStyle(
                                          color: ColorsManager.whiteColor,
                                          fontSize: FontSize.s12.sp,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ...List.generate(widget.series.genre.length, (index) {
                                            return [
                                              Text(
                                                widget.series.genre[index], // Display genre dynamically
                                                style: getRegularTextStyle(
                                                  color: ColorsManager.whiteColor,
                                                  fontSize: FontSize.s12.sp,
                                                ),
                                              ),
                                              if (index < widget.series.genre.length - 1) // Add "|" only between genres
                                                SizedBox(width: 6.w),
                                              if (index < widget.series.genre.length - 1)
                                                Text("|", style: TextStyle(color: Colors.white70, fontSize: 14)),
                                              SizedBox(width: 6.w),
                                            ];
                                          }).expand((x) => x), // Use .expand() to flatten the list
                                        ],
                                      ),
                                      SizedBox(height: 15.h),
                                      buildRatingStars(widget.series.rating),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cast',
                              style: getRegularTitleStyle(
                                  color: ColorsManager.whiteColor,
                                  fontSize: 20.sp),
                            ),
                            SizedBox(height: 12.h),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(cubit.castList.length, (index) {
                                  final cast = cubit.castList[index];
                                  return Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: _buildCastItem(cast.name, cast.profileImage),
                                  );
                                }),
                              ),
                            )
                          ],
                        ),
                        BlocBuilder<SeriesCubit, SeriesState>(
                          builder: (context, state) {
                            if (state is SeriesLoadingState) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is SeriesErrorState) {
                              return Center(child: Text(state.error));
                            } else if (state is SeriesDetailsLoadedState) {

                              final series = state.series;  // Get the series details here
                              return Stack(
                                children: [
                                  ClipRect(
                                    child: Image.network(
                                      series.imageUrl,  // Load the image from the series data
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(16),
                                    itemCount: series.episodes.length,  // Use episodes length from the series data
                                    itemBuilder: (context, index) {
                                      final episode = series.episodes[index];
                                      return GestureDetector(
                                        onTap: () {
                                          SeriesCubit.get(context).initializeMoviePlayer(
                                            streamId: episode.id.toString(),
                                            extension: episode.containerExtension,
                                          );

                                          print('the data clicked ${episode.containerExtension} === ${episode.id.toString()}');
                                          if (episode.containerExtension.isEmpty || episode.id.toString().isEmpty) {
                                            print('One or both values are empty!');
                                          }


                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SeriesPlayerScreen(
                                                streamId: episode.id.toString(),
                                                extension: episode.containerExtension,
                                                series: series, // Pass the whole Series object
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 12),
                                          height: 62.h,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(5.r),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Episode ${episode.episodeNum}',
                                                  style: getRegularTitleStyle(
                                                    color: ColorsManager.whiteColor,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.play_circle_filled, color: Color(0xff97A6C0), size: 28),
                                                    SizedBox(width: 12.w),
                                                    Icon(Icons.remove_red_eye, color: Colors.white, size: 28),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return Center(child: Text("No data available"));
                            }
                          },
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRatingStars(String rating) {
    // Convert the rating string to an integer
    int ratingValue = int.tryParse(rating) ?? 0;

    // Create a list of icons based on the rating value
    List<Widget> stars = List.generate(5, (index) {
      if (index < ratingValue) {
        return Icon(Icons.star, color: Colors.amber); // Filled star
      } else {
        return Icon(Icons.star_border, color: Colors.amber); // Empty star
      }
    });

    // Return a Row with the star icons
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: stars,
    );
  }

  Widget _buildCastItem(String name, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : NetworkImage('https://media.giphy.com/media/y1ZBcOGOOtlpC/giphy.gif'),
        ),
        SizedBox(height: 5),
        Text(name, style: TextStyle(fontSize: 12.sp , color: Colors.white)),
      ],
    );
  }
}