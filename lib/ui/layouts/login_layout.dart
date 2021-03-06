import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collector_app/blocs/login_bloc.dart';
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
                  title: 'T??i kho???n c???a b???n ch??a ???????c x??c nh???n',
                  desc:
                      'T??i kho???n c???a b???n c???n ph???i ???????c x??c nh???n, xin vui l??ng li??n h??? v???i ban qu???n tr??? ????? ho??n thi???n h??? s?? t??i kho???n',
                  btnOkText: '????ng',
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
            text: '????ng nh???p ????? ti???p t???c',
            color: AppColors.black,
            fontSize: 50.sp,
          ),
          const _Form(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: 'Qu??n m???t kh???u',
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(Routes.forgetPasswordPhoneNumber);
                    },
                    color: AppColors.black,
                    fontSize: 45.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Spacer(),
                // CustomTextButton(
                //   text: 'T???o t??i kho???n',
                //   onPressed: () {
                //     _navigateToSignup(context);
                //   },
                //   color: AppColors.orangeFFF5670A,
                //   fontSize: 45.sp,
                //   fontWeight: FontWeight.w500,
                // ),
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
                  labelText: 'S??? ??i???n tho???i',
                  commonColor: AppColors.greenFF01C971,
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
                      ? 'H??y nh???p s??? ??i???n tho???i'
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
              buildWhen: (p, c) =>
                  (p.password.status != c.password.status) ||
                  (p.password.value.isHide) != (c.password.value.isHide),
              builder: (context, state) {
                return CustomBorderTextFormField(
                  empty: state.status.isInvalid &&
                      state.phoneNumber.pure &&
                      state.password.pure,
                  onChanged: _onPasswordChanged(context),
                  style: _getInputFieldTextStyle(),
                  labelText: 'M???t kh???u',
                  commonColor: AppColors.greenFF01C971,
                  defaultColor: AppColors.greyFF969090,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: state.password.value.isHide,
                  padding: EdgeInsets.symmetric(
                    horizontal: 60.0.w,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 45.0.w,
                    vertical: 50.0.h,
                  ),
                  cirularBorderRadius: 25.0.r,
                  errorText:
                      state.password.invalid ? 'H??y nh???p m???t kh???u' : null,
                  labelStyle:
                      TextStyle(fontSize: 45.sp, color: AppColors.greyFF969090),
                  suffixIcon: IconButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(LoginPasswordShowOrHide());
                    },
                    icon: Icon(
                      state.password.value.isHide
                          ? AppIcons.visibilityOff
                          : AppIcons.visibility,
                      size: 58.sp,
                    ),
                  ),
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
                              'S??? ??i???n tho???i ho???c m???t kh???u c???a b???n kh??ng ????ng.',
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
            text: '????ng nh???p',
            fontSize: 60.sp,
            onPressed: _onPressed(context),
            color: AppColors.greenFF01C971,
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
