part of '../signup_bloc.dart';

class SignupState extends Equatable {
  const SignupState({
    this.phoneNumber = const PhoneNumber.pure(),
    this.status = FormzStatus.pure,
    this.isSuccessful = false,
  });

  final PhoneNumber phoneNumber;
  final FormzStatus status;
  final bool isSuccessful;

  SignupState copyWith({
    PhoneNumber? phoneNumber,
    FormzStatus? status,
    bool? isSuccessful,
  }) {
    return SignupState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      isSuccessful: isSuccessful ?? this.isSuccessful,
    );
  }

  @override
  List<Object> get props => [
        phoneNumber,
        status,
        isSuccessful,
      ];
}
