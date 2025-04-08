import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/presentation/resources/colors-manager.dart';
import 'package:wish/presentation/resources/constants/custom-staticwidget.dart';
import 'package:wish/presentation/screens/Live/live_view.dart';
import 'package:wish/presentation/screens/More/playList_viewModel/playlists_view.dart';
import 'package:wish/presentation/screens/More/settings_view.dart';

import '../../resources/styles-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';

class MoreView extends StatelessWidget {
  const MoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => {},
        ),
        title: const Text('More', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20 , vertical: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.black87,
              Colors.black54,
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 80.h), // Adjust space for app bar
            _buildListTile(Icons.playlist_play, "Playlist" , () => NormalNav(ctx: context,screen: PlaylistsView())),
            _buildListTile(Icons.settings, "Settings" , () => NormalNav(ctx: context,screen: SettingsView())),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title , Function click) {
    return Column(
      children: [
        GestureDetector(
          onTap:() => click(),
          child: ListTile(
            leading: Icon(icon, color: Colors.white),
            title: Text(title, style: getLightTextStyle(color: ColorsManager.whiteColor , fontSize: 15.sp)),
          ),
        ),
        const Divider(color: Colors.white24, thickness: 1),
      ],
    );
  }
}
