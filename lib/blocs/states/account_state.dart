part of '../account_bloc.dart';

class AccountState extends Equatable {
  const AccountState({
    this.status = FormzStatus.pure,
  });
  final FormzStatus status;

  AccountState copyWith({
    FormzStatus? status,
  }) {
    return AccountState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
