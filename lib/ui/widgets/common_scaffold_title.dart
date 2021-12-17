import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonScaffoldTitle extends StatelessWidget {
  const CommonScaffoldTitle(this.title, {Key? key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: title,
      fontSize: 80.sp,
      color: Colors.black87,
    );
  }
}
