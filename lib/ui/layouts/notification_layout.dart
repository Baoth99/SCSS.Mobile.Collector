import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/common_scaffold_title.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationLayout extends StatelessWidget {
  const NotificationLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const CommonScaffoldTitle('Thông báo'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
      ),
      body: const CommonMarginContainer(
        child: NotificationBody(),
      ),
    );
  }
}

class NotificationBody extends StatelessWidget {
  const NotificationBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
          top: 20.h,
          bottom: kFloatingActionButtonMargin + 150.h),
        itemBuilder: (context, index) => NotificationElement(
            true,
            'Đơn hàng đã hoàn tất',
            'Đơn hàng tại BachHoaXanh Levanviet đã hoàn tất. Cảm ơn bạn đã chọn Cheapee cho hôm nay !',
            '10 phút trước'),
        separatorBuilder: (context, index) => _divider(),
        itemCount: 11,);
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: Divider(
        thickness: 1.h,
        color: AppColors.greyFFEEEEEE,
      ),
    );
  }
}

class NotificationElement extends StatelessWidget {
  const NotificationElement(
      this.isRead,
      this.title,
      this.content,
      this.time, {
        Key? key,
      }) : super(key: key);

  final bool isRead;
  final String title;
  final String content;
  final String time;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20.w),
            padding: EdgeInsets.all(20.sp),
            decoration: BoxDecoration(
              // color: AppColors.greenFF61C53D.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight, // 10% of the width, so there are ten blinds.
                colors: <Color>[
                  isRead ? AppColors.greenFF39AC8F.withOpacity(0.6) : AppColors.greenFF39AC8F.withOpacity(0.9),
                  isRead ? AppColors.greenFF61C53D.withOpacity(0.6) : AppColors.greenFF61C53D.withOpacity(0.9),
                ], // red to yellow
              ),
            ),
            child: Icon(
              isRead ? Icons.drafts_outlined : Icons.mail_outline_outlined,
              color: AppColors.white
              // isRead ? AppColors.greyFF939393 : AppColors.black,
            ),
          ),
          Container(
            child: const VerticalDivider(color: Colors.white, width: 14),
            margin: EdgeInsets.symmetric(
              horizontal: 10.w,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 47.sp,
                  color: isRead ? AppColors.greyFF939393 : AppColors.black,
                  fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 12.h,
                  ),
                  child: CustomText(
                    text: content,
                    fontWeight: isRead ? FontWeight.w400 : FontWeight.w400,
                    color: isRead ? AppColors.black.withOpacity(0.7) : AppColors.black,
                    fontSize: 37.sp,
                  ),
                ),
                CustomText(
                  text: time,
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}