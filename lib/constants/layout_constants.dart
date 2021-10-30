part of 'constants.dart';

class WidgetConstants {
  static const double buttonCommonFrontSize = 50;
  static const FontWeight buttonCommonFrontWeight = FontWeight.w500;
  static const double buttonCommonHeight = 120;
}

class MainLayoutConstants {
  static const statistic = 0;
  static const notification = 1;
  static const home = 2;
  static const activity = 3;
  static const account = 4;

  static const mainTabs = [
    statistic,
    notification,
    home,
    activity,
    account,
  ];
}

class ActivityLayoutConstants {
  static const bulkyImage = ImagesPaths.bulky;
  static const notBulkyImage = ImagesPaths.notBulky;

  static const cancelBySeller = 2;
  static const cancelByCollect = 3;
  static const approved = 4;
  static const completed = 5;
  static const cancelBySystem = 6;
}
