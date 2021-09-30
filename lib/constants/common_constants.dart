part of 'constants.dart';

class DeviceConstants {
  static const double logicalWidth = 1080;
  static const double logicalHeight = 2220;
}

class AppConstants {
  static const String appTitle = "Seller";
  static const Color primaryColor = AppColors.greenFF61C53D;
  static const Color accentColor = AppColors.greenFF61C53D;
  static const double horizontalScaffoldMargin = 48.0;
}

class AppIcons {
  static const IconData arrowBack = Icons.arrow_back_ios_new_outlined;
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;
  static const IconData place = Icons.place;
  static const IconData event = Icons.event;
  static const IconData feedOutlined = Icons.feed_outlined;
  static const IconData search = Icons.search;
}

class ImagesPaths {
  static const String imagePath = 'assets/images';
  static const String loginLogo = '$imagePath/seller_login_logo.png';
  static const String markerPoint = '$imagePath/marker_point.png';
  static const String notBulky = '$imagePath/not_bulky.png';
  static const String bulky = '$imagePath/bulky.png';
  static const String maleProfile = '$imagePath/male_profile.png';
  static const String femaleProfile = '$imagePath/female_profile.png';
}

class Symbols {
  static const String vietnamLanguageCode = 'vi';
  static const String forwardSlash = '/';
  static const String vietnamISOCode = 'VN';
  static const String vietnamCallingCode = '+84';
  static const String empty = '';
  static const String space = ' ';
  static const String comma = ',';
  static const String minus = '-';
}

class Others {
  static const int otpLength = 6;
}

class VietnameseDate {
  static const today = 'Hôm nay';
  static const tomorrow = 'Ngày mai';
  static const weekdayParam = '{weekday}';
  static const dayParam = '{day}';
  static const monthParam = '{month}';

  static const pattern = '$weekdayParam, $dayParam thg $monthParam';

  static const weekdayMap = <int, String>{
    DateTime.monday: 'Th 2',
    DateTime.tuesday: 'Th 3',
    DateTime.wednesday: 'Th 4',
    DateTime.thursday: 'Th 5',
    DateTime.friday: 'Th 6',
    DateTime.saturday: 'Th 7',
    DateTime.sunday: 'CN',
  };
}

class CompareConstants {
  static const equal = 0;
  static const larger = 1;
  static const less = -1;
}

class NetworkConstants {
  static const urlencoded = 'application/x-www-form-urlencoded';
  static const postType = 'POST';

  // status code
  static const ok200 = 200;
  static const badRequest400 = 400;

  // pattern
  static const base64Data = '{base64Data}';
  static const basicAuth = 'Basic $base64Data';
}
