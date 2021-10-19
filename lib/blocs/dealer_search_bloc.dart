import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/dealer_service.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
part 'states/dealer_search_state.dart';
part 'events/dealer_search_event.dart';

class DealerSearchBloc extends Bloc<DealerSearchEvent, DealerSearchState> {
  DealerSearchBloc({
    DealerService? dealerService,
  }) : super(DealerSearchState()) {
    _dealerService = dealerService ?? getIt.get<DealerService>();
  }
  late final DealerService _dealerService;
  @override
  Stream<DealerSearchState> mapEventToState(DealerSearchEvent event) async* {
    if (event is DealerSearch) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );
        var listDealer = await _dealerService.getDealers(
          event.search,
          20,
          currentLatitude,
          currentLongitude,
          1,
          100,
        );

        yield state.copyWith(
          listDealers: listDealer,
          status: FormzStatus.submissionSuccess,
        );
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    } else if (event is DealerSearchInitialEvent) {
      add(DealerSearch(Symbols.empty));
    }
  }
}
