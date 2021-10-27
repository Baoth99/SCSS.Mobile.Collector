import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collector_app/blocs/edit_password_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

class ProfilePasswordEditArgs {
  ProfilePasswordEditArgs(this.id);

  String id;
}

class ProfilePasswordEditLayout extends StatelessWidget {
  const ProfilePasswordEditLayout({
    Key? key,
  }) : super(key: key);

  static const String failEditPassword = 'Đổi mật khẩu thất bại';
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProfilePasswordEditArgs;
    return Scaffold(
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const CustomText(
          text: 'Đổi mật khẩu',
        ),
        elevation: 1,
      ),
      body: CommonMarginContainer(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => EditPasswordBloc(
              id: args.id,
            ),
            child: BlocListener<EditPasswordBloc, EditPasswordState>(
              listener: (context, state) {
                if (state.status.isSubmissionSuccess &&
                    state.statusSubmmited == NetworkConstants.ok200) {
                  FunctionalWidgets.showAwesomeDialog(
                    context,
                    dialogType: DialogType.SUCCES,
                    title: 'Đổi mật khẩu thành công',
                    desc: 'Bạn đã đổi mật khẩu thành công',
                    btnOkText: 'Đóng',
                    okRoutePress: Routes.main,
                  );
                } else if (state.status.isSubmissionFailure) {
                  if (state.statusSubmmited == NetworkConstants.badRequest400) {
                    FunctionalWidgets.showAwesomeDialog(
                      context,
                      dialogType: DialogType.WARNING,
                      title: failEditPassword,
                      desc: 'Bạn đã nhập sai mật khẩu hiện tại',
                      btnOkText: 'Đóng',
                      isOkBorder: true,
                      btnOkColor: AppColors.errorButtonBorder,
                      textOkColor: AppColors.errorButtonText,
                      okRoutePress: Routes.profilePasswordEdit,
                    );
                  } else if (state.statusSubmmited == null) {
                    FunctionalWidgets.showErrorSystemRouteButton(
                      context,
                      title: failEditPassword,
                      route: Routes.profilePasswordEdit,
                    );
                  }
                } else if (state.status.isSubmissionInProgress) {
                  FunctionalWidgets.showCustomDialog(
                    context,
                  );
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
    return BlocBuilder<EditPasswordBloc, EditPasswordState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            getSizedbox(),
            input(
              onChanged: (value) {
                context
                    .read<EditPasswordBloc>()
                    .add(EditOldPasswordChange(password: value));
              },
              hintText: 'Mật khẩu hiện tại',
              obscureText: state.oldPassword.value.isHide,
              textInputAction: TextInputAction.next,
              errorText: state.oldPassword.value.value.isEmpty &&
                      !state.oldPassword.pure
                  ? 'Hãy nhập mật khẩu hiện tại'
                  : null,
              suffixIcon: IconButton(
                onPressed: () {
                  context
                      .read<EditPasswordBloc>()
                      .add(EditOldPasswordShowOrHide());
                },
                icon: Icon(
                  state.oldPassword.value.isHide
                      ? AppIcons.visibilityOff
                      : AppIcons.visibility,
                  size: 58.sp,
                ),
              ),
            ),
            getSizedbox(),
            input(
              errorText:
                  state.password.invalid ? 'Hãy nhập tối thiểu 6 ký tự' : null,
              onChanged: (value) {
                context
                    .read<EditPasswordBloc>()
                    .add(EditPassPasswordChange(password: value));
              },
              hintText: 'Mật khẩu mới',
              obscureText: state.password.value.isHide,
              textInputAction: TextInputAction.next,
              suffixIcon: IconButton(
                onPressed: () {
                  context
                      .read<EditPasswordBloc>()
                      .add(EditPassPasswordShowOrHide());
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
                context
                    .read<EditPasswordBloc>()
                    .add(EditPassRepeatPasswordChanged(repeatPassword: value));
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
                      .read<EditPasswordBloc>()
                      .add(EditPassRepeatPasswordShowOrHide());
                },
                icon: Icon(
                  state.repeatPassword.value.isHide
                      ? AppIcons.visibilityOff
                      : AppIcons.visibility,
                  size: 58.sp,
                ),
              ),
            ),
            getSizedbox(),
            submmitedButton(
              'Lưu',
              AppColors.greenFF61C53D,
              state.status.isValid
                  ? () {
                      context.read<EditPasswordBloc>().add(EditPassSubmmited());
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }

  Widget getSizedbox() {
    return SizedBox(
      height: 65.h,
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
          double.infinity,
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
