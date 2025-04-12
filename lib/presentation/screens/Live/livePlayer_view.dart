import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'live_viewModel/fav_model.dart';
import 'live_viewModel/live_cubit.dart';
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

  @override
  void initState() {
    super.initState();

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Stream"),
        actions: [
          BlocBuilder<LiveCubit, LiveStates>(
            builder: (context, state) {
              final cubit = LiveCubit.get(context);
              final isFav = cubit.isFavorite(widget.streamId);

              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  final favItem = FavoriteStream(
                    streamId: widget.streamId,
                    name: widget.name,
                    url: widget.streamUrl,
                  );
                  cubit.toggleFavorite(favItem);
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: BetterPlayer(controller: _betterPlayerController),
      ),
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }
}
