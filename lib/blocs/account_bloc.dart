import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/firebase_service.dart';
import 'package:collector_app/providers/services/identity_server_service.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'events/account_event.dart';
part 'states/account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  late IdentityServerService _identityServerService;
  AccountBloc({IdentityServerService? identityServerService})
      : super(const AccountState()) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is LogoutEvent) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        var result = await _identityServerService.connectRevocation();

        if (result) {
          if (await SharedPreferenceUtils.remove(APIKeyConstants.accessToken) &&
              await SharedPreferenceUtils.remove(
                  APIKeyConstants.refreshToken)) {
            yield state.copyWith(
              status: FormzStatus.submissionSuccess,
            );
            FirebaseNotification.removeMessagingHandler();
          } else {
            throw Exception();
          }
        } else {
          throw Exception();
        }
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    }
  }
}
