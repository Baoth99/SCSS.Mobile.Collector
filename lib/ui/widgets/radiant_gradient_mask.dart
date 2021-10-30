import 'package:collector_app/constants/constants.dart';
import 'package:flutter/material.dart';

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment(0.5, 0.0),
        colors: [
          AppColors.greenFF39AC8F,
          AppColors.greenFF61C53D,
        ],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
