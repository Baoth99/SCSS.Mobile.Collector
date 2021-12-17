part of '../home_bloc.dart';

enum APIFetchState {
  idle,
  fetching,
}

class HomeState extends Equatable {
  HomeState({
    List<CollectingRequestModel>? listCollectingRequestModel,
    this.totalRequest = 0,
    this.status = FormzStatus.pure,
    this.apiState = APIFetchState.idle,
    this.searchValue = Symbols.empty,
  }) {
    this.listCollectingRequestModel = listCollectingRequestModel ?? [];
  }

  late final List<CollectingRequestModel> listCollectingRequestModel;
  final int totalRequest;
  final FormzStatus status;
  final APIFetchState apiState;
  final String searchValue;

  HomeState copyWith({
    int? totalRequest,
    List<CollectingRequestModel>? listCollectingRequestModel,
    FormzStatus? status,
    APIFetchState? apiState,
    String? searchValue,
  }) {
    return HomeState(
      totalRequest: totalRequest ?? this.totalRequest,
      listCollectingRequestModel:
          listCollectingRequestModel ?? this.listCollectingRequestModel,
      status: status ?? this.status,
      apiState: apiState ?? this.apiState,
      searchValue: searchValue ?? this.searchValue,
    );
  }

  @override
  List<Object?> get props => [
        listCollectingRequestModel,
        totalRequest,
        status,
        apiState,
        searchValue,
      ];
}
