import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/blocs/models/collecting_request_model.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/collecting_request_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
part 'events/home_event.dart';
part 'states/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late CollectingRequestService _collectingRequestService;
  HomeBloc({CollectingRequestService? collectingRequestService})
      : super(HomeState()) {
    _collectingRequestService =
        collectingRequestService ?? getIt.get<CollectingRequestService>();
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    /* if (event is HomeFetch) {
      try {
        if (state.apiState == APIFetchState.idle &&
            !state.status.isSubmissionInProgress &&
            !state.status.isPure) {
          yield state.copyWith(
            apiState: APIFetchState.fetching,
          );
          var listCollectingRequestModel =
              await _collectingRequestService.getReceiveRequest(
                  Symbols.empty, currentLatitude, currentLongitude, 1, 30);

          yield state.copyWith(
            apiState: APIFetchState.idle,
            listCollectingRequestModel: listCollectingRequestModel,
            totalRequest: listCollectingRequestModel.length,
          );
        }
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          apiState: APIFetchState.idle,
          collectingRequestModel: state.collectingRequestModel,
        );
      }
    } else */
    if (event is HomeInitial) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        var listCollectingRequestModel =
            await _collectingRequestService.getReceiveRequest(
                Symbols.empty, currentLatitude, currentLongitude, 1, 30);

        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
          listCollectingRequestModel: listCollectingRequestModel,
          totalRequest: listCollectingRequestModel.length,
        );
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    } else if (event is HomeSearch) {
      yield state.copyWith(searchValue: event.searchValue);
    }
  }
}
