import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domian/Lang/helper_lang.dart';
import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-staticwidget.dart';
import '../../resources/constants/custom-textfield-constant.dart';
import '../../resources/font-manager.dart';
import '../../resources/styles-manager.dart';
import '../../resources/values-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';
import 'livePlayer_view.dart';
import 'live_viewModel/live_cubit.dart';
import 'live_viewModel/live_states.dart';

class LiveView extends StatefulWidget {
  const LiveView({super.key});

  @override
  State<LiveView> createState() => _LiveViewState();
}


class _LiveViewState extends State<LiveView> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cubit = LiveCubit.get(context);

    return BlocBuilder<LiveCubit, LiveStates>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(height: size.height * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(cubit),
                SizedBox(height: AppSize.s10),
                _buildDropdown(cubit),
              ],
            ),
            SizedBox(height: size.height * 0.03),
            _buildStreamGrid(cubit, state),
            if (state is GetStreamsLoadingState || state is GetCategoriesLoadingState)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SpinKitFadingCircle(
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(LiveCubit cubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ColorsManager.whiteColor,
            size: 30.sp,
          ),
          onPressed: () {},
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              width: 280.w,
              margin: EdgeInsetsDirectional.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withOpacity(0.5),
              ),
              child: TextField(
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
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(LiveCubit cubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 45.w),
        Expanded(
          child: Container(
            height: 40.h,
            width: 280.w,
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 24.sp),
                ),
                barrierColor: Colors.black.withOpacity(0.5),
                items: cubit.categories!.isEmpty
                    ? [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Center(
                      child: Text(
                        'No Data Available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]
                    : cubit.categories!
                    .map(
                      (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  ),
                )
                    .toList(),
                value: cubit.categories!.isEmpty ? null : cubit.selectedCategory,
                onChanged: (String? value) {
                  if (value != null) {
                    cubit.changeCategory(value);
                  }
                  cubit.toggleDropdown();
                },

              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildStreamGrid(LiveCubit cubit, LiveStates state) {

    if (state is GetStreamsLoadingState || cubit.filteredLive.isEmpty) {
      return Center(
        child: state is GetStreamsLoadingState
            ? SpinKitFadingCircle(
          color: Colors.white,
          size: 50.0,
        )
            : Text('No streams available.', style: TextStyle(color: Colors.white)),
      );
    }

    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: cubit.filteredLive.length,
        itemBuilder: (context, index) {
          final stream = cubit.filteredLive[index];
          final isFavorite = cubit.favoriteLiveList.any(
                (item) => item['title'] == stream.name,
          );
          final isRecent = cubit.recentLiveList.any(
                (item) => item['title'] == stream.name,
          );

          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  final streamUrl =
                      'http://tgdns4k.com:8080/live/6665e332412/12977281747688/${stream.streamId}.m3u8';


                  // Navigate to the live player screen
                  NormalNav(
                    ctx: context,
                    screen: LivePlayerScreen(
                      streamId: stream.streamId,
                      name: stream.name,
                      streamUrl: streamUrl,
                      thumbnail: stream.thumbnail.toString(),
                    ),
                  );

                },
                child: Stack(
                  children: [
                    Container(
                      height: 130.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppSize.s15.r),
                      ),
                      child: stream.thumbnail != null && stream.thumbnail!.startsWith('http')
                          ? Image.network(
                        stream.thumbnail!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/Asset.png');
                        },
                      )
                          : Image.asset('assets/images/Asset.png', fit: BoxFit.cover),
                    ),
                    if (isFavorite)
                      Positioned(
                        bottom: 10,
                        right: 5,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 28,
                        ),
                      ),
                    if (isRecent)
                      Positioned(
                        bottom: 10,
                        right: 5,
                        child: Icon(
                          Icons.history,
                          color: Colors.green,
                          size: 28,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Flexible(
                child: Text(
                  stream.name,
                  textAlign: TextAlign.center,
                  style: getRegularTitleStyle(
                    color: ColorsManager.whiteColor,
                    fontSize: 12.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}
