import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wish/domian/local/sharedPref.dart';
import 'package:wish/presentation/resources/font-manager.dart';
import 'package:wish/presentation/resources/styles-manager.dart';
import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-button-constant.dart';
import '../../resources/constants/custom-staticwidget.dart';
import '../../resources/constants/custom-textfield-constant.dart';
import '../BottomNav/bottomnavbar_view.dart';
import 'logins_viewModel/login_cubit.dart';

class AddPlaylistScreen extends StatefulWidget {
  const AddPlaylistScreen({super.key});

  @override
  _AddPlaylistScreenState createState() => _AddPlaylistScreenState();
}

class _AddPlaylistScreenState extends State<AddPlaylistScreen> {
  final TextEditingController playlistNameController = TextEditingController();
  final TextEditingController m3uUrlController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isM3USelected = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff1d1d1d), Color(0xff171717), Color(0xFF2e3949)],
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.h),
                // Toggle between M3U and Xtream
                Container(
                  height: 40.h,
                  width: 200.w,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff3E495C),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTabButton('M3U', isM3USelected,
                          () => setState(() => isM3USelected = true)),
                      _buildTabButton('Xtream', !isM3USelected,
                          () => setState(() => isM3USelected = false)),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                _buildInputField(
                  'Playlist Name',
                  playlistNameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Playlist name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                _buildInputField(
                  'M3U URL',
                  m3uUrlController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'URL is required';
                    }
                    if (!value.startsWith('http://') &&
                        !value.startsWith('https://')) {
                      return 'URL must start with http:// or https://';
                    }
                    return null;
                  },
                ),
                if (!isM3USelected) ...[
                  SizedBox(height: 10.h),
                  _buildInputField('User Name', userNameController),
                  SizedBox(height: 10.h),
                  _buildInputField('Password', passwordController),
                ],
                SizedBox(height: 40.h),
                CustomButton(
                    width: 350.w,
                    high: 40.h,
                    txt: 'Add Playlist',
                    fontSize: FontSize.s15.sp,
                    colorTxt: ColorsManager.whiteColor,
                    colorButton: const Color(0xff7384a4),
                    outLineBorder: false,
                    fontWeight: FontWightManager.fontWeightRegular,
                    borderRadius: 5.r,
                    fontFamily: FontManager.fontFamAPP,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final cubit = LoginCubit.get(context);

                        final name = playlistNameController.text.trim();
                        final url = m3uUrlController.text.trim();

                        cubit.addPlaylist(name: name, url: url).then((_) async {
                          await SharedPreferencesHelper.saveData(key: 'playlist_name',value: name);
                          await SharedPreferencesHelper.saveData(key:'playlist_url',value: url);
                          NavAndRemove(ctx: context, screen: BottomNavBar());
                        });
                      }
                    }),
                const Spacer(),
                GestureDetector(
                  onTap: _contactSupport,
                  child: const Text(
                    'Contact us for Support',
                    style: TextStyle(
                      color: Color(0xffD6D6D6),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xffD6D6D6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90.w,
        height: 30.h,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xff3E495C),
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? const Color(0xff3E495C) : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            fontFamily: FontManager.fontFamAPP,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: getMediumTextStyle(
                  color: const Color(0xffD6D6D6), fontSize: 14.sp)),
          SizedBox(height: 10.h),
          CustomTextFormField(
            controller: controller,
            validator: validator,
            colorBorderEnable: Colors.grey,
            colorBorder: const Color(0xff848484),
            fillColor: const Color(0xff242b37),
            cursorColor: Colors.white,
            radius: 9.r,
          ),
        ],
      ),
    );
  }

  void _contactSupport() async {
    final Uri whatsappUrl = Uri.parse("https://wa.me/4571653898");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      final Uri webUrl =
          Uri.parse("https://web.whatsapp.com/send?phone=4571653898");
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch WhatsApp';
      }
    }
  }
}
