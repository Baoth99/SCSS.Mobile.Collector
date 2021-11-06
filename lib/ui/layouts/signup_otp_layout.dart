import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collector_app/blocs/signup_otp_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/layouts/signup_information_layout.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupOTPArgument {
  SignupOTPArgument(
    this.dialingCode,
    this.phoneNumber,
  );

  final String dialingCode;
  final String phoneNumber;
}

class SignupOTPLayout extends StatelessWidget {
  const SignupOTPLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SignupOTPArgument;

    return Scaffold(
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        color: AppColors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: BlocProvider<SignupOTPBloc>(
        create: (_) => SignupOTPBloc()
          ..add(
            OTPSignupInitital(
              dialingCode: args.dialingCode,
              phoneNumber: args.phoneNumber,
            ),
          ),
        child: BlocListener<SignupOTPBloc, OTPSignupState>(
          listener: (context, state) {
            if (state.status.isValid) {
              context.read<SignupOTPBloc>().add(
                    OTPCodeSubmitted(),
                  );
            }

            if (state.status.isSubmissionInProgress) {
              FunctionalWidgets.showCustomDialog(
                context,
                OTPFillPhoneNumberLayoutConstants.checking,
                OTPFillPhoneNumberLayoutConstants.checkingProgressIndicator,
              );
            }

            if (state.status.isSubmissionSuccess) {
              if (state.token.isNotEmpty) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.signupInformation,
                  ModalRoute.withName(Routes.signupPhoneNumber),
                  arguments: SignupInformationArgs(
                    state.phoneNumber.value,
                    state.token,
                  ),
                );
              } else {
                FunctionalWidgets.showAwesomeDialog(
                  context,
                  dialogType: DialogType.WARNING,
                  desc: 'Mã OTP không đúng',
                  btnOkText: 'Đóng',
                  isOkBorder: true,
                  btnOkColor: AppColors.errorButtonBorder,
                  textOkColor: AppColors.errorButtonText,
                  okRoutePress: Routes.signupOTP,
                );
              }
            }

            if (state.timerStatus == TimerStatus.resent) {
              Navigator.of(context).popUntil(
                (route) => route.settings.name == Routes.signupOTP,
              );
            }

            if (state.timerStatus == TimerStatus.processed) {
              FunctionalWidgets.showCustomDialog(
                context,
                OTPFillPhoneNumberLayoutConstants.resendOTP,
                OTPFillPhoneNumberLayoutConstants.resendOTPProgressIndicator,
              );
            }

            if (state.timerStatus == TimerStatus.error ||
                state.status.isSubmissionFailure) {
              FunctionalWidgets.showErrorSystemRouteButton(
                context,
                route: Routes.signupOTP,
              );
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScaffoldMargin.w,
              vertical: 50.0.h,
            ),
            child: const _Body(),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const OTPPhoneNumberWidget(),
        const Expanded(
          child: BottomBody(),
        ),
      ],
    );
  }
}

class OTPPhoneNumberWidget extends StatelessWidget {
  const OTPPhoneNumberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomText(
          text: OTPFillPhoneNumberLayoutConstants.title,
          fontSize: 44.sp,
          fontWeight: FontWeight.w400,
        ),
        BlocBuilder<SignupOTPBloc, OTPSignupState>(
          builder: (context, state) => CustomText(
            text: state.phoneNumber.value,
            fontSize: 53.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        const OTPInput(),
      ],
    );
  }
}

class OTPInput extends StatelessWidget {
  const OTPInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _onChanged(context),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      maxLength: OTPFillPhoneNumberLayoutConstants.inputLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      style: getFontStyle(
        AppColors.blackBB000000,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: OTPFillPhoneNumberLayoutConstants.hintText,
        hintStyle: getFontStyle(
          AppColors.greyFFDADADA,
        ),
      ),
      textInputAction: TextInputAction.go,
    );
  }

  void Function(String value)? _onChanged(BuildContext context) {
    return (value) {
      if (value.length <= Others.otpLength) {
        context.read<SignupOTPBloc>().add(
              OTPCodeChanged(otpCode: value),
            );
      }
    };
  }

  TextStyle getFontStyle(Color? color) {
    return TextStyle(
      color: color,
      fontSize: 95.sp,
      fontWeight: FontWeight.w700,
    );
  }
}

class BottomBody extends StatelessWidget {
  const BottomBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: CustomText(
            text: OTPFillPhoneNumberLayoutConstants.notHaveCode,
            fontSize: 50.sp,
          ),
        ),
        const RequestCodeButton(),
      ],
    );
  }
}

class RequestCodeButton extends StatefulWidget {
  const RequestCodeButton({Key? key}) : super(key: key);

  @override
  _RequestCodeButtonState createState() => _RequestCodeButtonState();
}

class _RequestCodeButtonState extends State<RequestCodeButton> {
  Timer? _timer;
  int _start = OTPFillPhoneNumberLayoutConstants.countdown;
  bool enableButton = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(RequestCodeButton oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if(oldWidget.in != widget.initialValue) {
  //    _setTimer();
  //  }
  // }

  void _startTimer() {
    enableButton = false;
    _timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            _timer = null;
            enableButton = true;
          } else {
            _start -= 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      onPressed: enableButton
          ? () {
              if (_timer == null && _start <= 0) {
                _timer?.cancel();
                _timer = null;

                context.read<SignupOTPBloc>().add(OTPResendPressed());

                _start = OTPFillPhoneNumberLayoutConstants.countdown;

                //TODO: check condition pure, valid, failue
                _startTimer();
              }
            }
          : null,
      child: CustomText(
        text: OTPFillPhoneNumberLayoutConstants.requetsNewCode.replaceFirst(
          OTPFillPhoneNumberLayoutConstants.replacedSecondVar,
          CommonUtils.toStringPadleft(_start, 2),
        ),
        fontSize: 50.sp,
      ),
    );
  }
}
