
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domian/end-point.dart';
import '../../../domian/local/sharedPref.dart';
import '../colors-manager.dart';
import '../font-manager.dart';
import 'custom-staticwidget.dart';
import 'custom-text-constant.dart';

class CustomDrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: ColorsManager.bubbleChatColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
             //  imageOfUser == null ?
               CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/personal.png'),
                ), /*: SizedBox(
                 height: 100,
                 width: 100,
                 child: CircleAvatar(
                   backgroundImage:  NetworkImage(imageOfUser!),
                 ),
               ),*/
                SizedBox(height: FontSize.s10.h),
                CustomText(
                  txt: name ?? '',
                  color: ColorsManager.whiteColor,
                  fontfamily: FontManager.fontFamilyAPP,
                  fontWeight: FontWightManager.fontWeightLight,
                  // Fixed typo here
                  fontSize: FontSize.s16.sp,
                ),


              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title:  CustomText(
              txt: 'Profile',
              color: ColorsManager.blackColor,
              fontfamily: FontManager.fontFamilyAPP,
              fontWeight: FontWightManager.fontWeightRegular,
              // Fixed typo here
              fontSize: FontSize.s16.sp,
            ),
            onTap: () {
             // NormalNav(ctx: context , screen: ProfileView());

            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: CustomText(
              txt: 'Logout',
              color: ColorsManager.blackColor,
              fontfamily: FontManager.fontFamilyAPP,
              fontWeight: FontWightManager.fontWeightRegular,
              // Fixed typo here
              fontSize: FontSize.s16.sp,
            ),
            onTap: () async {
             // SharedPreferencesHelper.clearData(key: userIdToken as String);
             // NavAndRemove(ctx: context , screen: RegisterView());
            },
          ),
        ],
      ),
    );
  }


}
