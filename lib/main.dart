import 'package:bloc/bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/presentation/resources/routes-manager.dart';
import 'package:wish/presentation/screens/BottomNav/bottomnav_cubit.dart';
import 'package:wish/presentation/screens/BottomNav/bottomnavbar_view.dart';
import 'package:wish/presentation/screens/Live/live_view.dart';
import 'package:wish/presentation/screens/Live/live_viewModel/live_cubit.dart';
import 'package:wish/presentation/screens/Logins/logins_viewModel/login_cubit.dart';
import 'package:wish/presentation/screens/Logins/splash_view.dart';
import 'package:wish/presentation/screens/More/more_view.dart';
import 'package:wish/presentation/screens/Movie/movie_view.dart';
import 'package:wish/presentation/screens/Movie/movie_viewModel/movie_cubit.dart';
import 'package:wish/presentation/screens/series/series_view.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_cubit.dart';
import 'package:wish/test_view.dart';
import 'domian/Lang/app_locale.dart';
import 'domian/bloc_observer.dart';
import 'domian/local/sharedPref.dart';
import 'package:loader_overlay/loader_overlay.dart';


Future<void> main() async {

  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();
  await SharedPreferencesHelper.init();

  WidgetsFlutterBinding.ensureInitialized();


  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => GlobalLoaderOverlay(
          useDefaultLoading: true,
          child: MyApp()),
    ),);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(360, 690), // Use your design size
      minTextAdapt: true,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LiveCubit()..getLiveCategories(),
        ),
        BlocProvider(
          create: (context) => MovieCubit()..getMovieCategories(),
        ),
        BlocProvider(
          create: (context) => BottomNavBarCubit(),
        ),
        BlocProvider(
          create: (context) => SeriesCubit(),
        ),
        BlocProvider(
          create: (context) => LoginCubit()..login(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),  // To use DevicePreview's locale
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('ar', ''), // Arabic
        ],
        localizationsDelegates: const [
          AppLocale.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: DevicePreview.appBuilder,
        home: SplashView(),
        routes: {
          Routes.movieScreen: (context) => MovieView(),
        },
      ),
    );
  }
}

