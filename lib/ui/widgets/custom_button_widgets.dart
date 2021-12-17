import 'package:collector_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.color,
    this.textColor,
    this.padding,
    this.margin,
    this.circularBorderRadius,
  }) : super(key: key);

  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? circularBorderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              fontSize: fontSize,
              color: textColor,
              fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          shadowColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(circularBorderRadius ?? 0.r),
          ),
          primary: color,
          minimumSize: Size(
            width ?? double.minPositive,
            height ?? double.minPositive,
          ),
        ),
      ),
    );
  }
}
