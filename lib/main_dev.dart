import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/firebase_service.dart';
import 'package:collector_app/ui/app.dart';
import 'package:collector_app/utils/env_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  // Load env
  await dotenv.load(fileName: EnvAppSetting.dev);
  configureDependencies();
  final firebase = getIt.get<FirebaseNotification>();
  await firebase.initialize();

  await configLoading();
  runApp(CollectorApp());
}

Future<void> configLoading() async {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.green
    ..textColor = Colors.green
    ..maskType = EasyLoadingMaskType.black
    ..indicatorWidget = Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(width: 60, height: 60, child: CircularProgressIndicator()),
        Image.asset(
          ImagesPaths.collectorLogo,
          height: 40,
          width: 40,
        ),
      ],
    )
    ..userInteractions = false
    ..dismissOnTap = true;
}
