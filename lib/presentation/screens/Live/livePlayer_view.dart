import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class LivePlayerScreen extends StatefulWidget {
  final String streamUrl;

  LivePlayerScreen({required this.streamUrl});

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
      liveStream: true, // Important for live streaming
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableSkips: false, // No need for skip in live video
        ),
      ),
      betterPlayerDataSource: dataSource,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Stream")),
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