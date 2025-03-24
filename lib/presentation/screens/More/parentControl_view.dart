import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/styles-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';

class ParentControlView extends StatelessWidget {
  const ParentControlView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Parent control',
            style: getRegularTitleStyle(color: Colors.white,
              fontSize: 20.sp,)
        ),
        actions: const [
          Icon(Icons.search, color: Colors.white),
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
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                padding: EdgeInsets.all(16.w),
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
                  children: [
                    Text(
                      'Manage Your Parent Control Password',
                        style: getRegularTitleStyle(color: Colors.white,
                          fontSize: 16.sp,)
                    ),
                    SizedBox(height: 20.h),
                    _buildTextField('Enter Password'),
                    SizedBox(height: 12.h),
                    _buildTextField('Confirm Password'),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () {
                        print('Create Password');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5E6A93),
                        minimumSize: Size(double.infinity, 48.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Create Password',
                          style: getRegularTitleStyle(color: Colors.white,
                            fontSize: 16.sp,)
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return TextField(
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:getRegularTitleStyle(color: Colors.white54,
        fontSize: 13.sp,),
        filled: true,
        fillColor: const Color(0xFF2C3A58),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}