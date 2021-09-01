import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvAppSetting {
  static final String dev = 'assets/env/.env_dev';
  static final String testing = 'assets/env/.env_testing';
  static final String production = 'assets/env/.env_production';
}

class EnvBaseAppSettingValue {
  static String flavor = dotenv.env['FLAVOR'].toString();
  static String baseApiUrl = dotenv.env['BASE_API_URL'].toString();
}

class EnvID4AppSettingValue {
  static String apiUrl = dotenv.env['ID4_API_URL'].toString();
  static String clientId = dotenv.env['ID4_CLIENT_ID'].toString();
  static String clientSeret = dotenv.env['ID4_CLIENT_SECRET'].toString();
  static String scopeResource = dotenv.env['ID4_SCOPE_RESOURCE'].toString();
  static String scopeProfile = dotenv.env['ID4_SCOPE_PROFILE'].toString();
  static String scopeOpenId = dotenv.env['ID4_SCOPE_OPENID'].toString();
  static String scopeOfflineAccess =
      dotenv.env['ID4_SCOPE_OFFLINE_ACCESS'].toString();
  static String scopeRole = dotenv.env['ID4_SCOPE_ROLE'].toString();
  static String scopePhone = dotenv.env['ID4_SCOPE_PHONE'].toString();
  static String scopeIdCard = dotenv.env['ID4_SCOPE_ID_CARD'].toString();
  static String scopeEmail = dotenv.env['ID4_SCOPE_EMAIL'].toString();
  static String grantTypePassword =
      dotenv.env['ID4_GRANT_TYPE_PASSWORD'].toString();
  static String grantTypeOTP = dotenv.env['ID4_GRANT_TYPE_OTP'].toString();
}

class EnvMapSettingValue {
  static String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'].toString();
  static String apiUrl = dotenv.env['GOONG_MAP_API_URL'].toString();
  static String apiKey = dotenv.env['GOONG_MAP_API_KEY'].toString();
  static String mapStype = dotenv.env['GOONG_MAP_STYLE'].toString();
}
