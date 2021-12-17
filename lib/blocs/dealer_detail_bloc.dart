import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/dealer_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'events/dealer_detail_event.dart';
part 'states/dealer_detail_state.dart';

class DealerDetailBloc extends Bloc<DealerDetailEvent, DealerDetailState> {
  DealerDetailBloc({
    DealerService? dealerService,
}) : super(DealerDetailState()) {
    _dealerService =
        dealerService ?? getIt.get<DealerService>();
  }
  late final DealerService _dealerService;
  @override
  Stream<DealerDetailState> mapEventToState(
      DealerDetailEvent event) async* {
    if (event is DealerDetailInitial){
      if(state.status != FormzStatus.submissionInProgress) {
        try{
          yield state.copyWith(
            id: event.id,
            status: FormzStatus.submissionInProgress,
          );

          var result =
              await futureAppDuration(_dealerService.getDealerDetail(event.id));

          yield state.copyWith(
            id: result.id,
            dealerName: result.dealerName,
            dealerImageUrl: result.dealerImageUrl,
            dealerPhone: result.dealerPhone,
            rate: result.rate,
            openTime: result.openTime,
            closeTime: result.closeTime,
            dealerAddress: result.dealerAddress,
            latitude: result.latitude,
            longtitude: result.longtitude,
            status: FormzStatus.submissionSuccess,
          );
        } catch (e) {
          AppLog.error(e);
          yield state.copyWith(status: FormzStatus.submissionFailure);
        }
      }

    }
  }
}