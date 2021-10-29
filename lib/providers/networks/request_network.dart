import 'dart:io';

import 'package:collector_app/blocs/models/cancel_reason_model.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/exceptions/custom_exceptions.dart';
import 'package:collector_app/providers/networks/models/request/cancel_request_request_model.dart';
import 'package:collector_app/providers/networks/models/response/approve_request_detail_response_mode.dart';
import 'package:collector_app/providers/networks/models/response/approve_response_model.dart';
import 'package:collector_app/providers/networks/models/response/base_response_model.dart';
import 'package:collector_app/providers/networks/models/response/cancel_reason_response_mode.dart';
import 'package:collector_app/providers/networks/models/response/collecting_request_detail_response_model.dart';
import 'package:collector_app/providers/networks/models/response/collecting_request_response_model.dart';
import 'package:collector_app/providers/networks/models/response/receive_get_response_model.dart';
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

  Future<CollectingRequestDetailResponseModel> getCollectingRequestDetail(
      String id, Client client);
  Future<ApproveResponseModel> approveRequest(String id, Client client);
  Future<ApproveRequestDetailResponseModel> getApprovedRequestDetail(
      String id, Client client);

  Future<ReceiveGetResponseModel> getReceiveRequets(
    String sellerPhone,
    double lat,
    double lag,
    int page,
    int pageSize,
    Client client,
  );

  Future<CancelReasonResponseModel> getCancelReason(Client client);
  Future<BaseResponseModel> cancelRequest(
      CancelRequestRequestModel requestModel, Client client);
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

  @override
  Future<CollectingRequestDetailResponseModel> getCollectingRequestDetail(
      String id, Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.collectingRequestDetail,
      client: client,
      queries: {
        'id': id,
      },
    );

    if (response.statusCode == NetworkConstants.ok200) {
      // get model
      var responseModel =
          await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
              CollectingRequestDetailResponseModel>(
        response,
        collectingRequestDetailResponseModelFromJson,
      );
      return responseModel;
    } else if (response.statusCode == NetworkConstants.notFound) {
      throw NotFoundException();
    } else {
      throw Exception('Exception getCollectingRequestDetail');
    }
  }

  @override
  Future<ApproveResponseModel> approveRequest(String id, Client client) async {
    String url = NetworkUtils.toStringUrl(
        APIServiceURI.collectingRequestReceive, {"id": id});
    var response = await NetworkUtils.putBodyWithBearerAuth(
      uri: url,
      client: client,
    );

    if (response.statusCode == NetworkConstants.ok200) {
      // get model
      var responseModel = approveResponseModelFromJson(response.body);
      return responseModel;
    } else {
      throw Exception('Exception approveRequest');
    }
  }

  @override
  Future<ApproveRequestDetailResponseModel> getApprovedRequestDetail(
      String id, Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.collectingRequestReceiveDetail,
      client: client,
      queries: {
        'id': id,
      },
    );

    if (response.statusCode == NetworkConstants.ok200) {
      // get model
      var responseModel =
          await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
              ApproveRequestDetailResponseModel>(
        response,
        approveRequestDetailResponseModelFromJson,
      );
      return responseModel;
    } else if (response.statusCode == NetworkConstants.notFound) {
      throw NotFoundException();
    } else {
      throw Exception('Exception getApprovedRequestDetail');
    }
  }

  @override
  Future<ReceiveGetResponseModel> getReceiveRequets(
    String sellerPhone,
    double lat,
    double lag,
    int page,
    int pageSize,
    Client client,
  ) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.collectingRequestReceiveGet,
      client: client,
      queries: {
        'SellerPhone': sellerPhone,
        'OriginLatitude': lat.toString(),
        'OriginLongtitude': lag.toString(),
        'Page': page.toString(),
        'PageSize': pageSize.toString(),
      },
    );

    // get model
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<ReceiveGetResponseModel>(
      response,
      receiveGetResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<CancelReasonResponseModel> getCancelReason(Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.cancelReasons,
      client: client,
    );

    // get model
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<CancelReasonResponseModel>(
      response,
      cancelReasonResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<BaseResponseModel> cancelRequest(
      CancelRequestRequestModel requestModel, Client client) async {
    var response = await NetworkUtils.putBodyWithBearerAuth(
      uri: APIServiceURI.cancelRequest,
      client: client,
      headers: {
        HttpHeaders.contentTypeHeader: NetworkConstants.applicationJson,
      },
      body: cancelRequestRequestModelToJson(requestModel),
    );

    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }
}
