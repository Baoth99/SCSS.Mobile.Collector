import 'package:collector_app/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonMarginContainer extends StatelessWidget {
  const CommonMarginContainer({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalScaffoldMargin.w,
      ),
      child: child,
    );
  }
}
