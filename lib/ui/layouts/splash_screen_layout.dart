import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/identity_server_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenLayout extends StatelessWidget {
  SplashScreenLayout({
    IdentityServerService? identityServerService,
    Key? key,
  }) : super(key: key) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }
  late final IdentityServerService _identityServerService;

  Future<String> loadFromFuture() async {
    String route = Routes.login;
    var delay = Future.delayed(const Duration(seconds: 3));
    try {
      if (await checkLogin()) {
        route = Routes.main;
      }
    } catch (e) {
      AppLog.error(e);
    }
    await delay;
    return route;
  }

  Future<bool> checkLogin() async {
    var resultRefreshToken = false;
    var accessToken =
        await SharedPreferenceUtils.getString(APIKeyConstants.accessToken);
    var refreshToken =
        await SharedPreferenceUtils.getString(APIKeyConstants.refreshToken);

    if (accessToken != null &&
        refreshToken != null &&
        accessToken.isNotEmpty &&
        refreshToken.isNotEmpty) {
      resultRefreshToken = await futureAppDuration<bool>(
        _identityServerService.refreshToken(),
      );
    }
    return resultRefreshToken;
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      navigateAfterFuture: loadFromFuture(),
      backgroundColor: Colors.white,
      imageBackground: const AssetImage(
        ImagesPaths.splashScreen,
      ),
      loaderColor: Colors.white,
    );
  }
}
