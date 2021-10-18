import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/layouts/account_qr_layout.dart';
import 'package:collector_app/ui/layouts/login_layout.dart';
import 'package:collector_app/ui/layouts/main_layout.dart';
// import 'package:collector_app/ui/layouts/pending_request_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectorApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
          DeviceConstants.logicalWidth, DeviceConstants.logicalHeight),
      builder: () => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: AppConstants.primaryColor,
          accentColor: AppConstants.accentColor,
        ),
        initialRoute: Routes.initial,
        routes: {
          Routes.login: (_) => const LoginLayout(),

          Routes.main: (_) => const MainLayout(),

          Routes.accountQRCode: (_) => const AccountQRLayout(),
          // Routes.pendingRequests: (_) => const PendingRequestLayout(),
        },
      ),
    );
  }
}
