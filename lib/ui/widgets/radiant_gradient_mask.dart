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
        begin: Alignment.topLeft,
        end: Alignment
            .bottomRight, // 10% of the width, so there are ten blinds.
        colors: <Color>[
          AppColors.greenFF61C53D.withOpacity(0.7),
          AppColors.greenFF39AC8F.withOpacity(0.7),
        ], // red to yellow
        tileMode:
        TileMode.repeated, // repeats the gradient over the canvas
      ).createShader(bounds),
      child: child,
    );
  }
}
