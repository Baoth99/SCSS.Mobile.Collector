part of '../edit_password_bloc.dart';

class EditPasswordState extends Equatable {
  const EditPasswordState({
    required this.id,
    this.password = const Password.pure(),
    this.repeatPassword = const RepeatPassword.pure(),
    this.oldPassword = const Password.pure(),
    this.status = FormzStatus.pure,
    this.statusSubmmited,
  });

  final String id;
  final Password password;
  final RepeatPassword repeatPassword;
  final Password oldPassword;
  final FormzStatus status;
  final int? statusSubmmited;

  EditPasswordState copyWith({
    Password? password,
    RepeatPassword? repeatPassword,
    Password? oldPassword,
    FormzStatus? status,
    int? statusSubmmited,
  }) {
    return EditPasswordState(
      id: id,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      oldPassword: oldPassword ?? this.oldPassword,
      status: status ?? this.status,
      statusSubmmited: statusSubmmited ?? this.statusSubmmited,
    );
  }

  @override
  List<Object?> get props => [
        id,
        password,
        repeatPassword,
        oldPassword,
        status,
        statusSubmmited,
      ];
}
