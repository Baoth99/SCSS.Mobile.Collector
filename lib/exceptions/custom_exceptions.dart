import 'package:collector_app/constants/constants.dart';

class NotApprovedException implements Exception {
  final String cause;
  NotApprovedException([this.cause = Symbols.empty]);
}

class UnauthorizedException implements Exception {
  final String cause;
  UnauthorizedException([this.cause = Symbols.empty]);
}
