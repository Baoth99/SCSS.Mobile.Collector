part of '../signup_otp_bloc.dart';

enum TimerStatus { processed, resent, nothing, error }

class OTPSignupState extends Equatable {
  const OTPSignupState({
    this.phoneNumber = const PhoneNumber.pure(),
    this.otpCode = const OTPCode.pure(),
    this.status = FormzStatus.pure,
    this.timerStatus = TimerStatus.nothing,
    this.token = Symbols.empty,
  });

  final PhoneNumber phoneNumber;
  final OTPCode otpCode;
  final FormzStatus status;
  final TimerStatus timerStatus;
  final String token;

  OTPSignupState copyWith({
    PhoneNumber? phoneNumber,
    OTPCode? otpCode,
    FormzStatus? status,
    TimerStatus? timerStatus,
    String? token,
  }) {
    return OTPSignupState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpCode: otpCode ?? this.otpCode,
      status: status ?? this.status,
      timerStatus: timerStatus ?? this.timerStatus,
      token: token ?? this.token,
    );
  }

  @override
  List<Object> get props => [
        otpCode,
        status,
        timerStatus,
        token,
      ];
}
