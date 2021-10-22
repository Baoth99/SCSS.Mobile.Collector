part of '../request_book_list_bloc.dart';

enum RequestBookListStatus {
  pure,
  progress,
  completed,
  error,
  emptyList,
}

class RequestBookListState extends Equatable {
  RequestBookListState({
    List<Request>? listRequest,
    this.status = RequestBookListStatus.pure,
    this.page = 0,
    this.listRealTimeStatus = ListRealTimeStatus.idle,
    this.refreshStatus = RefreshStatus.idle,
    this.loadStatus = LoadStatus.idle,
  }) {
    this.listRequest = listRequest ?? [];
  }

  late final List<Request> listRequest;
  final RequestBookListStatus status;
  final int page;
  final ListRealTimeStatus listRealTimeStatus;
  final RefreshStatus refreshStatus;
  final LoadStatus loadStatus;

  RequestBookListState copyWith({
    List<Request>? listRequest,
    RequestBookListStatus? status,
    int? page,
    ListRealTimeStatus? listRealTimeStatus,
    RefreshStatus? refreshStatus,
    LoadStatus? loadStatus,
  }) {
    return RequestBookListState(
      listRequest: listRequest ?? this.listRequest,
      status: status ?? this.status,
      page: page ?? this.page,
      listRealTimeStatus: listRealTimeStatus ?? this.listRealTimeStatus,
      refreshStatus: refreshStatus ?? this.refreshStatus,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }

  @override
  List<Object> get props => [
        listRequest,
        status,
        page,
        listRealTimeStatus,
        refreshStatus,
        loadStatus,
      ];
}
