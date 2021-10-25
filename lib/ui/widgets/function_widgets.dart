import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/arrow_back_button.dart';
import 'package:collector_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FunctionalWidgets {
  static Future<T?> showCustomDialog<T>(BuildContext context,
      [String text = 'Vui lòng đợi...', String? label]) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        child: CustomProgressIndicatorDialog(
          text: text,
          semanticLabel: label,
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
      color: AppColors.greenFF61C53D,
    );
  }

  static Widget getLoadingCircle([Color color = AppColors.greenFF61C53D]) {
    return SpinKitFadingCircle(
      color: color,
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
    );
  }

  static Future<bool?> showErrorSystemRouteButton(
    BuildContext context, {
    String? route,
    bool onWillPopActive = false,
  }) {
    return showDialogCloseRouteButton(
      context,
      CommonApiConstants.errorSystem,
      alertType: AlertType.error,
      route: route,
      onWillPopActive: onWillPopActive,
    );
  }

  static Future<bool?> showDialogCloseRouteButton(
    BuildContext context,
    String title, {
    String? desc,
    AlertType alertType = AlertType.none,
    String buttonTitle = 'Đóng',
    Color? colorButton,
    bool onWillPopActive = false,
    String? route,
  }) {
    return showDialogCloseButton(
      context,
      title,
      desc: desc,
      alertType: alertType,
      buttonTitle: buttonTitle,
      colorButton: colorButton,
      onWillPopActive: onWillPopActive,
      onPressed: () {
        if (route == null) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context)
              .popUntil(ModalRoute.withName(Routes.pendingRequests));
        }
      },
    );
  }

  static Future<bool?> showDialogCloseButton(
    BuildContext context,
    String title, {
    String? desc,
    AlertType alertType = AlertType.none,
    String buttonTitle = 'Đóng',
    Color? colorButton,
    bool onWillPopActive = false,
    required void Function() onPressed,
  }) {
    return Alert(
      closeIcon: Container(),
      context: context,
      type: alertType,
      title: title,
      onWillPopActive: onWillPopActive,
      desc: desc,
      buttons: [
        getDialogButton(
          title: buttonTitle,
          onPressed: onPressed,
          buttonColor: colorButton,
        )
      ],
    ).show();
  }

  static Future<bool?> showDialogTwoButton(
    BuildContext context,
    String desc,
    String yesTitle,
    String noTitle, {
    String title = Symbols.empty,
    AlertType alertType = AlertType.none,
    Color? yesButtonColor,
    Color noButtonColor = Colors.transparent,
    bool isNoButtonBorder = true,
  }) {
    return Alert(
      context: context,
      type: alertType,
      title: title,
      desc: desc,
      buttons: [
        getDialogButton(
          title: noTitle,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          buttonColor: noButtonColor,
          textColor: Colors.grey[700]!,
          isBorder: isNoButtonBorder,
        ),
        getDialogButton(
          title: yesTitle,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          buttonColor: yesButtonColor,
        ),
      ],
    ).show();
  }

  static getDialogButton({
    required String title,
    required void Function() onPressed,
    Color? buttonColor,
    Color textColor = Colors.white,
    double? width,
    bool isBorder = false,
  }) {
    return DialogButton(
      border: isBorder
          ? Border.all(
              color: textColor,
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
      color: buttonColor,
      onPressed: onPressed,
      width: width,
    );
  }
}
