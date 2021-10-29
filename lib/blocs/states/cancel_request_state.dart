part of '../cancel_request_bloc.dart';

enum CancelRequestDataIntial {
  pure,
  procerss,
  done,
}

class CancelRequestState extends Equatable {
  const CancelRequestState({
    this.requestId = Symbols.empty,
    this.cancelReason = const CancelReason.pure(),
    this.status = FormzStatus.pure,
    required this.cancelReasons,
    this.dataIntial = CancelRequestDataIntial.pure,
  });

  final String requestId;
  final CancelReason cancelReason;
  final FormzStatus status;
  final List<String> cancelReasons;
  final CancelRequestDataIntial dataIntial;

  CancelRequestState copyWith({
    CancelReason? cancelReason,
    FormzStatus? status,
    List<String>? cancelReasons,
    CancelRequestDataIntial? dataIntial,
  }) {
    return CancelRequestState(
      requestId: requestId,
      cancelReason: cancelReason ?? this.cancelReason,
      status: status ?? this.status,
      cancelReasons: cancelReasons ?? this.cancelReasons,
      dataIntial: dataIntial ?? this.dataIntial,
    );
  }

  @override
  List<Object> get props => [
        requestId,
        cancelReason,
        status,
        cancelReasons,
        dataIntial,
      ];
}
