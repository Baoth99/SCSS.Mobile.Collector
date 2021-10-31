part of '../forget_password_new_password_bloc.dart';

class ForgetPasswordNewPasswordState extends Equatable {
  const ForgetPasswordNewPasswordState({
    required this.phone,
    required this.token,
    this.password = const Password.pure(),
    this.repeatPassword = const RepeatPassword.pure(),
    this.status = FormzStatus.pure,
    this.statusSubmmited,
  });

  final String phone;
  final String token;
  final Password password;
  final RepeatPassword repeatPassword;
  final FormzStatus status;
  final int? statusSubmmited;

  ForgetPasswordNewPasswordState copyWith({
    Password? password,
    RepeatPassword? repeatPassword,
    FormzStatus? status,
    int? statusSubmmited,
  }) {
    return ForgetPasswordNewPasswordState(
      phone: phone,
      token: token,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      status: status ?? this.status,
      statusSubmmited: statusSubmmited ?? this.statusSubmmited,
    );
  }

  @override
  List<Object?> get props => [
        phone,
        token,
        password,
        repeatPassword,
        status,
        statusSubmmited,
      ];
}
