import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_cubit.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_states.dart';



class SeriesPlayerScreen extends StatefulWidget {
  final String streamId;
  final String extension;

  const SeriesPlayerScreen({
    Key? key,
    required this.streamId,
    required this.extension,
  }) : super(key: key);

  @override
  State<SeriesPlayerScreen> createState() => _SeriesPlayerScreenState();
}

class _SeriesPlayerScreenState extends State<SeriesPlayerScreen> {
  late String streamUrl;


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
          if (state is MoviePlayerInitial || state is SeriesPlayerLoade) {
            return const Center(
              child: SpinKitFadingCircle(
                color: Colors.white,
                size: 50.0,
              ),
            );
          } else if (state is SeriesPlayerLoaded) {
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
          } else if (state is SeriesPlayerError) {
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

  /*@override
  void dispose() {
    // تأكد من إيقاف تشغيل الفيديو عند مغادرة الشاشة
    if (mounted) {
      MovieCubit.get(context).disposePlayer();
    }
    super.dispose();
  }*/
}
