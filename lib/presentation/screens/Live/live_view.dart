import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domian/Lang/helper_lang.dart';
import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-staticwidget.dart';
import '../../resources/constants/custom-textfield-constant.dart';
import '../../resources/font-manager.dart';
import '../../resources/styles-manager.dart';
import '../../resources/values-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';
import 'live_viewModel/live_cubit.dart';
import 'live_viewModel/live_states.dart';

class LiveView extends StatefulWidget {
  const LiveView({super.key});

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Locale myLocale = Localizations.localeOf(context);

    // Data
    List<String> items = List.generate(12, (index) => 'Bein sport');

    // data
    LiveCubit cubit = LiveCubit.get(context);
    final GlobalKey dropdownKey = GlobalKey();




    // input
    final TextEditingController _searchController = TextEditingController();


    return BlocBuilder<LiveCubit,LiveStates>(
      builder: (context, state) =>  Column(
        children: [
          SizedBox(height: size.height * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: ColorsManager.whiteColor , size: 30.sp,),
                    onPressed: () => {},
                  ),
                  SizedBox(width: 2.w), // Adjust spacing
                  Expanded(
                    child: CompositedTransformTarget(
                      link: _layerLink,
                      child: Container(
                       // height: 33.h,
                        width: 280.w,
                        margin: EdgeInsetsDirectional.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _searchController,
                              focusNode: _focusNode,
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: ColorsManager.whiteColor,
                                fontSize: AppSize.s15.sp,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  fontFamily: FontManager.fontFamilyAPP,
                                  color: ColorsManager.whiteColor,
                                  fontWeight: FontWightManager.fontWeightLight,
                                  fontSize: AppSize.s15.sp,
                                ),
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search, color: Colors.white),
                              ),
                              onChanged: (value) {
                                cubit.searchLive(value);
                                if (value.isNotEmpty) {
                                  _showOverlay(context, cubit);
                                } else {
                                  _removeOverlay();
                                }
                              },
                              onSubmitted: (value) => cubit.searchLive(value),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSize.s10),

              // Dropdown
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 45.w), // Align with search bar start point
                  Expanded(
                    child: Container(
                      height: 40.h,width: 280.w,
                      margin: EdgeInsetsDirectional.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5.r)
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppSize.s15),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.black.withOpacity(0.5),
                                  icon: SizedBox.shrink(),
                                  isExpanded: true,
                                  isDense: true,
                                  alignment: Alignment.bottomCenter,
                                  value: cubit.selectedCategory,
                                  items: cubit.categories.map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Container(
                                      height: 35.h,width: 250.w,
                                      color: cubit.selectedCategory == e && cubit.isDropdownOpen ? Colors.black.withOpacity(0.5) : Colors.transparent,
                                     // padding: EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        e,
                                        style: TextStyle(color: ColorsManager.whiteColor),
                                      ),
                                    ),
                                  )).toList(),
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      cubit.changeCategory(newValue);
                                    }
                                    cubit.toggleDropdown(); // Toggle dropdown state
                                  },
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: cubit.toggleDropdown, // Handle tap on the icon
                            child: Container(
                              width: 40,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              child: Icon(
                                cubit.isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: size.height * 0.03),
          Expanded(
            child: BlocBuilder<LiveCubit,LiveStates>(
              builder: (context, state) {
                final lives = cubit.filteredLive.isNotEmpty || _searchController.text.isNotEmpty
                    ? cubit.filteredLive
                    : cubit.allLive;
                return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: lives.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        height: 130.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              AppSize.s15.r),
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/bein.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(lives[index],
                          style: getRegularTitleStyle(
                              color: ColorsManager.whiteColor,
                              fontSize: AppSize.s12.sp)),
                    ],
                  );
                },
              );
              },
            ),
          ),
        ],
      ),
    );



  }

  void _showOverlay(BuildContext context, LiveCubit cubit) {
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 310.w,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, 50.0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 280.w,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: cubit.filteredLive.map((item) {
                  return InkWell(
                    onTap: () {
                      cubit.changeCategory(item);
                      FocusScope.of(context).unfocus();
                      _removeOverlay();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:item == cubit.selectedCategory ? Colors.grey[700] : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      // height: 33.h,
                      width: 280.w,
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }



}
