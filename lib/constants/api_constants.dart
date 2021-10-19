import 'package:collector_app/utils/env_util.dart';

class APIKeyConstants {
  static const accessToken = 'vechaixanh_collector_access_token';
  static const refreshToken = 'vechaixanh_collector_refresh_token';
}

class APIServiceURI {
  static final accountDeviceID =
      '${EnvBaseAppSettingValue.baseApiUrl}collector/account/device-id';
  static final imageGet = '${EnvBaseAppSettingValue.baseApiUrl}image/get';
  static final accountCollectorInfo =
      '${EnvBaseAppSettingValue.baseApiUrl}collector/account/collector-info';
  static final accountCoordinate =
      '${EnvBaseAppSettingValue.baseApiUrl}collector/account/coordinate';
  static final dealerSearch =
      '${EnvBaseAppSettingValue.baseApiUrl}dealer-info/search';
}

class IdentityAPIConstants {
  static final urlConnectToken = '${EnvID4AppSettingValue.apiUrl}connect/token';
  static final urlConnectRevocation =
      '${EnvID4AppSettingValue.apiUrl}connect/revocation';

  //Query parameter name
  static const clientIdParamName = 'client_id';
  static const clientSecretParamName = 'client_secret';
  static const grantTypeParamName = 'grant_type';
  static const scopeParamName = 'scope';
  static const usernameParamName = 'username';
  static const passwordParamName = 'password';
  static const token = 'token';
  static const tokenTypeHint = 'token_type_hint';

  //value
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';

  static const notApprovedAccountCode = 'ANA0001';
}

class CommonApiConstants {
  static const errorSystem = 'Có lỗi đến từ hệ thống';
  static const engErrorSystem = 'Error System';
}
