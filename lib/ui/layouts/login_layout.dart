import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collector_app/blocs/login_bloc.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/custom_border_text_form_field_widget.dart';
import 'package:collector_app/ui/widgets/custom_button_widgets.dart';
import 'package:collector_app/ui/widgets/custom_text_button_widget.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status.isSubmissionInProgress) {
              FunctionalWidgets.showCustomDialog(
                context,
              );
            }

            if (state.status.isPure) {
              Navigator.popUntil(
                context,
                ModalRoute.withName(
                  Routes.login,
                ),
              );
            }

            if (state.status.isInvalid &&
                state.phoneNumber.pure &&
                state.password.pure) {
              Navigator.popUntil(
                context,
                ModalRoute.withName(Routes.login),
              );
            }

            if (state.status.isSubmissionFailure) {
              FunctionalWidgets.showErrorSystemRouteButton(
                context,
              );
            }

            if (state.status.isSubmissionSuccess) {
              if (state.loginStatus == LoginStatus.success) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.main,
                  (Route<dynamic> route) => false,
                );
              } else if (state.loginStatus == LoginStatus.notApproved) {
                Navigator.popUntil(context, ModalRoute.withName(Routes.login));

                FunctionalWidgets.showAwesomeDialog(
                  context,
                  dialogType: DialogType.INFO,
                  title: 'Tài khoản của bạn chưa được xác nhận',
                  desc:
                      'Tài khoản của bạn cần phải được xác nhận, xin vui lòng liên hệ với ban quản trị để hoàn thiện hồ sơ tài khoản',
                  btnOkText: 'Đóng',
                  isOkBorder: true,
                  btnOkColor: AppColors.errorButtonBorder,
                  textOkColor: AppColors.errorButtonText,
                  okRoutePress: Routes.login,
                );
              }
            }
          },
          child: const _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 200.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 50.h,
              bottom: 150.h,
            ),
            child: Image.asset(
              ImagesPaths.loginLogo,
              fit: BoxFit.contain,
              height: 320.h,
            ),
          ),
          CustomText(
            text: 'Đăng nhập để tiếp tục',
            color: AppColors.black,
            fontSize: 50.sp,
          ),
          const _Form(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Row(
              children: [
                CustomTextButton(
                  text: 'Quên mật khẩu',
                  onPressed: () {},
                  color: AppColors.black,
                  fontSize: 45.sp,
                  fontWeight: FontWeight.w500,
                ),
                Spacer(),
                CustomTextButton(
                  text: 'Tạo tài khoản',
                  onPressed: () {
                    _navigateToSignup(context);
                  },
                  color: AppColors.orangeFFF5670A,
                  fontSize: 45.sp,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Navigate the screen to first screen of signup screen
  void _navigateToSignup(BuildContext context) {
    Navigator.pushNamed(context, Routes.signupPhoneNumber);
  }
}

class _Form extends StatelessWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 65.h,
            ),
            child: BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (p, c) => p.phoneNumber.status != c.phoneNumber.status,
              builder: (context, state) {
                return CustomBorderTextFormField(
                  empty: state.status.isInvalid &&
                      state.phoneNumber.pure &&
                      state.password.pure,
                  autofocus: true,
                  onChanged: _onPhoneNumberChanged(context),
                  style: _getInputFieldTextStyle(),
                  labelText: 'Số điện thoại',
                  commonColor: AppColors.greenFF61C53D,
                  defaultColor: AppColors.greyFF969090,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  padding: EdgeInsets.symmetric(
                    horizontal: 60.0.w,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 45.0.w,
                    vertical: 50.0.h,
                  ),
                  cirularBorderRadius: 25.0.r,
                  errorText: state.phoneNumber.invalid
                      ? 'Hãy nhập số điện thoại'
                      : null,
                  labelStyle:
                      TextStyle(fontSize: 45.sp, color: AppColors.greyFF969090),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 60.h,
            ),
            child: BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (p, c) => p.password.status != c.password.status,
              builder: (context, state) {
                return CustomBorderTextFormField(
                  empty: state.status.isInvalid &&
                      state.phoneNumber.pure &&
                      state.password.pure,
                  onChanged: _onPasswordChanged(context),
                  style: _getInputFieldTextStyle(),
                  labelText: 'Mật khẩu',
                  commonColor: AppColors.greenFF61C53D,
                  defaultColor: AppColors.greyFF969090,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: 60.0.w,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 45.0.w,
                    vertical: 50.0.h,
                  ),
                  cirularBorderRadius: 25.0.r,
                  errorText:
                      state.password.invalid ? 'Hãy nhập mật khẩu' : null,
                  labelStyle:
                      TextStyle(fontSize: 45.sp, color: AppColors.greyFF969090),
                );
              },
            ),
          ),
          BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state.status.isInvalid &&
                  state.phoneNumber.pure &&
                  state.password.pure) {
                return CommonMarginContainer(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 20.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50.sp,
                        ),
                        const CustomText(
                          text:
                              'Số điện thoại hoặc mật khẩu của bạn không đúng.',
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          CustomButton(
            text: 'Đăng nhập',
            fontSize: 60.sp,
            onPressed: _onPressed(context),
            color: AppColors.greenFF66D095,
            textColor: AppColors.white,
            height: 150.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 60.w,
              vertical: 75.0.h,
            ),
            circularBorderRadius: 25.0.r,
          ),
        ],
      ),
    );
  }

  void Function() _onPressed(BuildContext context) {
    return () {
      context.read<LoginBloc>().add(
            LoginButtonSubmmited(),
          );
    };
  }

  Function(String) _onPhoneNumberChanged(BuildContext context) {
    return (value) {
      context.read<LoginBloc>().add(
            LoginPhoneNumberChanged(
              phoneNumber: value,
            ),
          );
    };
  }

  Function(String) _onPasswordChanged(BuildContext context) {
    return (value) {
      context.read<LoginBloc>().add(
            LoginPasswordChanged(
              password: value,
            ),
          );
    };
  }

  TextStyle _getInputFieldTextStyle() {
    return TextStyle(
      fontSize: 45.sp,
      fontWeight: FontWeight.w400,
    );
  }
}
