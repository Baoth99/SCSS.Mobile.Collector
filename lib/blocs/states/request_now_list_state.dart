part of '../request_now_list_bloc.dart';

enum RequestNowListStatus {
  pure,
  progress,
  completed,
  error,
  emptyList,
}

class RequestNowListState extends Equatable {
  const RequestNowListState({
    required this.listRequest,
    this.status = RequestNowListStatus.pure,
    this.page = 0,
    this.listRealTimeStatus = ListRealTimeStatus.idle,
  });

  final List<Request> listRequest;
  final RequestNowListStatus status;
  final int page;
  final ListRealTimeStatus listRealTimeStatus;

  RequestNowListState copyWith({
    List<Request>? listRequest,
    RequestNowListStatus? status,
    int? page,
    ListRealTimeStatus? listRealTimeStatus,
  }) {
    return RequestNowListState(
      listRequest: listRequest ?? this.listRequest,
      status: status ?? this.status,
      page: page ?? this.page,
      listRealTimeStatus: listRealTimeStatus ?? this.listRealTimeStatus,
    );
  }

  @override
  List<Object> get props => [
        listRequest,
        status,
        page,
        listRealTimeStatus,
      ];
}
