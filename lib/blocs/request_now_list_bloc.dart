import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/blocs/models/list_real_time_status.dart';
import 'package:collector_app/blocs/models/request_model.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/collecting_request_service.dart';
import 'package:collector_app/ui/layouts/pending_request_layout.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'events/request_now_list_event.dart';
part 'states/request_now_list_state.dart';

class RequestNowListBloc
    extends Bloc<RequestNowListEvent, RequestNowListState> {
  RequestNowListBloc({
    CollectingRequestService? collectingRequestService,
  }) : super(
          RequestNowListState(listRequest: []),
        ) {
    _collectingRequestService =
        collectingRequestService ?? getIt.get<CollectingRequestService>();
  }
  late CollectingRequestService _collectingRequestService;
  final initialAbstractPage = 2;
  final sizeList = 10;
  @override
  Stream<RequestNowListState> mapEventToState(
      RequestNowListEvent event) async* {
    if (event is RequestNowListInitial) {
      int pageSize = initialAbstractPage * sizeList;

      try {
        yield state.copyWith(
          status: RequestNowListStatus.progress,
        );

        var listRequest = await getListActivityByStatus(1, pageSize);

        yield state.copyWith(
          status: RequestNowListStatus.completed,
          listRequest: listRequest,
          page: listRequest.isNotEmpty ? initialAbstractPage : 0,
        );
      } catch (e) {
        yield state.copyWith(
          status: RequestNowListStatus.error,
        );
        AppLog.error(e);
      }
    } else if (event is RequestNowIsApproved) {
      yield state.copyWith(listRealTimeStatus: ListRealTimeStatus.resolving);
      try {
        var index = state.listRequest.indexWhere(
          (r) => r.id == event.requestModel.id,
        );

        if (index >= 0) {
          var request = state.listRequest[index];

          //check deactivate status
          if (event.requestModel.status ==
                  ActivityLayoutConstants.cancelBySeller ||
              event.requestModel.status ==
                  ActivityLayoutConstants.cancelBySystem) {
            request.pendingRequestStatus = PendingRequestStatus.canceled;
          } else if (event.requestModel.status ==
              ActivityLayoutConstants.approved) {
            request.pendingRequestStatus = PendingRequestStatus.approved;
          }

          //assign new list
          var newList = <Request>[]..addAll(state.listRequest);
          newList[index] = request;
          yield state.copyWith(listRequest: newList);
        }
      } catch (e) {
        AppLog.error(e);
      }
      yield state.copyWith(listRealTimeStatus: ListRealTimeStatus.idle);
    }
    /* else if (event is ActivityListRefresh) {
      int pageSize = initialAbstractPage * sizeList;

      try {
        yield state.copyWith(
          refreshStatus: RefreshStatus.refreshing,
        );
        var listActivity = await getListActivityByStatus(pageSize, 1);

        yield state.copyWith(
          refreshStatus: RefreshStatus.completed,
          listActivity: listActivity,
          page: listActivity.isNotEmpty ? initialAbstractPage : 0,
        );
      } catch (e) {
        yield state.copyWith(
          refreshStatus: RefreshStatus.failed,
        );
      }
    } else if (event is ActivityListLoading) {
      try {
        yield state.copyWith(
          loadStatus: LoadStatus.loading,
        );
        var listActivity =
            await getListActivityByStatus(sizeList, state.page + 1);
        yield state.copyWith(
          loadStatus: LoadStatus.idle,
          listActivity: state.listActivity..addAll(listActivity),
          page: listActivity.isNotEmpty ? state.page + 1 : state.page,
        );
      } catch (e) {
        yield state.copyWith(
          loadStatus: LoadStatus.idle,
        );
      }
    } */
  }

  Future<List<Request>> getListActivityByStatus(int page, int size) async {
    return await futureAppDuration<List<Request>>(
      _collectingRequestService.getNowRequest(
          currentLatitude, currentLongitude, page, size),
    );
  }
}
