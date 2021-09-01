import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

class FlavorConfiguration {
  static void addFlavorConfig(String envName, Color color) {
    FlavorConfig(
        name: envName, color: color, location: BannerLocation.topStart);
  }
}
