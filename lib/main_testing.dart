import 'package:collector_app/providers/configs/flavor_config.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/firebase_service.dart';
import 'package:collector_app/ui/app.dart';
import 'package:collector_app/utils/env_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: EnvAppSetting.testing);
  // Add Flavor
  FlavorConfiguration.addFlavorConfig(
      EnvBaseAppSettingValue.flavor, Colors.purple);
  configureDependencies();
  final firebase = getIt.get<FirebaseNotification>();
  await firebase.initialize();
  print(await firebase.getToken());
  runApp(CollectorApp());
}
