part of '../signup_bloc.dart';

abstract class SignupEvent extends AbstractEvent {
  const SignupEvent();
}

class PhoneNumberChanged extends SignupEvent {
  const PhoneNumberChanged({required this.phoneNumber});

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

class ButtonPressedToGetOTP extends SignupEvent {}
