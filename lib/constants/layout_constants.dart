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

class OTPFillPhoneNumberLayoutConstants {
  static const String title = 'Nhập mã gồm 6 chữ số đã gửi tới';
  static const String notHaveCode = 'Chưa nhận được mã?';

  static const String hintText = '000000';
  static const int inputLength = Others.otpLength;
  static const int countdown = 30;

  static const String requetsNewCode =
      'Yêu cầu mã mới trong 00:$replacedSecondVar';
  static const String replacedSecondVar = '{second}';

  static const String checking = 'Đang kiểm tra.';
  static const String checkingProgressIndicator = 'Checking Progress Indicator';

  static const String resendOTP = 'Đang gửi lại mã OTP';
  static const String resendOTPProgressIndicator =
      'Resend OTP Progress Indicator';
}
