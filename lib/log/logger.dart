import 'package:logger/logger.dart';

class AppLog {
  static Logger? _logger;

  static Logger _getInstance() {
    _logger ??= Logger();

    return _logger!;
  }

  static error(dynamic message) {
    var logger = _getInstance();
    logger.e(message);
  }

  static info(dynamic message) {
    var logger = _getInstance();
    logger.i(message);
  }

  static warning(dynamic message) {
    var logger = _getInstance();
    logger.w(message);
  }
}
