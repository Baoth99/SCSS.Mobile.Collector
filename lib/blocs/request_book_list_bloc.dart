import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/blocs/models/list_real_time_status.dart';
import 'package:collector_app/blocs/models/request_model.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/collecting_request_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'events/request_book_list_event.dart';
part 'states/request_book_list_state.dart';

class RequestBookListBloc
    extends Bloc<RequestBookListEvent, RequestBookListState> {
  RequestBookListBloc({
    CollectingRequestService? collectingRequestService,
  }) : super(
          RequestBookListState(),
        ) {
    _collectingRequestService =
        collectingRequestService ?? getIt.get<CollectingRequestService>();
  }
  late CollectingRequestService _collectingRequestService;
  final initialAbstractPage = 2;
  final sizeList = 10;
  @override
  Stream<RequestBookListState> mapEventToState(
      RequestBookListEvent event) async* {
    if (event is RequestBookListInitial) {
      int pageSize = initialAbstractPage * sizeList;

      try {
        yield state.copyWith(
          status: RequestBookListStatus.progress,
        );

        var listRequest = await getBookRequest(1, pageSize);

        yield state.copyWith(
          status: RequestBookListStatus.completed,
          listRequest: listRequest,
          page: listRequest.isNotEmpty ? initialAbstractPage : 0,
        );
      } catch (e) {
        yield state.copyWith(
          status: RequestBookListStatus.error,
        );
        AppLog.error(e);
      }
    } else if (event is RequestBookIsApproved) {
      yield state.copyWith(listRealTimeStatus: ListRealTimeStatus.resolving);
      try {
        var index = state.listRequest.indexWhere(
          (r) => r.id == event.id,
        );

        if (index >= 0) {
          var request = state.listRequest[index];
          request.isActive = false;

          var newList = <Request>[]..addAll(state.listRequest);
          newList[index] = request;
          yield state.copyWith(listRequest: newList);
        }
      } catch (e) {
        AppLog.error(e);
      }
      yield state.copyWith(listRealTimeStatus: ListRealTimeStatus.idle);
    } else if (event is RequestBookListRefresh) {
      int pageSize = initialAbstractPage * sizeList;

      try {
        yield state.copyWith(
          refreshStatus: RefreshStatus.refreshing,
        );
        var listActivity = await getBookRequest(1, pageSize);

        yield state.copyWith(
          refreshStatus: RefreshStatus.completed,
          listRequest: listActivity,
          page: listActivity.isNotEmpty ? initialAbstractPage : 0,
        );
      } catch (e) {
        yield state.copyWith(
          refreshStatus: RefreshStatus.failed,
        );
      }
    } else if (event is RequestBookListLoading) {
      try {
        yield state.copyWith(
          loadStatus: LoadStatus.loading,
        );
        var listActivity = await getBookRequest(state.page + 1, sizeList);
        yield state.copyWith(
          loadStatus: LoadStatus.idle,
          listRequest: state.listRequest..addAll(listActivity),
          page: listActivity.isNotEmpty ? state.page + 1 : state.page,
        );
      } catch (e) {
        yield state.copyWith(
          loadStatus: LoadStatus.idle,
        );
      }
    }
  }

  Future<List<Request>> getBookRequest(int page, int size) async {
    return await futureAppDuration<List<Request>>(
      _collectingRequestService.getBookRequest(
          currentLatitude, currentLongitude, page, size),
    );
  }
}
