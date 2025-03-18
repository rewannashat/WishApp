import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Live/live_viewModel/live_cubit.dart';
import 'bottomnav_cubit.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit,int>(
      builder: (context, state) {
        final cubit = context.read<BottomNavBarCubit>();
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: BottomNavigationBar(
              currentIndex: state,
              onTap:(index) => cubit.onItemTapped(context, index),
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: state == 0
                      ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Live',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                      : Icon(Icons.live_tv),
                  label: 'Tv Live',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.movie),
                  label: 'Movie',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.tv),
                  label: 'Series',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz),
                  label: 'More',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
