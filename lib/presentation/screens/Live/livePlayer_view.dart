import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'live_viewModel/fav_model.dart';
import 'live_viewModel/live_cubit.dart';
import 'live_viewModel/live_model.dart';
import 'live_viewModel/live_states.dart';

class LivePlayerScreen extends StatefulWidget {
  final int streamId;
  final String name;
  final String streamUrl;
  final String thumbnail;

  LivePlayerScreen({
    required this.streamId,
    required this.name,
    required this.streamUrl,
    required this.thumbnail,
  });

  @override
  _LivePlayerScreenState createState() => _LivePlayerScreenState();
}

class _LivePlayerScreenState extends State<LivePlayerScreen> {
  late BetterPlayerController _betterPlayerController;
  late LiveStream liveStream;


  @override
  void initState() {
    super.initState();

    liveStream = LiveStream(
      streamId: widget.streamId,
      name: widget.name,
      streamUrl: widget.streamUrl,
      thumbnail: widget.thumbnail,
    );



    // Initialize the player
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.streamUrl,
      videoFormat: BetterPlayerVideoFormat.hls,
      liveStream: true,
      headers: {
        "User-Agent": "Mozilla/5.0",
      },
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableSkips: false,
        ),
      ),
      betterPlayerDataSource: dataSource,
    );

  }


  @override
  Widget build(BuildContext context) {
    LiveCubit cubit = LiveCubit.get(context);
    bool isFavorite = cubit.isSeriesFavorite(liveStream.toMap());


    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<LiveCubit, LiveStates>(
        builder: (context, state) {
          return Stack(
            children: [
              BetterPlayer(controller: _betterPlayerController),

              // Back button
              Positioned(
                top: 40,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),

              // Favorite button
              Positioned(
                top: 40,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child:   IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 28,
                    ),
                    onPressed: () async {
                      // Toggle favorite state using Cubit
                      await cubit.toggleFavorite(liveStream.toMap());

                      // Navigate back with updated favorite state
                      Navigator.pop(context, {'isFav': !isFavorite, 'id': liveStream.streamId});
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = LiveCubit.get(context);
    cubit.addToRecent(liveStream.toMap());
  }

}

