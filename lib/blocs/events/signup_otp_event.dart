part of '../signup_otp_bloc.dart';

abstract class OTPSignupEvent extends AbstractEvent {
  const OTPSignupEvent();
}

class OTPCodeChanged extends OTPSignupEvent {
  const OTPCodeChanged({required this.otpCode});

  final String otpCode;

  @override
  List<String> get props => [
        otpCode,
      ];
}

class OTPCodeSubmitted extends OTPSignupEvent {}

class OTPSignupInitital extends OTPSignupEvent {
  const OTPSignupInitital({
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

class OTPResendPressed extends OTPSignupEvent {}
