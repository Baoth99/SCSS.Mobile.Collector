import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
    double? fontSize,
    double? height,
    double? width,
    this.color,
  }) : super(key: key) {
    this.fontSize = fontSize ?? 55.sp;
    this.height = height ?? 130.h;
    this.width = width ?? double.infinity;
  }

  final String title;
  final void Function()? onPressed;
  late final double fontSize;
  late final double height;
  late final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: CustomText(
        text: title,
        fontSize: fontSize,
      ),
      style: ElevatedButton.styleFrom(
        primary: color,
        minimumSize: Size(
          width,
          height,
        ),
      ),
    );
  }
}
