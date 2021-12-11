import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/arrow_back_button.dart';
import 'package:collector_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

enum rowFlexibleType { smallToBig, bigToSmall }

class FunctionalWidgets {
  static void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(text: text),
      ),
    );
  }

  static Future<T?> showCustomDialog<T>(BuildContext context,
      [String text = 'Vui lòng đợi...', String? label]) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 350.w,
          ),
          backgroundColor: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.white,
            ),
            height: 300.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                    width: 200.r,
                    height: 200.r,
                    child: CircularProgressIndicator()),
                Image.asset(
                  ImagesPaths.collectorLogo,
                  height: 130.r,
                  width: 130.r,
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async => false,
      ),
    );
  }

  static Widget getErrorIcon() {
    return Icon(
      Icons.error,
      size: 180.sp,
      color: AppColors.red,
    );
  }

  static Widget getLoadingAnimation() {
    return const SpinKitRing(
      color: AppColors.greenFF01C971,
    );
  }

  static Future<dynamic> showErrorSystemRouteButton(
    BuildContext context, {
    String title = 'Thông báo',
    String? route,
  }) {
    return showAwesomeDialog(
      context,
      title: title,
      desc: CommonApiConstants.errorSystem,
      dialogType: DialogType.ERROR,
      btnOkText: 'Đóng',
      isOkBorder: true,
      btnOkColor: AppColors.errorButtonBorder,
      textOkColor: AppColors.errorButtonText,
      okRoutePress: route,
    );
  }

  static Widget getLoadingCircle([Color color = AppColors.greenFF01C971]) {
    return SpinKitFadingCircle(
      color: color,
    );
  }

  static Future<T?> showCustomModalBottomSheet<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    String? routeClosed,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0.r),
              topRight: Radius.circular(50.0.r),
            ),
          ),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          constraints: BoxConstraints(
            minHeight: 600.h,
          ),
          child: Container(
            margin: EdgeInsets.only(
              top: 100.h,
            ),
            height: 1700.h,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        title != null
                            ? Container(
                                padding: EdgeInsets.only(
                                  top: 20.h,
                                ),
                                child: CustomText(
                                  text: title,
                                  fontSize: 58.sp,
                                  color: Colors.grey[700],
                                ),
                              )
                            : const SizedBox.shrink(),
                        child,
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (routeClosed != null) {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(routeClosed),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  static AppBar buildAppBar({
    required BuildContext context,
    Color? color,
    Color? backgroundColor,
    double? elevation,
    List<Widget>? action,
    Widget? title,
    bool? centerTitle,
    Container? flexibleSpace,
  }) {
    return AppBar(
      leading: ArrowBackIconButton(
        color: color,
      ),
      elevation: elevation,
      backgroundColor: backgroundColor,
      actions: action,
      title: title,
      centerTitle: centerTitle,
      flexibleSpace: flexibleSpace,
    );
  }

  static Future<dynamic> showAwesomeDialog(
    BuildContext context, {
    String title = 'Thông báo',
    required String desc,
    String btnOkText = 'OK',
    void Function()? btnOkOnpress,
    Color btnOkColor = const Color(0xFF00CA71),
    Color textOkColor = AppColors.white,
    bool isOkBorder = false,
    String? btnCancelText,
    void Function()? btnCancelOnpress,
    Color btnCancelColor = Colors.transparent,
    Color textCancelColor = AppColors.red,
    bool isCancelBorder = true,
    DialogType? dialogType,
    bool dismissBack = true,
    String? okRoutePress,
  }) {
    if (okRoutePress != null && btnOkOnpress != null) {
      throw Exception('showAwesomeDialog: either okRoutePress or btnOkOnpress');
    } else if (okRoutePress != null && btnOkOnpress == null) {
      btnOkOnpress ??= () {
        Navigator.of(context).popUntil(ModalRoute.withName(okRoutePress));
      };
    } else {
      btnOkOnpress ??= () {
        Navigator.of(context).pop();
      };
    }

    btnCancelOnpress ??= () {
      Navigator.of(context).pop();
    };
    return AwesomeDialog(
      context: context,
      title: title,
      desc: desc,
      dialogType: dialogType,
      btnOk: getDialogButton(
        title: btnOkText,
        onPressed: btnOkOnpress,
        buttonColor: btnOkColor,
        textColor: textOkColor,
        isBorder: isOkBorder,
      ),
      btnCancel: btnCancelText != null && btnCancelText.isNotEmpty
          ? getDialogButton(
              title: btnCancelText,
              onPressed: btnCancelOnpress,
              buttonColor: btnCancelColor,
              textColor: textCancelColor,
              isBorder: isCancelBorder,
            )
          : null,
      dismissOnTouchOutside: !dismissBack,
      dismissOnBackKeyPress: !dismissBack,
    ).show();
  }

  static getDialogButton({
    required String title,
    required void Function() onPressed,
    required Color buttonColor,
    Color textColor = Colors.white,
    double? width,
    bool isBorder = false,
  }) {
    return DialogButton(
      border: isBorder
          ? Border.all(
              color: buttonColor,
            )
          : Border.all(
              style: BorderStyle.none,
            ),
      child: CustomText(
        text: title,
        color: textColor,
        fontSize: 50.sp,
        fontWeight: FontWeight.w500,
      ),
      color: isBorder ? Colors.transparent : buttonColor,
      onPressed: onPressed,
      width: width,
    );
  }

  /* Thien */
  static Widget customErrorWidget() {
    return Container(
      child: Center(
        child: Wrap(
          direction: Axis.vertical,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            Text('Đã có lỗi xảy ra'),
          ],
        ),
      ),
    );
  }

  static Widget customText(
      {required String text,
      Alignment? alignment,
      double? fontSize,
      TextAlign? textAlign,
      Color? color,
      double? height,
      TextStyle? textStyle,
      FontWeight? fontWeight}) {
    return Container(
      height: height ?? 50,
      alignment: alignment ?? Alignment.centerLeft,
      child: Text(
        text,
        style: textStyle ??
            TextStyle(
              fontSize: fontSize ?? 15,
              color: color ?? Color.fromARGB(255, 20, 20, 21),
              fontWeight: fontWeight,
            ),
        textAlign: textAlign ?? TextAlign.left,
      ),
    );
  }

  static Row rowFlexibleBuilder(
      smallwidget, largeWidget, rowFlexibleType type) {
    return type == rowFlexibleType.smallToBig
        ? Row(
            children: [
              flexibleSmallBuilder(smallwidget),
              flexibleSpaceBuilder(),
              flexibleLargeBuilder(largeWidget),
            ],
          )
        : Row(
            children: [
              flexibleLargeBuilder(largeWidget),
              flexibleSpaceBuilder(),
              flexibleSmallBuilder(smallwidget),
            ],
          );
  }

  static Flexible flexibleSmallBuilder(widget) {
    return Flexible(
      flex: 28,
      fit: FlexFit.tight,
      child: widget,
    );
  }

  static Flexible flexibleSpaceBuilder() {
    return Flexible(
      flex: 2,
      child: Container(),
    );
  }

  static Flexible flexibleLargeBuilder(widget) {
    return Flexible(
      flex: 70,
      fit: FlexFit.tight,
      child: widget,
    );
  }

  static ElevatedButton customElevatedButton(context, text, action) {
    return ElevatedButton(onPressed: action, child: Text(text));
  }

  static OutlinedButton customSecondaryButton({
    required String text,
    Function()? action,
    MaterialStateProperty<Color?>? textColor,
    MaterialStateProperty<Color?>? backgroundColor,
  }) {
    return OutlinedButton(
      onPressed: action ?? () {},
      child: Text(text),
      style: ButtonStyle(
        foregroundColor: textColor ?? MaterialStateProperty.all(Colors.grey),
        backgroundColor:
            backgroundColor ?? MaterialStateProperty.all(Colors.grey),
      ),
    );
  }

  static OutlinedButton customCancelButton(context, text) {
    return OutlinedButton(
      style:
          ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.grey)),
      onPressed: () => Navigator.pop(context),
      child: Text(text),
    );
  }
  /* Thien */
}
