import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/presentation/resources/colors-manager.dart';
import 'package:wish/presentation/resources/constants/custom-staticwidget.dart';
import 'package:wish/presentation/screens/More/playList_viewModel/playlists_view.dart';

import '../../resources/styles-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';

class ApplicationInfoView extends StatelessWidget {
  const ApplicationInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Application info',
          style: getRegularTitleStyle(color: Colors.white,
            fontSize: 20.sp,)
        ),
        actions:  [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Add search functionality here
            },
          ),
          SizedBox(width: 16),
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
            SizedBox(height: 120.h), // Adjust space for app bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 160.h,
                margin: EdgeInsetsDirectional.symmetric(horizontal: 20 , vertical: 30),
                padding: EdgeInsetsDirectional.symmetric(horizontal: 20 ,),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF121212),
                      Color(0xFF1E1E1E),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoRow('Current application version:', '25536'),
                    SizedBox(height: 12.h),
                    _buildInfoRow('Application version code', '25536'),
                    SizedBox(height: 12.h),
                    _buildInfoRow('Application expiry', '30 Day'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: getRegularTitleStyle(color: Colors.white,
            fontSize: 14.sp,)
        ),
        Text(
          value,
          style: getRegularTitleStyle(color: Colors.white,
            fontSize: 14.sp,)
        ),
      ],
    );
  }
}
