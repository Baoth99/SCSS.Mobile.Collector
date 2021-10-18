import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/networks/identity_server_network.dart';
import 'package:collector_app/providers/networks/models/request/connect_token_request_model.dart';
import 'package:collector_app/providers/networks/models/response/connect_token_response_model.dart';
import 'package:collector_app/providers/services/models/get_token_service_model.dart';
import 'package:http/http.dart';

abstract class IdentityServerService {
  Future<GetTokenServiceModel> getToken(
    String username,
    String password,
  );
  Future<bool> updateDeviceId(String deviceId);

  Future<bool> refreshToken();
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
  Future<bool> refreshToken() {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }
}
