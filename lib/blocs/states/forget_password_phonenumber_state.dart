part of '../forget_password_phonenumber_bloc.dart';

class ForgetPasswordPhoneNumberState extends Equatable {
  const ForgetPasswordPhoneNumberState({
    this.phoneNumber = const PhoneNumber.pure(),
    this.status = FormzStatus.pure,
    this.isExist = false,
  });

  final PhoneNumber phoneNumber;
  final FormzStatus status;
  final bool isExist;

  ForgetPasswordPhoneNumberState copyWith({
    PhoneNumber? phoneNumber,
    FormzStatus? status,
    bool? isExist,
  }) {
    return ForgetPasswordPhoneNumberState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      isExist: isExist ?? this.isExist,
    );
  }

  @override
  List<Object> get props => [
        phoneNumber,
        status,
        isExist,
      ];
}
