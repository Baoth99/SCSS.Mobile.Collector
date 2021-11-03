import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/providers/networks/models/response/base_response_model.dart';
import 'package:collector_app/providers/networks/models/response/notification_get_response_model.dart';
import 'package:collector_app/providers/networks/models/response/notification_unread_count_response_model.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:http/http.dart';

abstract class NotificationNetwork {
  Future<NotificationGetResponseModel> getNotification(
    int page,
    int pageSize,
    Client client,
  );

  Future<NotificationUnreadCountResponseModel> getUnreadCount(Client client);

  Future<BaseResponseModel> readNotification(String id, Client client);
}

class NotificationNetworkImpl extends NotificationNetwork {
  @override
  Future<NotificationGetResponseModel> getNotification(
    int page,
    int pageSize,
    Client client,
  ) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.notificationGet,
      client: client,
      queries: {
        'Page': page.toString(),
        'PageSize': pageSize.toString(),
      },
    );
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            NotificationGetResponseModel>(
      response,
      notificationGetResponseModelFromJson,
    );
    // get model

    return responseModel;
  }

  @override
  Future<NotificationUnreadCountResponseModel> getUnreadCount(
      Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.notificationUnreadCount,
      client: client,
    );
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            NotificationUnreadCountResponseModel>(
      response,
      notificationUnreadCountResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<BaseResponseModel> readNotification(String id, Client client) async {
    String url =
        NetworkUtils.toStringUrl(APIServiceURI.notificationRead, {"id": id});

    var response = await NetworkUtils.putBodyWithBearerAuth(
      uri: url,
      client: client,
    );
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }
}
