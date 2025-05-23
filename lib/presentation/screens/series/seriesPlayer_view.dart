import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_cubit.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_details_model.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_states.dart';

class SeriesPlayerScreen extends StatefulWidget {
  final String streamId;
  final String extension;
  final Series series;

  const SeriesPlayerScreen({
    Key? key,
    required this.streamId,
    required this.extension,
    required this.series,
  }) : super(key: key);

  @override
  State<SeriesPlayerScreen> createState() => _SeriesPlayerScreenState();
}

class _SeriesPlayerScreenState extends State<SeriesPlayerScreen> {
  String? streamUrl; // Make it nullable to avoid LateInitializationError
  ChewieController? _chewieController; // Declare a ChewieController

  @override
  Widget build(BuildContext context) {
    final cubit = SeriesCubit.get(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<SeriesCubit, SeriesState>(
        listener: (context, state) {
          // Handle any additional actions when states change
          if (state is SeriesPlayerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading video: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          // Display loading spinner if state is MoviePlayerInitial or SeriesPlayerLoade
          if (state is MoviePlayerInitial || state is SeriesPlayerLoade) {
            return const Center(
              child: SpinKitFadingCircle(
                color: Colors.white,
                size: 50.0,
              ),
            );
          }

          // Display video player only if the video has been successfully loaded
          else if (state is SeriesPlayerLoaded) {
            streamUrl = state.chewieController.videoPlayerController.dataSource;
            _chewieController = state.chewieController; // Assign ChewieController

            return Stack(
              children: [
                Chewie(controller: _chewieController!),
                Positioned(
                  top: 40, // Adjust this value to position your button
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // Stop the video when navigating back
                      _chewieController?.videoPlayerController.pause();
                      Navigator.pop(context); // Navigate back to the previous screen
                    },
                  ),
                ),
              ],
            );
          }

          // Handle error state (if there's an issue loading the video)
          else if (state is SeriesPlayerError) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // Fallback for unknown states (if any)
          else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = SeriesCubit.get(context);
    cubit.addToRecent(widget.series.toMap());
  }

/*@override
  void dispose() {
    // Dispose of the ChewieController when the screen is disposed to stop the video
    _chewieController?.dispose();
    super.dispose();
  }*/
}
