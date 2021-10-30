import 'package:collector_app/utils/env_util.dart';

class APIKeyConstants {
  static const accessToken = 'vechaixanh_collector_access_token';
  static const refreshToken = 'vechaixanh_collector_refresh_token';
}

class APIServiceURI {
  static final apiUrl = '${EnvBaseAppSettingValue.baseApiUrl}api/v4/';

  static final accountDeviceID = '${apiUrl}collector/account/device-id';
  static final imageGet = '${apiUrl}image/get';
  static final accountCollectorInfo =
      '${apiUrl}collector/account/collector-info';
  static final accountCoordinate = '${apiUrl}collector/account/coordinate';
  static final dealerSearch = '${apiUrl}dealer-info/search';
  static final hubColellectingRequest =
      '${EnvBaseAppSettingValue.baseApiUrl}hubs/collector/collecting-request';
  static final appointments = '${apiUrl}collecting-request/appointments';
  static final currentRequest = '${apiUrl}collecting-request/current-requests';
  static final collectingRequestDetail = '${apiUrl}collecting-request/detail';
  static final collectingRequestReceive = '${apiUrl}collecting-request/receive';
  static final collectingRequestReceiveDetail =
      '${apiUrl}collecting-request/receive/detail';
  static final collectingRequestReceiveGet =
      '${apiUrl}collecting-request/receive/get';
  static final cancelReasons = '${apiUrl}collecting-request/cancel-reasons';
  static final cancelRequest = '${apiUrl}collecting-request/cancel';
  static final sellerActivityHistory =
      '${apiUrl}transaction/sell-colect/histories';
  static final dealerActivityHistory =
      '${apiUrl}transaction/collect-deal/histories';
}

class IdentityAPIConstants {
  static final urlConnectToken = '${EnvID4AppSettingValue.apiUrl}connect/token';
  static final urlConnectRevocation =
      '${EnvID4AppSettingValue.apiUrl}connect/revocation';
  static final urlChangePassword =
      '${EnvID4AppSettingValue.apiUrl}api/identity/account/change-password';

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
  static const isApprovedBuOtherCollector = 'ICR0001';
}

class CommonApiConstants {
  static const errorSystem = 'Có lỗi đến từ hệ thống';
  static const engErrorSystem = 'Error System';
}
