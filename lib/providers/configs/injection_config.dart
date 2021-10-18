import 'package:collector_app/providers/networks/identity_server_network.dart';
import 'package:collector_app/providers/services/firebase_service.dart';
import 'package:collector_app/providers/services/identity_server_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void configureDependencies() async {
  // Network
  getIt.registerLazySingleton<IdentityServerNetwork>(
    () => IdentityServerNetworkImpl(),
  );

  // Service
  getIt.registerLazySingleton<IdentityServerService>(
    () => IdentityServerServiceImpl(),
  );
  getIt.registerSingleton<FirebaseNotification>(FirebaseNotification());
}
