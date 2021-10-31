part of '../forget_pass_otp_bloc.dart';

abstract class ForgetPassOTPEvent extends AbstractEvent {
  const ForgetPassOTPEvent();
}

class ForgetPassOTPCodeChanged extends ForgetPassOTPEvent {
  const ForgetPassOTPCodeChanged({required this.otpCode});

  final String otpCode;

  @override
  List<String> get props => [
        otpCode,
      ];
}

class ForgetPassOTPSubmitted extends ForgetPassOTPEvent {}

class ForgetPassOTPInitital extends ForgetPassOTPEvent {
  const ForgetPassOTPInitital({
    required this.dialingCode,
    required this.phoneNumber,
  });

  final String phoneNumber;
  final String dialingCode;

  @override
  List<String> get props => [
        dialingCode,
        phoneNumber,
      ];
}

class ForgetPassOTPResendPressed extends ForgetPassOTPEvent {}
