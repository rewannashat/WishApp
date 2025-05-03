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

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.streamUrl,
      videoFormat: BetterPlayerVideoFormat.hls,
      liveStream: true,
      headers: {"User-Agent": "Mozilla/5.0"},
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(enableSkips: false),
      ),
      betterPlayerDataSource: dataSource,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          BetterPlayer(controller: _betterPlayerController),

          // Back Button
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () {
                _betterPlayerController.pause(); // Pause playback
                _betterPlayerController.dispose(); // Dispose the player
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

          // Favorite Button
          Positioned(
            top: 40,
            right: 16,
            child: BlocBuilder<LiveCubit, LiveStates>(
              builder: (context, state) {
                final cubit = LiveCubit.get(context);
                final isFavorite = cubit.isFavorite(liveStream.name);

                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                    size: 28,
                  ),
                  onPressed: () async {
                    await cubit.toggleFavorite(liveStream.toMap());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose(); // Ensure player is disposed when leaving the screen
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = LiveCubit.get(context);
    cubit.addToRecent(liveStream.toMap()); // Ensure the stream is added to recent list
  }
}



