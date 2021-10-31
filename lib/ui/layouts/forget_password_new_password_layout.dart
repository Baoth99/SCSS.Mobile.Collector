// ignore: import_of_legacy_library_into_null_safe
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collector_app/blocs/forget_password_new_password_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

class ForgetPasswordNewPasswordArgs {
  ForgetPasswordNewPasswordArgs(
    this.phone,
    this.token,
  );

  String phone;
  String token;
}

class ForgetPasswordNewPasswordLayout extends StatelessWidget {
  const ForgetPasswordNewPasswordLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as ForgetPasswordNewPasswordArgs;
    return Scaffold(
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const CustomText(
          text: 'Đặt lại mật khẩu',
        ),
        elevation: 1,
      ),
      body: CommonMarginContainer(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => ForgetPasswordNewPasswordBloc(
              phone: args.phone,
              token: args.token,
            ),
            child: BlocListener<ForgetPasswordNewPasswordBloc,
                ForgetPasswordNewPasswordState>(
              listener: (context, state) {
                if (state.status.isSubmissionSuccess &&
                    state.statusSubmmited == NetworkConstants.ok200) {
                  FunctionalWidgets.showAwesomeDialog(
                    context,
                    dialogType: DialogType.SUCCES,
                    title: 'Đổi mật khẩu thành công',
                    desc: 'Bạn đã đổi mật khẩu thành công',
                    btnOkText: 'Đóng',
                    okRoutePress: Routes.login,
                  );
                } else if (state.status.isSubmissionFailure) {
                  FunctionalWidgets.showErrorSystemRouteButton(
                    context,
                    title: 'Đổi mật khẩu thất bại',
                    route: Routes.forgetPasswordNewPassword,
                  );
                } else if (state.status.isSubmissionInProgress) {
                  FunctionalWidgets.showCustomDialog(context);
                }
              },
              child: const ProfilePasswordEditBody(),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePasswordEditBody extends StatelessWidget {
  const ProfilePasswordEditBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordNewPasswordBloc,
        ForgetPasswordNewPasswordState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            getTopSizedbox(),
            input(
              errorText:
                  state.password.invalid ? 'Hãy nhập tối thiểu 6 ký tự' : null,
              onChanged: (value) {
                context
                    .read<ForgetPasswordNewPasswordBloc>()
                    .add(ForgetPasswordPasswordChange(password: value));
              },
              hintText: 'Mật khẩu mới',
              obscureText: state.password.value.isHide,
              textInputAction: TextInputAction.next,
              suffixIcon: IconButton(
                onPressed: () {
                  context
                      .read<ForgetPasswordNewPasswordBloc>()
                      .add(ForgetPasswordPasswordShowOrHide());
                },
                icon: Icon(
                  state.password.value.isHide
                      ? AppIcons.visibilityOff
                      : AppIcons.visibility,
                  size: 58.sp,
                ),
              ),
            ),
            getSizedbox(),
            input(
              onChanged: (value) {
                context.read<ForgetPasswordNewPasswordBloc>().add(
                    ForgetPasswordRepeatPasswordChanged(repeatPassword: value));
              },
              errorText: state.repeatPassword.invalid
                  ? 'Không khớp với mật khẩu mới'
                  : null,
              hintText: 'Nhập lại mật khẩu mới',
              obscureText: state.repeatPassword.value.isHide,
              textInputAction: TextInputAction.done,
              suffixIcon: IconButton(
                onPressed: () {
                  context
                      .read<ForgetPasswordNewPasswordBloc>()
                      .add(ForgetPasswordRepeatPasswordShowOrHide());
                },
                icon: Icon(
                  state.repeatPassword.value.isHide
                      ? AppIcons.visibilityOff
                      : AppIcons.visibility,
                  size: 58.sp,
                ),
              ),
            ),
            getTopSizedbox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                submmitedButton(
                  'Hủy',
                  AppColors.orangeFFF5670A,
                  () {
                    Navigator.pop(context);
                  },
                ),
                getHorizontalSizedbox(),
                submmitedButton(
                  'Lưu',
                  AppColors.greenFF61C53D,
                  state.status.isValid
                      ? () {
                          context
                              .read<ForgetPasswordNewPasswordBloc>()
                              .add(ForgetPasswordSubmmited());
                        }
                      : null,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget getTopSizedbox() {
    return SizedBox(
      height: 75.h,
    );
  }

  Widget getSizedbox() {
    return SizedBox(
      height: 45.h,
    );
  }

  Widget getHorizontalSizedbox() {
    return SizedBox(
      width: 65.w,
    );
  }

  Widget input({
    String? labelText,
    String? hintText,
    bool? obscureText,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    void Function(String)? onChanged,
    Widget? suffixIcon,
    String? errorText,
    String? initialValue,
    bool? enabled,
  }) {
    return TextFormField(
      style: TextStyle(fontSize: 50.sp),
      enabled: enabled,
      initialValue: initialValue,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      onChanged: onChanged,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        errorText: errorText,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            15.r,
          ),
          borderSide: const BorderSide(
            color: AppColors.greenFF61C53D,
          ),
        ),
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[600],
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget submmitedButton(String text, Color color, void Function()? onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        minimumSize: Size(
          350.w,
          WidgetConstants.buttonCommonHeight.h,
        ),
      ),
      onPressed: onPressed,
      child: CustomText(
        text: text,
        fontSize: WidgetConstants.buttonCommonFrontSize.sp,
        fontWeight: WidgetConstants.buttonCommonFrontWeight,
      ),
    );
  }
}
