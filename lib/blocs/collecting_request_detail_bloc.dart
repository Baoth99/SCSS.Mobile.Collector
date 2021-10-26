import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/blocs/models/gender_model.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/exceptions/custom_exceptions.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/collecting_request_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'events/collecting_request_detail_event.dart';
part 'states/collecting_request_detail_state.dart';

class CollectingRequestDetailBloc
    extends Bloc<CollectingRequestDetailEvent, CollectingRequestDetailState> {
  CollectingRequestDetailBloc({
    CollectingRequestService? collectingRequestService,
    required CollectingRequestDetailStatus collectingRequestDetailStatus,
  }) : super(CollectingRequestDetailState(
          collectingRequestDetailStatus: collectingRequestDetailStatus,
        )) {
    _collectingRequestService =
        collectingRequestService ?? getIt.get<CollectingRequestService>();
  }
  late final CollectingRequestService _collectingRequestService;
  @override
  Stream<CollectingRequestDetailState> mapEventToState(
      CollectingRequestDetailEvent event) async* {
    if (event is CollectingRequestDetailInitial) {
      try {
        yield state.copyWith(
          id: event.id,
          status: FormzStatus.submissionInProgress,
        );

        if (state.collectingRequestDetailStatus ==
            CollectingRequestDetailStatus.pending) {
          var result = await futureAppDuration(
            _collectingRequestService.getCollectingRequest(event.id),
          );

          yield state.copyWith(
            id: result.id,
            gender: result.gender,
            isAllowedToApprove: result.isAllowedToApprove,
            isBulky: result.isBulky,
            latitude: result.latitude,
            longtitude: result.longtitude,
            note: result.note,
            requestType: result.requestType,
            scrapImageUrl: result.scrapImageUrl,
            time: result.time,
            sellerAvatarUrl: result.sellerAvatarUrl,
            sellerName: result.sellerName,
            area: result.area,
            collectingRequestCode: result.collectingRequestCode,
            status: FormzStatus.submissionSuccess,
          );
        } else {
          var result = await futureAppDuration(
            _collectingRequestService.getApprovedRequest(state.id),
          );

          yield state.copyWith(
            id: result.id,
            gender: result.gender,
            isBulky: result.isBulky,
            latitude: result.latitude,
            longtitude: result.longtitude,
            note: result.note,
            scrapImageUrl: result.scrapImageUrl,
            time: result.time,
            sellerAvatarUrl: result.sellerAvatarUrl,
            sellerName: result.sellerName,
            collectingRequestCode: result.collectingRequestCode,
            status: FormzStatus.submissionSuccess,
            sellerPhone: result.sellerPhone,
            collectingRequestDetailStatus:
                CollectingRequestDetailStatus.approved,
            collectingAddress: result.collectingAddress,
            collectingAddressName: result.collectingAddressName,
          );
        }
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    } else if (event is ApproveRequestEvent) {
      try {
        var result = await futureAppDuration(
          _collectingRequestService.approveRequest(state.id),
        );

        if (result) {
          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
            approveEventStatus: ApproveEventStatus.success,
          );
        } else {
          throw Exception('result: false');
        }
      } on ApprovedByOtherCollectorException catch (e) {
        AppLog.info(e);
        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
          approveEventStatus: ApproveEventStatus.approvedByOther,
        );
      } on Exception catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    } else if (event is ConvertPendingIntoApproved) {
      try {
        yield CollectingRequestDetailState(
          id: state.id,
          status: FormzStatus.submissionInProgress,
          collectingRequestDetailStatus: CollectingRequestDetailStatus.approved,
        );

        var result = await futureAppDuration(
          _collectingRequestService.getApprovedRequest(state.id),
        );

        yield state.copyWith(
          id: result.id,
          gender: result.gender,
          isBulky: result.isBulky,
          latitude: result.latitude,
          longtitude: result.longtitude,
          note: result.note,
          scrapImageUrl: result.scrapImageUrl,
          time: result.time,
          sellerAvatarUrl: result.sellerAvatarUrl,
          sellerName: result.sellerName,
          collectingRequestCode: result.collectingRequestCode,
          status: FormzStatus.submissionSuccess,
          sellerPhone: result.sellerPhone,
          collectingRequestDetailStatus: CollectingRequestDetailStatus.approved,
          collectingAddress: result.collectingAddress,
          collectingAddressName: result.collectingAddressName,
        );
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    }
  }
}
