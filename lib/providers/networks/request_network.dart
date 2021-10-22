import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/providers/networks/models/response/collecting_request_response_model.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:http/http.dart';

abstract class CollectingRequestNetwork {
  Future<CollectingRequestResponseModel> getCollectingRequests(
    double lat,
    double lag,
    int page,
    int pageSize,
    Client client,
  );
  Future<CollectingRequestResponseModel> getBookingRequests(
    double lat,
    double lag,
    int page,
    int pageSize,
    Client client,
  );
}

class CollectingRequestNetworkImpl implements CollectingRequestNetwork {
  @override
  Future<CollectingRequestResponseModel> getCollectingRequests(
    double lat,
    double lag,
    int page,
    int pageSize,
    Client client,
  ) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.currentRequest,
      client: client,
      queries: {
        'OriginLatitude': lat.toString(),
        'OriginLongtitude': lag.toString(),
        'Page': page.toString(),
        'PageSize': pageSize.toString(),
      },
    );

    // get model
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            CollectingRequestResponseModel>(
      response,
      collectingRequestResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<CollectingRequestResponseModel> getBookingRequests(
      double lat, double lag, int page, int pageSize, Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.appointments,
      client: client,
      queries: {
        'OriginLatitude': lat.toString(),
        'OriginLongtitude': lag.toString(),
        'Page': page.toString(),
        'PageSize': pageSize.toString(),
      },
    );

    // get model
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            CollectingRequestResponseModel>(
      response,
      collectingRequestResponseModelFromJson,
    );
    return responseModel;
  }
}
