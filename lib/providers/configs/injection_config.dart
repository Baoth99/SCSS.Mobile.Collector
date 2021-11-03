import 'package:collector_app/providers/networks/dealer_network.dart';
import 'package:collector_app/providers/networks/identity_server_network.dart';
import 'package:collector_app/providers/networks/request_network.dart';
import 'package:collector_app/providers/networks/transaction_network.dart';
import 'package:collector_app/providers/services/collecting_request_service.dart';
import 'package:collector_app/providers/services/data_service.dart';
import 'package:collector_app/providers/services/dealer_service.dart';
import 'package:collector_app/providers/services/firebase_service.dart';
import 'package:collector_app/providers/services/identity_server_service.dart';
import 'package:collector_app/providers/services/scrap_category_service.dart';
import 'package:collector_app/providers/services/transaction_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void configureDependencies() async {
  // Network
  getIt.registerLazySingleton<IdentityServerNetwork>(
    () => IdentityServerNetworkImpl(),
  );
  getIt.registerLazySingleton<DealerNetwork>(
    () => DealerNetworkImpl(),
  );
  getIt.registerLazySingleton<CollectingRequestNetwork>(
    () => CollectingRequestNetworkImpl(),
  );
  getIt.registerLazySingleton<TransactionNetwork>(
    () => TransactionNetworkImpl(),
  );

  // Service
  getIt.registerLazySingleton<IdentityServerService>(
    () => IdentityServerServiceImpl(),
  );

  getIt.registerLazySingleton<DealerService>(
    () => DealerServiceImpl(),
  );
  getIt.registerLazySingleton<CollectingRequestService>(
    () => CollectingRequestServiceImpl(),
  );
  getIt.registerLazySingleton<TransactionService>(
    () => TransactionServiceImpl(),
  );
  getIt.registerSingleton<FirebaseNotification>(FirebaseNotification());
  getIt.registerSingleton<IDataService>(DataService());
  getIt.registerSingleton<IScrapCategoryService>(ScrapCategoryService());
}
