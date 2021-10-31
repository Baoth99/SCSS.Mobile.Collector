import 'dart:io';

import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/exceptions/custom_exceptions.dart';
import 'package:collector_app/providers/networks/models/request/account_coordinate_request_model.dart';
import 'package:collector_app/providers/networks/models/request/account_device_id_request_model.dart';
import 'package:collector_app/providers/networks/models/request/confirm_restore_password_request_model.dart';
import 'package:collector_app/providers/networks/models/request/connect_revocation_request_model.dart';
import 'package:collector_app/providers/networks/models/request/connect_token_request_model.dart';
import 'package:collector_app/providers/networks/models/request/restore_pass_otp_request_model.dart';
import 'package:collector_app/providers/networks/models/request/restore_password_request_model.dart';
import 'package:collector_app/providers/networks/models/response/base_response_model.dart';
import 'package:collector_app/providers/networks/models/response/confirm_restore_password_response_model.dart';
import 'package:collector_app/providers/networks/models/response/connect_token_response_model.dart';
import 'package:collector_app/providers/networks/models/response/profile_info_response_model.dart';
import 'package:collector_app/providers/networks/models/response/refresh_token_response_model.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:collector_app/utils/env_util.dart';
import 'package:http/http.dart';

abstract class IdentityServerNetwork {
  Future<ConnectTokenResponseModel?> connectToken(
    ConnectTokenRequestModel requestModel,
    Client client,
  );

  Future<bool> accountDeviceId(
    String deviceId,
    Client client,
  );

  Future<RefreshTokenResponseModel> refreshToken(
    String refreshToken,
    Client client,
  );

  Future<bool> connectRevocation(
    ConnectRevocationRequestModel requestModel,
    Client client,
  );

  Future<ProfileInfoResponseModel> getAccountInfo(Client client);

  Future<BaseResponseModel> updateCoordibate(
    AccountCoordinateRequestModel requestModel,
    Client client,
  );

  Future<int?> updatePassword(
    String id,
    String oldPassword,
    String newPassword,
    Client client,
  );

  Future<BaseResponseModel> restorePassOTP(
    RestorePassOtpRequestModel requestModel,
    Client client,
  );
  Future<ConfirmRestorePasswordResponseModel> confirmRestorePassword(
    ConfirmRestorePasswordRequestModel requestModel,
    Client client,
  );

  Future<BaseResponseModel> restorePassword(
    RestorePasswordRequestModel requestModel,
    Client client,
  );
}

class IdentityServerNetworkImpl implements IdentityServerNetwork {
  @override
  Future<BaseResponseModel> restorePassOTP(
      RestorePassOtpRequestModel requestModel, Client client) async {
    var response = await NetworkUtils.postBody(
      uri: APIServiceURI.restorePassOTP,
      headers: {
        HttpHeaders.contentTypeHeader: NetworkConstants.applicationJson,
      },
      body: restorePassOtpRequestModelToJson(
        requestModel,
      ),
      client: client,
    );

    var responseModel =
        await NetworkUtils.getModelOfResponseMainAPI<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<ConnectTokenResponseModel?> connectToken(
    ConnectTokenRequestModel requestModel,
    Client client,
  ) async {
    String scopeValue = CommonUtils.concatString(
      [
        EnvID4AppSettingValue.scopeResource,
        EnvID4AppSettingValue.scopeProfile,
        EnvID4AppSettingValue.scopeOpenId,
        EnvID4AppSettingValue.scopeOfflineAccess,
        EnvID4AppSettingValue.scopeRole,
        EnvID4AppSettingValue.scopePhone,
        EnvID4AppSettingValue.scopeIdCard,
        EnvID4AppSettingValue.scopeEmail,
      ],
      Symbols.space,
    );

    var body = <String, String>{
      IdentityAPIConstants.clientIdParamName: EnvID4AppSettingValue.clientId,
      IdentityAPIConstants.clientSecretParamName:
          EnvID4AppSettingValue.clientSeret,
      IdentityAPIConstants.grantTypeParamName:
          EnvID4AppSettingValue.grantTypePassword,
      IdentityAPIConstants.scopeParamName: scopeValue,
      IdentityAPIConstants.usernameParamName: requestModel.username,
      IdentityAPIConstants.passwordParamName: requestModel.password,
    };
    //send request
    var response = await NetworkUtils.postBody(
      uri: IdentityAPIConstants.urlConnectToken,
      body: body,
      client: client,
    );

    // convert
    // ignore: prefer_typing_uninitialized_variables
    ConnectTokenResponseModel responseModel;
    if (response.statusCode == NetworkConstants.ok200) {
      responseModel = connectToken200ResponseModelFromJson(response.body);
    } else if (response.statusCode == NetworkConstants.badRequest400) {
      if (response.body.contains(IdentityAPIConstants.notApprovedAccountCode)) {
        throw NotApprovedException();
      } else {
        responseModel = connectToken400ResponseModelFromJson(response.body);
      }
    } else {
      throw Exception(CommonApiConstants.engErrorSystem);
    }
    return responseModel;
  }

  @override
  Future<bool> accountDeviceId(String deviceId, Client client) async {
    var response = await NetworkUtils.putBodyWithBearerAuth(
      uri: APIServiceURI.accountDeviceID,
      headers: {
        HttpHeaders.contentTypeHeader: NetworkConstants.applicationJson,
      },
      body: accountDeviceIdRequestModelToJson(
        AccountDeviceIdRequestModel(
          deviceId: deviceId,
        ),
      ),
      client: client,
    );

    // get model
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel.isSuccess;
  }

  @override
  Future<RefreshTokenResponseModel> refreshToken(
      String refreshToken, Client client) async {
    var body = <String, String>{
      IdentityAPIConstants.clientIdParamName: EnvID4AppSettingValue.clientId,
      IdentityAPIConstants.clientSecretParamName:
          EnvID4AppSettingValue.clientSeret,
      IdentityAPIConstants.grantTypeParamName:
          IdentityAPIConstants.refreshToken,
      IdentityAPIConstants.refreshToken: refreshToken,
    };

    //send request
    var response = await NetworkUtils.postBody(
      uri: IdentityAPIConstants.urlConnectToken,
      body: body,
      client: client,
    );

    //convert to Json
    var responseModel =
        await NetworkUtils.getModelOfResponseMainAPI<RefreshTokenResponseModel>(
      response,
      refreshTokenResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<bool> connectRevocation(
      ConnectRevocationRequestModel requestModel, Client client) async {
    var header = <String, String>{
      HttpHeaders.authorizationHeader: NetworkUtils.getBasicAuth(),
    };

    //body
    var body = <String, String>{
      IdentityAPIConstants.token: requestModel.token,
      IdentityAPIConstants.tokenTypeHint: requestModel.tokenTypeHint,
    };

    //send request
    var response = await NetworkUtils.postBody(
      uri: IdentityAPIConstants.urlConnectRevocation,
      headers: header,
      body: body,
      client: client,
    );

    // convert
    var responseModel = false;
    if (response.statusCode == NetworkConstants.ok200) {
      responseModel = true;
    }
    return responseModel;
  }

  @override
  Future<ProfileInfoResponseModel> getAccountInfo(Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.accountCollectorInfo,
      client: client,
    );
    // get model
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<ProfileInfoResponseModel>(
      response,
      profileInfoResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<BaseResponseModel> updateCoordibate(
      AccountCoordinateRequestModel requestModel, Client client) async {
    var response = await NetworkUtils.putBodyWithBearerAuth(
      uri: APIServiceURI.accountCoordinate,
      headers: {
        HttpHeaders.contentTypeHeader: NetworkConstants.applicationJson,
      },
      body: accountCoordinateRequestModelToJson(requestModel),
      client: client,
    );

    // get model
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<int?> updatePassword(
    String id,
    String oldPassword,
    String newPassword,
    Client client,
  ) async {
    var body = <String, String>{
      'Id': id,
      'OldPassword': oldPassword,
      'NewPassword': newPassword,
    };
    //send request
    var response = await NetworkUtils.postBody(
      uri: IdentityAPIConstants.urlChangePassword,
      headers: {
        IdentityAPIConstants.clientIdParamName: EnvID4AppSettingValue.clientId,
      },
      body: body,
      client: client,
    );

    // convert
    // ignore: prefer_typing_uninitialized_variables
    BaseResponseModel responseModel;
    if (response.statusCode == NetworkConstants.ok200) {
      responseModel = BaseResponseModel.fromJson(
        await NetworkUtils.getMapFromResponse(response),
      );
      if (responseModel.isSuccess) {
        return NetworkConstants.ok200;
      } else {
        return NetworkConstants.badRequest400;
      }
    }

    return null;
  }

  @override
  Future<ConfirmRestorePasswordResponseModel> confirmRestorePassword(
    ConfirmRestorePasswordRequestModel requestModel,
    Client client,
  ) async {
    var response = await NetworkUtils.postBody(
      uri: APIServiceURI.confirmRestorePassOTP,
      headers: {
        IdentityAPIConstants.clientIdParamName: EnvID4AppSettingValue.clientId,
      },
      body: requestModel.toJson(),
      client: client,
    );

    var responseModel = await NetworkUtils.getModelOfResponseMainAPI<
        ConfirmRestorePasswordResponseModel>(
      response,
      confirmRestorePasswordResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<BaseResponseModel> restorePassword(
    RestorePasswordRequestModel requestModel,
    Client client,
  ) async {
    var response = await NetworkUtils.postBody(
      uri: APIServiceURI.restorePassword,
      headers: {
        IdentityAPIConstants.clientIdParamName: EnvID4AppSettingValue.clientId,
      },
      body: requestModel.toJson(),
      client: client,
    );

    var responseModel =
        await NetworkUtils.getModelOfResponseMainAPI<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }
}
