import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors-manager.dart';
import '../font-manager.dart';
import 'custom-text-constant.dart';

class CustomDrawerScreen extends StatelessWidget {
  const CustomDrawerScreen({super.key});

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
              children: const <Widget>[  // Added const here
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/personal.png'),
                ),
                SizedBox(height: 10), // Removed dynamic sizing from here for const support
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: CustomText(
              txt: 'Profile',
              color: ColorsManager.blackColor,
              fontfamily: FontManager.fontFamilyTitle,
              fontWeight: FontWightManager.fontWeightRegular,
              fontSize: FontSize.s16.sp,
            ),
            onTap: () {
              // NormalNav(ctx: context , screen: ProfileView());
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: CustomText(
              txt: 'Logout',
              color: ColorsManager.blackColor,
              fontfamily: FontManager.fontFamilyTitle,
              fontWeight: FontWightManager.fontWeightRegular,
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
