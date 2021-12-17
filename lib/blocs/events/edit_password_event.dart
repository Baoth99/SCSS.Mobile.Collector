part of '../edit_password_bloc.dart';

abstract class EditPasswordEvent extends AbstractEvent {
  const EditPasswordEvent();
}

class EditPassPasswordChange extends EditPasswordEvent {
  const EditPassPasswordChange({
    required this.password,
  });

  final String password;

  @override
  List<Object> get props => [password];
}

class EditPassRepeatPasswordChanged extends EditPasswordEvent {
  const EditPassRepeatPasswordChanged({
    required this.repeatPassword,
  });

  final String repeatPassword;

  @override
  List<Object> get props => [repeatPassword];
}

class EditOldPasswordChange extends EditPasswordEvent {
  const EditOldPasswordChange({
    required this.password,
  });

  final String password;

  @override
  List<Object> get props => [password];
}

class EditPassPasswordShowOrHide extends EditPasswordEvent {}

class EditPassRepeatPasswordShowOrHide extends EditPasswordEvent {}

class EditOldPasswordShowOrHide extends EditPasswordEvent {}

class EditPassSubmmited extends EditPasswordEvent {}
