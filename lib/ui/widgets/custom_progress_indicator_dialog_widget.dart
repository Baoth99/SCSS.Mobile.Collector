import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProgressIndicatorDialog extends StatelessWidget {
  const CustomProgressIndicatorDialog({
    Key? key,
    required this.text,
    this.semanticLabel,
  }) : super(key: key);

  final String text;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: 60.0.w,
            ),
            constraints: BoxConstraints(
              minHeight: 200.0.h,
            ),
            alignment: FractionalOffset.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(
                  value: null,
                  semanticsLabel: semanticLabel,
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 50.w,
                    ),
                    child: CustomText(
                      text: text,
                      fontSize: 50.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
