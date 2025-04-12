import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'movie_viewModel/movie_cubit.dart';
import 'movie_viewModel/movie_states.dart';

class MoviePlayerScreen extends StatefulWidget {
  final String streamId;
  final String extension;

  const MoviePlayerScreen({
    Key? key,
    required this.streamId,
    required this.extension,
  }) : super(key: key);

  @override
  State<MoviePlayerScreen> createState() => _MoviePlayerScreenState();
}

class _MoviePlayerScreenState extends State<MoviePlayerScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now you can safely access BlocProvider and other dependencies
    final movieCubit = BlocProvider.of<MovieCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = MovieCubit.get(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<MovieCubit, MovieState>(
        listener: (context, state) {
          // Handle any additional actions when states change
        },
        builder: (context, state) {
          if (state is MoviePlayerInitial || state is MoviePlayerLoade) {
            return const Center(
              child: SpinKitFadingCircle(
                color: Colors.white,
                size: 50.0,
              ),
            );
          } else if (state is MoviePlayerLoaded) {
            return Stack(
              children: [
                Chewie(controller: state.chewieController),
                Positioned(
                  top: 40, // Adjust this value to position your button
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to the previous screen
                    },
                  ),
                ),
              ],
            );
          } else if (state is MoviePlayerError) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Unknown state',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

/*
  @override
  void dispose() {
    // Check if the widget is still mounted
    if (mounted) {
      MovieCubit.get(context).disposePlayer();
    }
    super.dispose();
  }
*/



}
