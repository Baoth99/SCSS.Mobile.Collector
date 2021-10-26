part of '../home_bloc.dart';

enum APIFetchState {
  idle,
  fetching,
}

class HomeState extends Equatable {
  const HomeState({
    this.collectingRequestModel,
    this.totalRequest = 0,
    this.status = FormzStatus.pure,
    this.apiState = APIFetchState.idle,
  });

  final CollectingRequestModel? collectingRequestModel;
  final int totalRequest;
  final FormzStatus status;
  final APIFetchState apiState;

  HomeState copyWith({
    int? totalRequest,
    CollectingRequestModel? collectingRequestModel,
    FormzStatus? status,
    APIFetchState? apiState,
  }) {
    return HomeState(
      totalRequest: totalRequest ?? this.totalRequest,
      collectingRequestModel: collectingRequestModel,
      status: status ?? this.status,
      apiState: apiState ?? this.apiState,
    );
  }

  @override
  List<Object?> get props => [
        collectingRequestModel,
        totalRequest,
        status,
        apiState,
      ];
}
