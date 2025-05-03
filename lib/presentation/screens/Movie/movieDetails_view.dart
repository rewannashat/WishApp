import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wish/presentation/screens/Movie/movie_viewModel/movie_cubit.dart';
import 'package:wish/presentation/screens/Movie/movie_viewModel/movie_states.dart';
import 'package:wish/presentation/resources/colors-manager.dart';
import 'package:wish/presentation/resources/styles-manager.dart';

import '../../resources/constants/custom-button-constant.dart';
import '../../resources/font-manager.dart';
import 'moviePlayer_view.dart';
import 'movie_viewModel/cast_model.dart';
import 'movie_viewModel/movie_model.dart';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/presentation/screens/Movie/movie_viewModel/movie_cubit.dart';
import 'package:wish/presentation/screens/Movie/movie_viewModel/movie_states.dart';
import 'package:wish/presentation/resources/colors-manager.dart';
import 'package:wish/presentation/resources/styles-manager.dart';

import '../../resources/constants/custom-button-constant.dart';
import '../../resources/font-manager.dart';
import 'movie_viewModel/movie_model.dart';

class MovieDetailScreen extends StatefulWidget {
  final MovieDetailModel movieDetail;
  final int index;


  const MovieDetailScreen(
      {super.key, required this.movieDetail, required this.index});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {

  @override
  void initState() {
    super.initState();


    print('the model ==> ${widget.movieDetail.plot}');

    final castNames = widget.movieDetail.cast
        .split(',')
        .map((e) => e.trim())
        .take(4)
        .toList();
    context.read<MovieCubit>().loadCastData(castNames);

    context.read<MovieCubit>().fetchMovieDetails(widget.movieDetail.streamId.toString());


  }


  @override
  Widget build(BuildContext context) {
    // log('Movie details for: ${movieDetail.name}');


    MovieCubit cubit = MovieCubit.get(context);
    bool isFavorite = cubit.isSeriesFavorite(widget.movieDetail.toMap());
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28,),
          onPressed: () =>
              Navigator.pop(context, {'isFav': isFavorite, 'id': widget.index}),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
              size: 28,
            ),
            onPressed: () async {
              // Toggle favorite state using Cubit
              await cubit.toggleFavorite(widget.movieDetail.toMap());

              // Manually update the favorite state and UI
              setState(() {
                isFavorite = !isFavorite;
              });

              // Optionally, update the UI of the current list or favorite page
              // If you need to update other parts of the UI that depend on favorites
              // You can emit another state or call a method to refresh the data.
            },
          ),
        ],

      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                widget.movieDetail.movieImage != null &&
                    widget.movieDetail.movieImage.isNotEmpty
                    ? Image.network(
                  widget.movieDetail.movieImage ,
                  width: double.infinity,
                  height: 400.h,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                        'assets/images/Asset.png', fit: BoxFit.cover , width:300.w,height: 300.h,);
                  },) :Center(child: Image.asset('assets/images/Asset.png', fit: BoxFit.cover,width:300.w,height: 300.h,)),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child:  Container(
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
                            widget.movieDetail.name,  // Dynamically set the title
                            style: getSemiBoldTextStyle(
                              color: ColorsManager.whiteColor,
                              fontSize: FontSize.s15.sp,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            widget.movieDetail.plot ?? 'No data available at the moment. Please try again later.',  // Dynamically set the description
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
                              ...List.generate(widget.movieDetail.genre.length, (index) {
                                return [
                                  Text(
                                    widget.movieDetail.genre[index], // Display genre dynamically
                                    style: getRegularTextStyle(
                                      color: ColorsManager.whiteColor,
                                      fontSize: FontSize.s12.sp,
                                    ),
                                  ),
                                  if (index < widget.movieDetail.genre.length - 1) // Add "|" only between genres
                                    SizedBox(width: 6.w),
                                  if (index < widget.movieDetail.genre.length - 1)
                                    Text("|", style: TextStyle(color: Colors.white70, fontSize: 14)),
                                  SizedBox(width: 6.w),
                                ];
                              }).expand((x) => x), // Use .expand() to flatten the list
                            ],
                          ),
                          SizedBox(height: 15.h),
                          buildRatingStars(widget.movieDetail.rating),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Center(
              child: Column(
                children: [
                  CustomButton(
                    width: 300,
                    high: 40,
                    txt: 'Watch',
                    fontSize: 15,
                    colorTxt: ColorsManager.whiteColor,
                    colorButton: ColorsManager.buttonColor,
                    outLineBorder: false,
                    fontWeight: FontWeight.w400,
                    borderRadius: 10,
                    onPressed: () {
                      MovieCubit.get(context).initializeMoviePlayer(
                        streamId: widget.movieDetail.streamId,
                        extension: widget.movieDetail.containerExtension,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MoviePlayerScreen(
                                streamId: widget.movieDetail.streamId,
                                extension: widget.movieDetail
                                    .containerExtension,
                              ),
                        ),
                      );

                      //  log('the data will sended ${widget.movieDetail.streamId} == ${widget.movieDetail.containerExtension}');
                    },
                  ),
                  SizedBox(height: 10),
                  CustomButton(
                    width: 300,
                    high: 40,
                    txt: 'Trailer',
                    fontSize: 15,
                    colorTxt: ColorsManager.whiteColor,
                    colorButton: ColorsManager.buttonColor,
                    outLineBorder: false,
                    fontWeight: FontWeight.w400,
                    borderRadius: 10,
                    onPressed: () {
                      // Trigger the fetch details with the movie's ID
                      //  fetchDetails(widget.movieDetail.tmdbId.toString());
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Cast:',
                style: getRegularTextStyle(
                  color: ColorsManager.whiteColor,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            /* Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Director: ${widget.movieDetail.director ?? 'Unknown Director'}',
                style: getRegularTextStyle(
                  color: ColorsManager.whiteColor,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20.h),*/
            SingleChildScrollView(
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
            )
            /* BlocConsumer<MovieCubit, MovieState>(
              listener: (context, state) {},
              builder: (context, state) {
                // Make sure cubit is accessed correctly
                final cubit = BlocProvider.of<MovieCubit>(context);

                if (state is CastLoadingState) {
                  return const Center(
                    child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50.0,
                    ),
                  );
                } else if (state is CastLoadedState) {
                  return SingleChildScrollView(
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
                  );
                }

                return const SizedBox(); // Return an empty box or fallback widget
              },
            )*/

          ],
        ),
      ),
    );
  }

  // Function to build the rating stars based on the rating from API
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
              : AssetImage('assets/images/Asset.png'),
        ),
        SizedBox(height: 5),
        Text(name, style: TextStyle(fontSize: 12.sp, color: Colors.white)),
      ],
    );
  }
}