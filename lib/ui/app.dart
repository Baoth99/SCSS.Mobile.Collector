import 'package:collector_app/blocs/home_bloc.dart';
import 'package:collector_app/blocs/profile_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/layouts/account_qr_layout.dart';
import 'package:collector_app/ui/layouts/approved_requests_layout.dart';
import 'package:collector_app/ui/layouts/dealer_map_layout.dart';
import 'package:collector_app/ui/layouts/dealer_search_layout.dart';
import 'package:collector_app/ui/layouts/dealer_transaction_detail_layout.dart';
import 'package:collector_app/ui/layouts/forget_password_new_password_layout.dart';
import 'package:collector_app/ui/layouts/forget_password_otp_layout.dart';
import 'package:collector_app/ui/layouts/forget_password_phone_number_layout.dart';
import 'package:collector_app/ui/layouts/login_layout.dart';
import 'package:collector_app/ui/layouts/main_layout.dart';
import 'package:collector_app/ui/layouts/pending_request_detail_layout.dart';
import 'package:collector_app/ui/layouts/pending_request_layout.dart';
import 'package:collector_app/ui/layouts/profile_password_edit_layout.dart';
import 'package:collector_app/ui/layouts/seller_transaction_detail_layout.dart';
import 'package:collector_app/ui/layouts/splash_screen_layout.dart';
import 'package:collector_app/ui/layouts/view_image_layout.dart';
// import 'package:collector_app/ui/layouts/pending_request_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectorApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
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
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
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
            Routes.dealerMap: (_) => const DealerMapLayout(),
            Routes.pendingRequests: (_) => const PendingRequestLayout(),
            Routes.pendingRequestDetail: (_) =>
                const PendingRequestDetailLayout(),
            Routes.viewImage: (_) => const ViewImageLayout(),
            Routes.approvedRequests: (_) => const ApprovedRequestLayout(),
            Routes.profilePasswordEdit: (_) =>
                const ProfilePasswordEditLayout(),
            Routes.forgetPasswordPhoneNumber: (_) =>
                const ForgetPasswordPhoneNumberLayout(),
            Routes.forgetPasswordOTP: (_) => const ForgetPasswordOTPLayout(),
            Routes.forgetPasswordNewPassword: (_) =>
                const ForgetPasswordNewPasswordLayout(),
            Routes.sellerTransactionDetail: (_) =>
                const SellerTransactionDetailLayout(),
            Routes.dealerTransactionDetail: (_) =>
                const DealerTransactionDetailLayout(),
          },
        ),
      ),
    );
  }
}
