import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/presentation/resources/colors-manager.dart';

import '../../resources/styles-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';

class PlaylistsView extends StatelessWidget {
  const PlaylistsView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> playlists = [
      {'title': 'Playlist 1', 'status': 'Currently Online', 'statusColor': Colors.green},
      {'title': 'Playlist 2', 'status': 'Currently Offline', 'statusColor': Colors.red},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Playlists',
          style: getSemiBoldTextStyle(
            color: ColorsManager.whiteColor,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          const Icon(Icons.search, color: Colors.white),
          SizedBox(width: 16.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: playlists.length + 1,
                itemBuilder: (context, index) {
                  if (index == playlists.length) {
                    // Add new playlist button
                    return GestureDetector(
                      onTap: () {
                        print('Add new playlist');
                      },
                      child: Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff4f4e4e),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1C1C1E), Color(0xFF26262A), Color(0xFF3E3E45)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.add, color: Color(0xff4f4e4e), size: 40.sp),
                        ),
                      ),
                    );
                  } else {
                    final playlist = playlists[index];
                    final title = playlist['title'];
                    final status = playlist['status'];
                    final statusColor = playlist['statusColor'];

                    return Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff4f4e4e),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                        gradient: const LinearGradient(
                          colors: [Colors.black, Colors.black87],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Play Icon
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white.withOpacity(0.2),
                            size: 50.sp,
                          ),
                          // Text Column
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: getRegularTitleStyle(color: ColorsManager.whiteColor , fontSize: 16.sp)
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                status,
                                style: getRegularTitleStyle(color: statusColor , fontSize: 12.sp)
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: BottomNavBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
