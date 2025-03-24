import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../resources/colors-manager.dart';
import '../Live/live_view.dart';
import '../Movie/movie_view.dart';
import '../Series/series_view.dart';
import '../More/more_view.dart';
import '../Live/live_viewModel/live_cubit.dart';
import 'bottomnav_cubit.dart';
import 'bottomnav_state.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          BottomNavBarCubit cubit = BottomNavBarCubit.get(context);
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black54,
                      Colors.black87,
                      Colors.black54,
                    ],
                  ),
                ),
                child: cubit.screens[cubit.currentIndex],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.live_tv, 'Live', 0, cubit),
                      _buildNavItem(Icons.movie, 'Movie', 1, cubit),
                      _buildNavItem(Icons.tv, 'Series', 2, cubit),
                      _buildNavItem(Icons.more_horiz, 'More', 3, cubit),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, BottomNavBarCubit cubit) {
    bool isSelected = cubit.currentIndex == index;
    return GestureDetector(
      onTap: () => cubit.changePage(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? ColorsManager.blackColor : ColorsManager.greyColor),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? ColorsManager.blackColor : ColorsManager.greyColor,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
