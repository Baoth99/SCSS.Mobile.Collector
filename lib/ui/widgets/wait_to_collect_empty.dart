import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaitToCollectEmpty extends StatelessWidget {
  const WaitToCollectEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
        ),
        child: Column(
          children: [
            Row(children: [
              Container(
                padding: EdgeInsets.only(top: 30.h, left: 45.w),
                child: CustomText(
                  text: 'Yêu cầu chờ thu gom',
                  fontSize: 45.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]),
            Container(
              margin: EdgeInsets.only(top: 80.h, bottom: 20.h),
              child: Image.asset(
                ImagesPaths.noRequestAvailable,
                width: 400.w,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.h, bottom: 80.h),
              child: CustomText(
                text: 'Bạn chưa xác nhận yêu cầu thu gom nào',
                fontSize: 40.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.greyFF939393.withOpacity(1),
              ),
            )
          ],
        ),
      ),
    );
  }
}
