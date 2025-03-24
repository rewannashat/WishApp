// /*
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wish/presentation/resources/colors-manager.dart';
// import 'package:wish/presentation/resources/constants/custom-staticwidget.dart';
// import 'package:wish/presentation/resources/constants/custom-textfield-constant.dart';
// import 'package:wish/presentation/resources/font-manager.dart';
// import 'package:wish/presentation/resources/styles-manager.dart';
// import 'package:wish/presentation/resources/values-manager.dart';
// import 'package:wish/presentation/screens/BottomNav/bottomnavbar_view.dart';
// import 'package:wish/presentation/screens/Live/live_viewModel/live_cubit.dart';
// import 'domian/Lang/helper_lang.dart';
//
// class TestView extends StatelessWidget {
//   const TestView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     Locale myLocale = Localizations.localeOf(context);
//
//     // Data
//     List<String> items = List.generate(12, (index) => 'Bein sport');
//
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: Container(
//         padding: EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 20),
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.black,
//               Colors.black87,
//               Colors.black54,
//             ],
//           ),
//         ),
//         child: Column(
//           children: [
//             SizedBox(height: size.height * 0.05),
//             Padding(
//               padding: myLocale.languageCode == 'en'
//                   ? EdgeInsets.only(left: AppSize.s15)
//                   : EdgeInsets.only(right: AppSize.s15),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Icon(Icons.arrow_back, color: ColorsManager.whiteColor),
//                   SizedBox(width: AppSize.s10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomTextFormField(
//                           hintTxt: getTranslated(context, 'Search'),
//                           hintStyle: TextStyle(
//                             fontFamily: FontManager.fontFamilyAPP,
//                             color: ColorsManager.whiteColor,
//                             fontWeight: FontWightManager.fontWeightLight,
//                             fontSize: AppSize.s15.sp,
//                           ),
//                           radius: AppSize.s20.r,
//                           colorBorder: Colors.grey.withOpacity(0.4),
//                           prefexIcon: Icons.search,
//                           prefexIconColor: ColorsManager.whiteColor,
//                           fillColor: Colors.black.withOpacity(0.2),
//                         ),
//                         SizedBox(height: AppSize.s10),
//                         BlocBuilder<LiveCubit, Set<int>>(
//                           builder: (context, state) {
//                             final cubit = context.read<LiveCubit>();
//                             return Container(
//                               height: size.height * 0.07,
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: AppSize.s15,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.black.withOpacity(0.5),
//                                 borderRadius: BorderRadius.circular(AppSize.s12.r),
//                               ),
//                               child: DropdownButtonHideUnderline(
//                                 child: DropdownButton<String>(
//                                   dropdownColor: Colors.black.withOpacity(0.5),
//                                   isExpanded: true,
//                                   value: cubit.selectedCategory,
//                                   items: cubit.categories
//                                       .map((e) => DropdownMenuItem(
//                                     value: e,
//                                     child: Text(
//                                       e,
//                                       style: TextStyle(color: ColorsManager.whiteColor),
//                                     ),
//                                   ))
//                                       .toList(),
//                                   onChanged: (newValue) {
//                                     if (newValue != null) {
//                                       cubit.changeCategory(newValue);
//                                     }
//                                   },
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: size.height * 0.02),
//             Expanded(
//               child: GridView.builder(
//                 padding: EdgeInsets.all(8),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   childAspectRatio: 0.8,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: items.length,
//                 itemBuilder: (context, index) {
//                   return Column(
//                     children: [
//                       Stack(
//                         children: [
//                           Container(
//                             height: 100.h,
//                             width: 100.w,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(AppSize.s15.r),
//                               image: DecorationImage(
//                                 image: AssetImage('assets/images/bein.png'),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 5,
//                             right: 5,
//                             child: GestureDetector(
//                               onTap: () {
//                                 context.read<LiveCubit>().toggleFavorite(index);
//                                 toast(
//                                   msg: context.read<LiveCubit>().state.contains(index)
//                                       ? 'Added to favorites'
//                                       : 'Removed from favorites',
//                                   state: StatusCase.SUCCES,
//                                 );
//                               },
//                               child: BlocBuilder<LiveCubit, Set<int>>(
//                                 builder: (context, favorites) {
//                                   return Icon(
//                                     favorites.contains(index) ? Icons.favorite : Icons.favorite,
//                                     color: favorites.contains(index) ? Colors.red : Colors.white,
//                                     size: AppSize.s30.sp,
//                                   );
//                                 },
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 10.h),
//                       Text(items[index],
//                           style: getRegularTitleStyle(
//                               color: ColorsManager.whiteColor, fontSize: AppSize.s12.sp)),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// */
