import 'package:collector_app/blocs/models/gender_model.dart';
import 'package:collector_app/blocs/profile_bloc.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/networks/identity_server_network.dart';
import 'package:collector_app/providers/networks/models/request/account_coordinate_request_model.dart';
import 'package:collector_app/providers/networks/models/request/connect_revocation_request_model.dart';
import 'package:collector_app/providers/networks/models/request/connect_token_request_model.dart';
import 'package:collector_app/providers/networks/models/response/connect_token_response_model.dart';
import 'package:collector_app/providers/services/map_service.dart';
import 'package:collector_app/providers/services/models/get_token_service_model.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:http/http.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

abstract class IdentityServerService {
  Future<GetTokenServiceModel> getToken(
    String username,
    String password,
  );
  Future<bool> updateDeviceId(String deviceId);

  Future<bool> refreshToken();

  Future<bool> connectRevocation();

  Future<ProfileState?> getProfile();

  Future<bool> updateCooridnate();
}

class IdentityServerServiceImpl implements IdentityServerService {
  late IdentityServerNetwork _identityServerNetwork;

  IdentityServerServiceImpl({IdentityServerNetwork? identityServerNetwork}) {
    _identityServerNetwork =
        identityServerNetwork ?? getIt.get<IdentityServerNetwork>();
  }

  @override
  Future<GetTokenServiceModel> getToken(
      String username, String password) async {
    //create raw
    var serviceModel = const GetTokenServiceModel();

    var client = Client();
    //take responseMOdel
    var responseModel = await _identityServerNetwork
        .connectToken(
      ConnectTokenRequestModel(
        username: username,
        password: password,
      ),
      client,
    )
        .whenComplete(() {
      client.close();
    });

    //check responsemodel
    if (responseModel != null) {
      if (responseModel is ConnectToken200ResponseModel) {
        serviceModel = GetTokenServiceModel(
          accessToken: responseModel.accessToken,
          refreshToken: responseModel.refreshToken,
        );
      } else if (responseModel is ConnectToken400ResponseModel) {
        serviceModel = const GetTokenServiceModel(
          accessToken: Symbols.empty,
          refreshToken: Symbols.empty,
        );
      }
    } else {
      throw Exception(CommonApiConstants.engErrorSystem);
    }
    return serviceModel;
  }

  @override
  Future<bool> updateDeviceId(String deviceId) async {
    Client client = Client();

    bool result = await _identityServerNetwork
        .accountDeviceId(deviceId, client)
        .whenComplete(() => client.close());

    return result;
  }

  @override
  Future<bool> refreshToken() async {
    Client client = Client();

    try {
      // revoke access Token
      var fGetStringAccessToken =
          SharedPreferenceUtils.getString(APIKeyConstants.accessToken)
              .then((value) async {
        if (value != null && value.isNotEmpty) {
          return await _identityServerNetwork.connectRevocation(
            ConnectRevocationRequestModel(
              token: value,
              tokenTypeHint: IdentityAPIConstants.accessToken,
            ),
            client,
          );
        }
      }).whenComplete(
        () => SharedPreferenceUtils.remove(APIKeyConstants.accessToken),
      );

      //get refresh Token
      var fGetStringRefreshToken =
          SharedPreferenceUtils.getString(APIKeyConstants.refreshToken)
              .then((value) async {
        if (value != null && value.isNotEmpty) {
          return await _identityServerNetwork.refreshToken(value, client);
        }
      }).whenComplete(
        () => SharedPreferenceUtils.remove(APIKeyConstants.refreshToken),
      );

      //wait till two of this success
      // ignore: unused_local_variable
      var getStringAccessToken = await fGetStringAccessToken;

      var responseModle = await fGetStringRefreshToken;

      // should delete in shared Disk

      if (responseModle != null &&
          responseModle.accessToken != null &&
          responseModle.accessToken!.isNotEmpty &&
          responseModle.refreshToken != null &&
          responseModle.refreshToken!.isNotEmpty) {
        var resultAT = SharedPreferenceUtils.setString(
            APIKeyConstants.accessToken, responseModle.accessToken!);

        var resultRT = SharedPreferenceUtils.setString(
            APIKeyConstants.refreshToken, responseModle.refreshToken!);

        return await resultAT && await resultRT;
      }
    } finally {
      client.close();
    }
    return false;
  }

  @override
  Future<bool> connectRevocation() async {
    Client client = Client();
    var result = false;
    try {
      // revoke future access toekn;
      var resultRevokeAccessToken =
          SharedPreferenceUtils.getString(APIKeyConstants.accessToken)
              .then((value) async {
        if (value != null && value.isNotEmpty) {
          return await _identityServerNetwork.connectRevocation(
            ConnectRevocationRequestModel(
              token: value,
              tokenTypeHint: IdentityAPIConstants.accessToken,
            ),
            client,
          );
        }
      }).onError((error, stackTrace) => false);

      // revoke future refresh toekn;
      var resultRevokeRefreshToken =
          SharedPreferenceUtils.getString(APIKeyConstants.refreshToken)
              .then((value) async {
        if (value != null && value.isNotEmpty) {
          return await _identityServerNetwork.connectRevocation(
            ConnectRevocationRequestModel(
              token: value,
              tokenTypeHint: IdentityAPIConstants.refreshToken,
            ),
            client,
          );
        }
      }).onError((error, stackTrace) => false);

      // result
      result = (await resultRevokeAccessToken ?? false) &&
          (await resultRevokeRefreshToken ?? false);
    } finally {
      client.close();
    }
    return result;
  }

  @override
  Future<ProfileState?> getProfile() async {
    Client client = Client();
    ProfileState? result;
    var responseModel = await _identityServerNetwork
        .getAccountInfo(client)
        .whenComplete(() => client.close());
    var m = responseModel.resData;
    if (m != null) {
      result = ProfileState(
        id: m.id,
        name: m.name ?? Symbols.empty,
        address: m.address,
        birthDate: m.birthDate == null
            ? null
            : CommonUtils.convertDDMMYYYToDateTime(m.birthDate!),
        email: m.email,
        gender: m.gender == 1 ? Gender.male : Gender.female,
        image: m.image,
        phone: m.phone ?? Symbols.empty,
        totalPoint: m.totalPoint ?? 0,
        idCard: m.idCard ?? Symbols.empty,
        rate: m.rate ?? 0,
      );
    }

    return result;
  }

  @override
  Future<bool> updateCooridnate() async {
    Client client = Client();
    final latLng = await acquireCurrentLocation();
    if (latLng != null) {
      // update current position
      currentLatitude = latLng.latitude;
      currentLongitude = latLng.longitude;

      var resonseModle = await _identityServerNetwork
          .updateCoordibate(
            AccountCoordinateRequestModel(
                latitude: latLng.latitude, longitude: latLng.longitude),
            client,
          )
          .whenComplete(
            () => client.close(),
          );
      return resonseModle.isSuccess &&
          resonseModle.statusCode == NetworkConstants.ok200;
    }

    return false;
  }
}
