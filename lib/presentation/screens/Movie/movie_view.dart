import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/domian/Lang/helper_lang.dart';
import 'package:wish/presentation/resources/constants/custom-staticwidget.dart';
import 'package:wish/presentation/resources/font-manager.dart';
import 'package:wish/presentation/resources/values-manager.dart';
import 'package:wish/presentation/screens/Movie/movie_viewModel/movie_states.dart';

import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-textfield-constant.dart';
import '../../resources/styles-manager.dart';
import '../BottomNav/bottomnavbar_view.dart';
import 'movieDetails_view.dart';
import 'movie_viewModel/movie_cubit.dart';

class MovieView extends StatefulWidget {
  bool? isFav;
  int? id ;

  MovieView({super.key, this.isFav , this.id});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // lang
    Locale myLocale = Localizations.localeOf(context);

    // data
    List<String> items = List.generate(12, (index) => 'رحلة 404');
    MovieCubit cubit = MovieCubit.get(context);
    Set<int> favoriteIds = {};

    log('isFav: ${widget.isFav}, id: ${widget.id}');

    return Column(
      children: [
        SizedBox(height: size.height * 0.05),
        BlocConsumer<MovieCubit, MovieState>(
          listener: (context, state) => {},
          builder: (context, state) => Padding(
            padding: EdgeInsets.only(left: AppSize.s15, right: AppSize.s15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s20.r),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: AppSize.s10),
                          child: Icon(Icons.arrow_back,
                              color: ColorsManager.whiteColor),
                        ),
                        Expanded(
                          child: Container(
                            height: size.height * 0.05,
                            width: double.infinity,
                            child: CustomTextFormField(
                              // hintTxt: getTranslated(context, 'Search'),
                              hintStyle: TextStyle(
                                fontFamily: FontManager.fontFamilyAPP,
                                color: ColorsManager.whiteColor,
                                fontWeight: FontWightManager.fontWeightLight,
                                fontSize: AppSize.s15.sp,
                              ),
                              radius: AppSize.s20.r,
                              colorBorder: Colors.transparent,
                              prefexIcon: Icons.search,
                              prefexIconColor: ColorsManager.whiteColor,
                              fillColor: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSize.s10),
                Center(
                  child: Container(
                    height: size.height * 0.05,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s15),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(AppSize.s12.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.black.withOpacity(0.5),
                        isExpanded: true,
                        value: cubit.selectedCategory,
                        items: cubit.categories
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(
                                color: ColorsManager.whiteColor),
                          ),
                        ))
                            .toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            cubit.changeCategory(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              bool isFavorite = cubit.isFavorite(index);
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(index: index),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          widget.isFav = result['isFav'];
                          widget.id = result['id'];
                        });
                        log('Updated: isFav = ${widget.isFav}, id = ${widget.id}');
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 130.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppSize.s15.r),
                            image: DecorationImage(
                              image: AssetImage('assets/images/movie.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        (widget.isFav == true && widget.id == index)
                            ? Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () {},
                          ),
                        )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(items[index],
                      style: getRegularTitleStyle(
                          color: ColorsManager.whiteColor,
                          fontSize: AppSize.s12.sp)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
