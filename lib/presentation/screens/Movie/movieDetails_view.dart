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


  const MovieDetailScreen({super.key, required this.movieDetail , required this.index});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {

  @override
  void initState() {
    super.initState();

    final castNames = widget.movieDetail.cast
        .split(',')
        .map((e) => e.trim())
        .take(4)
        .toList();
    context.read<MovieCubit>().loadCastData(castNames);
  }



  @override
  Widget build(BuildContext context) {
   // log('Movie details for: ${movieDetail.name}');

    void fetchDetails(String movieId) {
      context.read<MovieCubit>().fetchMovieDetails(movieId);
    }

    MovieCubit cubit = MovieCubit.get(context);
    bool isFavorite = MovieCubit.get(context).isFavorite(widget.index);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white , size: 28,),
          onPressed: () => Navigator.pop(context, {'isFav': isFavorite, 'id': widget.index}),
        ),
        actions: [
          BlocBuilder<MovieCubit, MovieState>(
            builder: (context, state) {
              final isFavorite = MovieCubit.get(context).isFavorite(widget.index);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  MovieCubit.get(context).toggleFavorite(widget.index);
                },
              );
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
                widget.movieDetail.backdropPath != null && widget.movieDetail.backdropPath.isNotEmpty
                    ? Image.network(
                  widget.movieDetail.backdropPath[0] as String,
                  width: double.infinity,
                  height: 400.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Placeholder(fallbackHeight: 400),
                )
                    : const Placeholder(fallbackHeight: 400), // Fallback if the list is empty or null
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.movieDetail.name ?? 'Unknown Movie',
                          style: getSemiBoldTextStyle(
                            color: ColorsManager.whiteColor,
                            fontSize: FontSize.s15.sp,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.movieDetail.plot ?? 'No plot available',
                          textDirection: TextDirection.rtl,
                          style: getRegularTextStyle(
                            color: ColorsManager.whiteColor,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          widget.movieDetail.genre ?? 'Unknown Genre',
                          style: getRegularTextStyle(
                            color: ColorsManager.whiteColor,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        buildRatingStars(widget.movieDetail.rating),
                      ],
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
                          builder: (_) => MoviePlayerScreen(
                            streamId: widget.movieDetail.streamId,
                            extension: widget.movieDetail.containerExtension,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Director: ${widget.movieDetail.director ?? 'Unknown Director'}',
                style: getRegularTextStyle(
                  color: ColorsManager.whiteColor,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20.h),
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
              : NetworkImage('https://media.giphy.com/media/y1ZBcOGOOtlpC/giphy.gif'),
        ),
        SizedBox(height: 5),
        Text(name, style: TextStyle(fontSize: 12.sp , color: Colors.white)),
      ],
    );
  }
}




