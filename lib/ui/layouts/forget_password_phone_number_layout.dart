// ignore: import_of_legacy_library_into_null_safe
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collector_app/blocs/forget_password_phonenumber_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/layouts/forget_password_otp_layout.dart';
import 'package:collector_app/ui/widgets/custom_button.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ForgetPasswordPhoneNumberLayout extends StatelessWidget {
  const ForgetPasswordPhoneNumberLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: FunctionalWidgets.buildAppBar(
          context: context,
          color: AppColors.black,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: BlocProvider<ForgetPasswordPhoneNumberBloc>(
          create: (_) => ForgetPasswordPhoneNumberBloc(),
          child: BlocListener<ForgetPasswordPhoneNumberBloc,
              ForgetPasswordPhoneNumberState>(
            listener: (context, state) {
              if (state.status.isSubmissionSuccess) {
                if (state.isExist) {
                  // navigate to otp code
                  Navigator.of(context).popAndPushNamed(
                    Routes.forgetPasswordOTP,
                    arguments: ForgetPasswordOTPArgument(
                      Symbols.vietnamCallingCode,
                      state.phoneNumber.value,
                    ),
                  );
                } else {
                  FunctionalWidgets.showAwesomeDialog(
                    context,
                    dialogType: DialogType.INFO,
                    desc: 'Số điện thoại không có trong hệ thống',
                    btnOkText: 'Đóng',
                    isOkBorder: true,
                    btnOkColor: AppColors.errorButtonBorder,
                    textOkColor: AppColors.errorButtonText,
                    okRoutePress: Routes.forgetPasswordPhoneNumber,
                  );
                }
              }

              if (state.status.isSubmissionFailure) {
                FunctionalWidgets.showErrorSystemRouteButton(
                  context,
                  route: Routes.forgetPasswordPhoneNumber,
                );
              }

              if (state.status.isSubmissionInProgress) {
                FunctionalWidgets.showCustomDialog(
                  context,
                );
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 80.0.h,
                left: AppConstants.horizontalScaffoldMargin.w,
                right: AppConstants.horizontalScaffoldMargin.w,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomText(
                          text: 'Hãy nhập số điện thoại của bạn',
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.left,
                          fontSize: 55.sp,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 80.0.h,
                            bottom: 20.0.h,
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.greyFF9098B1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(17.0.r),
                                    ),
                                  ),
                                  child: CountryCodePicker(
                                    initialSelection: Symbols.vietnamISOCode,
                                    favorite: <String>[
                                      Symbols.vietnamCallingCode,
                                      Symbols.vietnamISOCode,
                                    ],
                                    showCountryOnly: false,
                                    showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
                                    enabled: false,
                                    textStyle: TextStyle(
                                      fontSize: 40.sp,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 25.0.w,
                                    ),
                                    child: PhoneNumberInput(
                                      onSubmit: _onSubmit,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BlocBuilder<ForgetPasswordPhoneNumberBloc,
                            ForgetPasswordPhoneNumberState>(
                          builder: (context, state) {
                            return Visibility(
                              child: Container(
                                width: double.infinity,
                                child: CustomText(
                                  text: 'Số di động có vẻ không chính xác.',
                                  fontSize: 40.sp,
                                  color: AppColors.red,
                                ),
                              ),
                              visible: state.phoneNumber.invalid,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        NextButton(
                          onSubmit: _onSubmit,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void Function() _onSubmit(BuildContext context) {
    return () {
      context.read<ForgetPasswordPhoneNumberBloc>().add(
            ForgetPasswordPhoneNumberSubmmited(),
          );
    };
  }
}

class NextButton extends StatelessWidget {
  const NextButton({Key? key, required this.onSubmit}) : super(key: key);

  final void Function() Function(BuildContext context) onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordPhoneNumberBloc,
        ForgetPasswordPhoneNumberState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return CustomButton(
          title: 'Tiếp',
          onPressed: state.status.isValidated ? onSubmit(context) : null,
          fontSize: 55.sp,
          width: double.infinity,
          height: 130.0.h,
          color: AppColors.greenFF61C53D,
        );
      },
    );
  }
}

class PhoneNumberInput extends StatelessWidget {
  const PhoneNumberInput({
    Key? key,
    this.onSubmit,
  }) : super(key: key);

  final void Function(BuildContext context)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: '87654321',
        hintStyle: _getPhoneNumberTextStyle(
          color: AppColors.greyFFDADADA,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 26.0.h,
          horizontal: 15.0.w,
        ),
        border: _getOutLineInputBorder(),
        focusedBorder: _getOutLineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greyFF9098B1,
          ),
        ),
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: _getPhoneNumberTextStyle(),
      onChanged: _onChanged(context),
      textInputAction: TextInputAction.go,
    );
  }

  void Function(String) _onChanged(BuildContext context) {
    return (value) {
      context.read<ForgetPasswordPhoneNumberBloc>().add(
            ForgetPasswordPhoneNumberChanged(value),
          );
    };
  }

  TextStyle _getPhoneNumberTextStyle({Color? color}) {
    return TextStyle(
      fontSize: 90.sp,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  OutlineInputBorder _getOutLineInputBorder({BorderSide? borderSide}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(17.0.r),
      borderSide: borderSide ?? const BorderSide(),
    );
  }
}
