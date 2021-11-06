part of '../signup_information_bloc.dart';

abstract class SignupInformationEvent extends AbstractEvent {
  const SignupInformationEvent();
}

class SignupInformationNameChanged extends SignupInformationEvent {
  const SignupInformationNameChanged({
    required this.name,
  });

  final String name;

  @override
  List<Object> get props => [name];
}

class SignupInformationGenderChanged extends SignupInformationEvent {
  const SignupInformationGenderChanged({
    required this.gender,
  });

  final Gender gender;

  @override
  List<Object> get props => [gender];
}

class SignupInformationPasswordChanged extends SignupInformationEvent {
  const SignupInformationPasswordChanged({
    required this.password,
  });

  final String password;

  @override
  List<Object> get props => [password];
}

class SignupInformationRepeatPasswordChanged extends SignupInformationEvent {
  const SignupInformationRepeatPasswordChanged({
    required this.repeatPassword,
  });

  final String repeatPassword;

  @override
  List<Object> get props => [repeatPassword];
}

class SignupInformationPasswordShowOrHide extends SignupInformationEvent {}

class SignupInformationRepeatPasswordShowOrHide extends SignupInformationEvent {
}

class SignupInformationSubmmited extends SignupInformationEvent {}
