import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/dealer_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'events/promotion_event.dart';
part 'states/promotion_state.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  PromotionBloc({DealerService? dealerService, required String dealerId})
      : super(PromotionState(
          dealerId: dealerId,
        )) {
    _dealerService = dealerService ?? getIt.get<DealerService>();
  }

  late final DealerService _dealerService;

  @override
  Stream<PromotionState> mapEventToState(PromotionEvent event) async* {
    if (event is PromotionInitial) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        var result = await futureAppDuration(
          _dealerService.getPromotions(
            state.dealerId,
          ),
        );

        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
          listPromotion: result,
        );
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
