import 'package:collector_app/providers/configs/flavor_config.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/ui/app.dart';
import 'package:collector_app/utils/env_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Load env
  await dotenv.load(fileName: EnvAppSetting.dev);
  // Add Flavor
  FlavorConfiguration.addFlavorConfig(
      EnvBaseAppSettingValue.flavor, Colors.green);
  configureDependencies();
  runApp(MyApp());
}
