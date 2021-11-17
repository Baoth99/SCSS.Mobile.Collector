import 'package:collector_app/blocs/models/scrap_category_model.dart';
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
  static final dealerDetail = '${apiUrl}dealer-info/detail';
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
  static final sellerTransactionDetail =
      '${apiUrl}transaction/sell-colect/history-detail';
  static final complainSellCollectTransaction =
      '${apiUrl}complaint/collecting-request';
  static final dealerActivityHistory =
      '${apiUrl}transaction/collect-deal/histories';
  static final dealerTransactionDetail =
      '${apiUrl}transaction/collect-deal/history-detail';
  static final feedbackDealerTransaction =
      '${apiUrl}feedback/trans-feedback/create';
  static final complainCollectDealTransaction =
      '${apiUrl}complaint/colect-deal-trans';

  static final restorePassOTP = '${apiUrl}collector/account/restore-pass-otp';
  static final confirmRestorePassOTP =
      '${EnvID4AppSettingValue.apiUrl}api/identity/account/confirm-otp';
  static final restorePassword =
      '${EnvID4AppSettingValue.apiUrl}api/identity/account/restore-password';

  static final getStatistic = '${apiUrl}statistic/get';
  /* Thien */
  static const String apiUrlGetScrapCategoriesFromData =
      '/api/v4/trans/scrap-categories';
  static const String apiUrlGetScrapCategoryDetails =
      '/api/v4/trans/scrap-category-detail';
  static const String apiUrlGetCollectorPhones =
      '/api/v4/auto-complete/collector-phone';
  static const String apiUrlGetImage = '/api/v4/image/get';
  static const String apiUrlPostImage = '/api/v4/scrap-category/upload-image';
  static const String apiUrlGetCheckScrapCategoryName =
      '/api/v4/scrap-category/check-name';
  static const String apiUrlPostScrapCategory = '/api/v4/scrap-category/create';
  static const String apiUrlPutScrapCategory = '/api/v4/scrap-category/update';
  static const String apiUrlGetScrapCategoriesFromScrapCategory =
      '/api/v4/scrap-category/get';
  static const String apiUrlGetScrapCategorDetailFromScrapCategory =
      '/api/v4/scrap-category/get-detail';
  static const String apiUrlDeleteScrapCategory =
      '/api/v4/scrap-category/remove';
  static const String apiUrlPostSellCollectTransaction =
      '/api/v4/transaction/sell-colect/create';
  static const String apiUrlGetSellCollectTransactionInfoReview =
      '/api/v4/transaction/sell-colect/info-review';
  /* Thien */
  static final notificationGet = '${apiUrl}notification/get';
  static final notificationUnreadCount = '${apiUrl}notification/unread-count';
  static final notificationRead = '${apiUrl}notification/read';
  static final registerOTP = '${apiUrl}collector/account/register-otp';
  static final confirmOTPRegister =
      '${EnvID4AppSettingValue.apiUrl}api/identity/account/confirm-otp-register';
  static final register = '${apiUrl}collector/account/register';
  static final dealerInfoPromotion = '${apiUrl}dealer-info/promotions';
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
  /* Thien */
  static const String getScrapCategoriesFailedException =
      'Failed to get scrap categories';
  static const String getScrapCategoryDetailsFailedException =
      'Failed to get scrap category details';
  static const String getCollectorPhonesFailedException =
      'Failed to get collector phones';
  static const String getImageFailedException = 'Failed to Get Image';
  static const String postImageFailedException = 'Failed to Post Image';
  static const String getInfoReviewException =
      'Failed to get info review at transaction network';

  static final unnamedScrapCategory = ScrapCategoryModel.createTransactionModel(
    id: '00000000-0000-0000-0000-000000000000',
    appliedAmount: null,
    name: 'Chưa phân loại',
    bonusAmount: null,
  );
  /* Thien */
}
