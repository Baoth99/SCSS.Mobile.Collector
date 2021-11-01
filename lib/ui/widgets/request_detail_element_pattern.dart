import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestDetailElementPatternHistory extends StatelessWidget {
  RequestDetailElementPatternHistory({
    Key? key,
    required this.icon,
    required this.title,
    this.titleColor = Colors.grey,
    required this.child,
    double? contentLeftMargin,
  }) : super(key: key) {
    this.contentLeftMargin = contentLeftMargin ?? 80.w;
  }

  final IconData icon;
  final String title;
  final Color titleColor;
  final Widget child;
  late final double contentLeftMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 25.h,
        horizontal: 50.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: AppColors.greenFF61C53D,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 50.w,
                  ),
                  child: CustomText(
                    text: title,
                    fontSize: 36.sp,
                    color: titleColor,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20.h,
              left: contentLeftMargin,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
