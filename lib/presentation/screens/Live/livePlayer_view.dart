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

  LivePlayerScreen({
    required this.streamId,
    required this.name,
    required this.streamUrl,
  });

  @override
  _LivePlayerScreenState createState() => _LivePlayerScreenState();
}

class _LivePlayerScreenState extends State<LivePlayerScreen> {
  late BetterPlayerController _betterPlayerController;
  late LiveStream series;
  bool isFavorite = false;  // Track the favorite state

  @override
  void initState() {
    super.initState();

    series = LiveStream(
      streamId: widget.streamId,
      name: widget.name,
      streamUrl: widget.streamUrl,
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

    // Load the favorites status after initializing
    _loadFavoriteStatus();
  }

  // Load favorite status from SharedPreferences
  void _loadFavoriteStatus() async {
    // Ensure the Cubit has the latest list of favorites loaded
    await LiveCubit.get(context).loadFavoritesFromPrefs();

    // After favorites are loaded, check if the series is in the favorites list
    bool isFav = LiveCubit.get(context).isSeriesFavorite(series.toMap());
    setState(() {
      isFavorite = isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    LiveCubit cubit = LiveCubit.get(context);

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
                child: GestureDetector(
                  onTap: () async {
                    await cubit.toggleFavorite(series.toMap());

                    // Update the UI after toggling
                    setState(() {
                      isFavorite = !isFavorite;
                    });

                    // Navigate back with updated favorite state
                    Navigator.pop(context, {'isFav': isFavorite, 'id': series.streamId});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 28,
                    ),
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
}

