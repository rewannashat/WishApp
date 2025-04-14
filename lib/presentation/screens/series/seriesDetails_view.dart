import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class SeriesDetailsView extends StatelessWidget {
  final Series series;

  SeriesDetailsView({required this.series});

  @override
  Widget build(BuildContext context) {
    final cubit = SeriesCubit.get(context);
    bool isFavorite = cubit.isSeriesFavorite(series.toMap());
    int episodeCount = series.episodes.isNotEmpty ? series.episodes.length : 1;  // Handle the case if episodes list is empty

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
                              series.imageUrl,
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
                                        items: series.seasons.isNotEmpty
                                            ? series.seasons.map((String season) {
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
                                      await cubit.toggleFavorite(series.toMap());

                                      // Navigate back with updated favorite state
                                      Navigator.pop(context, {'isFav': !isFavorite, 'id': series.seriesId});
                                    },
                                  ),


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
                                        series.title,  // Dynamically set the title
                                        style: getSemiBoldTextStyle(
                                          color: ColorsManager.whiteColor,
                                          fontSize: FontSize.s15.sp,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        series.description,  // Dynamically set the description
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
                                          ...List.generate(series.genre.length, (index) {
                                            return [
                                              Text(
                                                series.genre[index], // Display genre dynamically
                                                style: getRegularTextStyle(
                                                  color: ColorsManager.whiteColor,
                                                  fontSize: FontSize.s12.sp,
                                                ),
                                              ),
                                              if (index < series.genre.length - 1) // Add "|" only between genres
                                                SizedBox(width: 6.w),
                                              if (index < series.genre.length - 1)
                                                Text("|", style: TextStyle(color: Colors.white70, fontSize: 14)),
                                              SizedBox(width: 6.w),
                                            ];
                                          }).expand((x) => x), // Use .expand() to flatten the list
                                        ],
                                      ),
                                      SizedBox(height: 15.h),
                                      buildRatingStars(series.rating),
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
                          /*  SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(cubit.castList.length, (index) {
                                  final cast = cubit.castList[index];
                                  return Row(
                                    children: [
                                      _buildCastItem(cast.name, cast.profileImage),
                                      SizedBox(width: 10.w),
                                    ],
                                  );
                                }),
                              ),
                            )*/



                          ],
                        ),
                        Stack(
                          children: [
                            ClipRect(
                              child: Image.network(
                                series.imageUrl,
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
                              itemCount: (series.episodes != null && series.episodes.isNotEmpty)
                                  ? series.episodes.length
                                  : 1,
                              itemBuilder: (context, index) {
                                if (series.episodes == null || series.episodes.isEmpty) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    height: 80.h,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "No episodes available",
                                        style: getRegularTitleStyle(
                                          color: ColorsManager.whiteColor,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                final episode = series.episodes[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  height: 80.h,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Episode Title
                                        Expanded(
                                          child: Text(
                                            episode.title.isNotEmpty ? episode.title : 'Episode ${index + 1}',
                                            style: getRegularTitleStyle(
                                              color: ColorsManager.whiteColor,
                                              fontSize: 16.sp,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        // Play and View Icons
                                        Row(
                                          children: [
                                            Icon(Icons.play_circle_filled, color: const Color(0xff97A6C0), size: 28),
                                            SizedBox(width: 12.w),
                                            Icon(Icons.remove_red_eye, color: Colors.white, size: 28),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                           /* Stack(
                              children: [
                                ClipRect(
                                  child: Image.asset(
                                    'assets/images/seriess.png',
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
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: (){

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
                                                'Episode ${index + 1}',
                                                style: getRegularTitleStyle(
                                                  color: ColorsManager.whiteColor,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.play_circle_filled, color: Color(0xff97A6C0), size: 28),
                                                  SizedBox(width: 12.w), // Space between icons
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
                            ),*/







                          ],
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

