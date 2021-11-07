part of 'constants.dart';

double currentLatitude = 10.7756587;
double currentLongitude = 106.6808529;
String bearerToken = Symbols.empty;

class DeviceConstants {
  static const double logicalWidth = 1080;
  static const double logicalHeight = 2220;
}

class AppConstants {
  static const String appTitle = "Collector";
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
  static const String loginLogo = '$imagePath/collector_login_logo.png';
  static const String markerPoint = '$imagePath/marker_point.png';
  static const String notBulky = '$imagePath/not_bulky.png';
  static const String bulky = '$imagePath/bulky.png';
  static const String maleProfile = '$imagePath/male_profile.png';
  static const String femaleProfile = '$imagePath/female_profile.png';
  static const String createNewIcon = '$imagePath/newRequestIcon.png';
  static const String categoriesIcon = '$imagePath/categoryIcon.png';
  static const String dealerIcon = '$imagePath/dealerIcon.png';
  static const String noRequestAvailable = '$imagePath/noRequestAvailable.png';
  static const String qrcode = '$imagePath/qrcode.png';
  static const String splashScreen = '$imagePath/splash_screen.png';
  static const String placeSymbol = '$imagePath/place_symbol.png';
  static const String placeSymbolName = 'placeSymbol';
  static const String emptyActivityList = '$imagePath/empty_activity_list.png';
  static const String sellerLogo = '$imagePath/seller_logo.png';
  static const String sellerLogoName = 'sellerLogoName';
  static const String closeIcon = '$imagePath/closeIcon.png';
  static const String directionIcon = '$imagePath/directionIcon.png';
  static const String phoneIcon = '$imagePath/phoneIcon.png';
  static const String promotionIcon = '$imagePath/promotionIcon.png';
}

class SvgIcons {
  static const image =
      '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" aria-hidden="true" role="img" width="1em" height="1em" preserveAspectRatio="xMidYMid meet" viewBox="0 0 24 24"><g fill="none"><path d="M2 6a4 4 0 0 1 4-4h12a4 4 0 0 1 4 4v12a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V6z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><circle cx="8.5" cy="8.5" r="2.5" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M14.526 12.621L6 22h12.133A3.867 3.867 0 0 0 22 18.133V18c0-.466-.175-.645-.49-.99l-4.03-4.395a2 2 0 0 0-2.954.006z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></g></svg>';
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
  static const String vndSymbolText = 'đ';
}

class Others {
  static const int otpLength = 6;

  static final String ddMMyyyyPattern = 'dd-MM-yyyy';
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
  static const weekdayServer = <int, String>{
    0: 'CN',
    1: 'Th 2',
    2: 'Th 3',
    3: 'Th 4',
    4: 'Th 5',
    5: 'Th 6',
    6: 'Th 7',
  };
}

class CompareConstants {
  static const equal = 0;
  static const larger = 1;
  static const less = -1;
}

class NetworkConstants {
  static const urlencoded = 'application/x-www-form-urlencoded';
  static const applicationJson = 'application/json';
  static const postType = 'POST';

  // status code
  static const ok200 = 200;
  static const badRequest400 = 400;
  static const unauthorized401 = 401;
  static const notFound = 404;

  // pattern
  static const bearerPattern = 'Bearer $data';
  static const data = '{data}';
  static const basicAuth = 'Basic $data';
}

class FeedbackStatus {
  static const int haveNotGivenFeedbackYet = 1;
  static const int haveGivenFeedback = 2;
  static const int timeUpToGiveFeedback = 3;
}

class ComplaintStatus {
  static const int canNotGiveFeedback = 1;
  static const int canGiveFeedback = 2;
  static const int haveGivenFeedback = 3;
  static const int adminReplied = 4;
}

class ComplaintType {
  static const int seller = 1;
  static const int dealer = 2;
}
