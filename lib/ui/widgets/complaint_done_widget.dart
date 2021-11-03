import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComplaintDoneWidget extends StatelessWidget {
  ComplaintDoneWidget({
    Key? key,
    required this.status,
    required this.sellingFeedback,
    this.adminReply,
  }) : super(key: key);

  final int status;
  final String sellingFeedback;
  final String? adminReply;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: CommonMarginContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _content(
              'Phản hồi của bạn:',
              sellingFeedback,
            ),
            adminReply != null && adminReply!.isNotEmpty
                ? _content(
                    'Hồi đáp từ quản trị viên:',
                    adminReply!,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _content(String title, String content) {
    return Container(
      margin: EdgeInsets.only(
        top: 80.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 50.sp,
            fontWeight: FontWeight.w500,
          ),
          Container(
            padding: EdgeInsets.only(left: 50.w, top: 30.h),
            child: CustomText(
              text: content,
              fontSize: 45.sp,
            ),
          ),
        ],
      ),
    );
  }
}
