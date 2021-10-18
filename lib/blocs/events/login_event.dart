part of '../login_bloc.dart';

abstract class LoginEvent extends AbstractEvent {
  const LoginEvent();
}

class LoginPhoneNumberChanged extends LoginEvent {
  final String phoneNumber;

  const LoginPhoneNumberChanged({this.phoneNumber = Symbols.space});

  @override
  List<String> get props => [phoneNumber];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  const LoginPasswordChanged({this.password = Symbols.space});

  @override
  List<String> get props => [password];
}

class LoginButtonSubmmited extends LoginEvent {}

class LoginRefreshTokenConnected extends LoginEvent {}

class LoginIntial extends LoginEvent {}
