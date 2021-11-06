part of '../signup_information_bloc.dart';

class SignupInformationState extends Equatable {
  const SignupInformationState({
    required this.phone,
    required this.token,
    this.name = const Name.pure(),
    this.gender = Gender.male,
    this.password = const Password.pure(),
    this.repeatPassword = const RepeatPassword.pure(),
    this.status = FormzStatus.pure,
    this.statusSubmmited,
  });
  final String phone;
  final String token;
  final Name name;
  final Gender gender;
  final Password password;
  final RepeatPassword repeatPassword;
  final FormzStatus status;
  final int? statusSubmmited;

  SignupInformationState copyWith({
    Name? name,
    Gender? gender,
    Password? password,
    RepeatPassword? repeatPassword,
    FormzStatus? status,
    int? statusSubmmited,
  }) {
    return SignupInformationState(
      phone: phone,
      token: token,
      name: name ?? this.name,
      gender: gender ?? this.gender,
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
        name,
        gender,
        password,
        repeatPassword,
        status,
        statusSubmmited,
      ];
}
