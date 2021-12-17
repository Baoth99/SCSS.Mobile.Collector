import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/transaction_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:collector_app/utils/extension_methods.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'states/statistic_state.dart';
part 'events/statistic_event.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  StatisticBloc({TransactionService? transactionService})
      : super(StatisticState()) {
    _transactionService = transactionService ?? getIt.get<TransactionService>();
  }

  late final TransactionService _transactionService;

  @override
  Stream<StatisticState> mapEventToState(StatisticEvent event) async* {
    if (event is StatisticGet) {
      try {
        yield state.copyWith(status: FormzStatus.submissionInProgress);
        var data = await futureAppDuration(
          _transactionService.getStatistic(state.fromDate, state.toDate),
        );

        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
          statisticData: data,
        );
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    } else if (event is StatisticChanged) {
      yield state.copyWith(
        fromDate: event.fromDate.onlyDate(),
        toDate: event.toDate.onlyDate(),
      );
      add(StatisticGet());
    }
  }
}
