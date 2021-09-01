import 'package:collector_app/providers/services/firebase_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void configureDependencies() async {
  getIt.registerSingleton<FirebaseNotification>(FirebaseNotification());
}
