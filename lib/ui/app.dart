import 'package:collector_app/blocs/profile_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/layouts/account_qr_layout.dart';
import 'package:collector_app/ui/layouts/dealer_search_layout.dart';
import 'package:collector_app/ui/layouts/login_layout.dart';
import 'package:collector_app/ui/layouts/main_layout.dart';
import 'package:collector_app/ui/layouts/splash_screen_layout.dart';
// import 'package:collector_app/ui/layouts/pending_request_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectorApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
          DeviceConstants.logicalWidth, DeviceConstants.logicalHeight),
      builder: () => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProfileBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: AppConstants.primaryColor,
            accentColor: AppConstants.accentColor,
          ),
          initialRoute: Routes.initial,
          routes: {
            //Splash screen
            Routes.splashScreen: (_) => SplashScreenLayout(),

            Routes.login: (_) => const LoginLayout(),

            Routes.main: (_) => const MainLayout(),

            Routes.accountQRCode: (_) => const AccountQRLayout(),

            Routes.dealerSearch: (_) => const DealerSearchLayout(),
          },
        ),
      ),
    );
  }
}
