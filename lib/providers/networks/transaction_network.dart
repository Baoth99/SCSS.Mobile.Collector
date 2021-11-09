import 'dart:convert';
import 'dart:io';

import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/providers/networks/models/request/create_collect_deal_transaction_request_model.dart.dart';
import 'package:collector_app/providers/networks/models/request/feedback_dealer_transaction_request_model.dart';
import 'package:collector_app/providers/networks/models/response/base_response_model.dart';
import 'package:collector_app/providers/networks/models/response/dealer_transaction_detail_response_model.dart';
import 'package:collector_app/providers/networks/models/response/dealer_transaction_response_model.dart';
import 'package:collector_app/providers/networks/models/response/get_statistic_response_model.dart';
import 'package:collector_app/providers/networks/models/response/sell_collect_complaint_request_model.dart';
import 'package:collector_app/providers/networks/models/response/seller_transaction_detail_response_model.dart';
import 'package:collector_app/providers/networks/models/response/seller_transaction_response_model.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:collector_app/utils/env_util.dart';
import 'package:http/http.dart';
import 'package:collector_app/utils/extension_methods.dart';
import 'package:http/http.dart' as http;

abstract class TransactionNetwork {
  Future<SellerTransactionResponseModel> getSellerTransaction(
    int page,
    int size,
    Client client,
  );
  Future<DealerTransactionResponseModel> getDealerTransaction(
    int page,
    int size,
    Client client,
  );

  Future<SellerTransactionDetailResponseModel> getSellerTransactionDetail(
    String id,
    Client client,
  );
  Future<DealerTransactionDetailResponseModel> getDealerTransactionDetail(
    String id,
    Client client,
  );
  Future<BaseResponseModel> feedbackDealerTransaction(
      FeedbackDealerTransactionRequestModel requestModel, Client client);
  Future<GetStatisticResponseModel> getStatistic(
    DateTime fromDate,
    DateTime toDate,
    Client client,
  );
  Future<BaseResponseModel> createCollectDealComplaint(
      CreateCollectDealTransactionRequestModel requestModel, Client client);
  Future<BaseResponseModel> createSellCollectComplaint(
      SellCollectComplaintRequestModel requestModel, Client client);
}

class TransactionNetworkImpl implements TransactionNetwork {
  @override
  Future<SellerTransactionResponseModel> getSellerTransaction(
      int page, int size, Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.sellerActivityHistory,
      client: client,
      queries: {
        'Page': page.toString(),
        'PageSize': size.toString(),
      },
    );
    // get model
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            SellerTransactionResponseModel>(
      response,
      sellerTransactionResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<DealerTransactionResponseModel> getDealerTransaction(
      int page, int size, Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.dealerActivityHistory,
      client: client,
      queries: {
        'Page': page.toString(),
        'PageSize': size.toString(),
      },
    );
    // get model
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            DealerTransactionResponseModel>(
      response,
      dealerTransactionResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<SellerTransactionDetailResponseModel> getSellerTransactionDetail(
      String id, Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.sellerTransactionDetail,
      client: client,
      queries: {
        'collectingRequestId': id,
      },
    );
    // get model
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            SellerTransactionDetailResponseModel>(
      response,
      sellerTransactionDetailResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<DealerTransactionDetailResponseModel> getDealerTransactionDetail(
      String id, Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.dealerTransactionDetail,
      client: client,
      queries: {
        'transId': id,
      },
    );
    // get model
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            DealerTransactionDetailResponseModel>(
      response,
      dealerTransactionDetailResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<BaseResponseModel> feedbackDealerTransaction(
      FeedbackDealerTransactionRequestModel requestModel, Client client) async {
    var response = await NetworkUtils.postBodyWithBearerAuth(
      uri: APIServiceURI.feedbackDealerTransaction,
      headers: {
        HttpHeaders.contentTypeHeader: NetworkConstants.applicationJson,
      },
      body: feedbackDealerTransactionRequestModelToJson(requestModel),
      client: client,
    );

    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<GetStatisticResponseModel> getStatistic(
    DateTime fromDate,
    DateTime toDate,
    Client client,
  ) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.getStatistic,
      client: client,
      queries: {
        'FromDate': fromDate.toOnlyDateString(),
        'ToDate': toDate.toOnlyDateString(),
      },
    );
    // get model
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<GetStatisticResponseModel>(
      response,
      getStatisticResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<BaseResponseModel> createCollectDealComplaint(
      CreateCollectDealTransactionRequestModel requestModel,
      Client client) async {
    var response = await NetworkUtils.postBodyWithBearerAuth(
      uri: APIServiceURI.complainCollectDealTransaction,
      headers: {
        HttpHeaders.contentTypeHeader: NetworkConstants.applicationJson,
      },
      body: createCollectDealTransactionRequestModelToJson(requestModel),
      client: client,
    );

    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<BaseResponseModel> createSellCollectComplaint(
      SellCollectComplaintRequestModel requestModel, Client client) async {
    var response = await NetworkUtils.postBodyWithBearerAuth(
      uri: APIServiceURI.complainSellCollectTransaction,
      headers: {
        HttpHeaders.contentTypeHeader: NetworkConstants.applicationJson,
      },
      body: sellCollectComplaintRequestModelToJson(requestModel),
      client: client,
    );

    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }

  static Future<Map<String, dynamic>> postSellCollectTransaction({
    required String bearerToken,
    required String body,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };

    final uri = Uri.http(EnvBaseAppSettingValue.baseApiUrlWithoutHttp,
        APIServiceURI.apiUrlPostSellCollectTransaction);

    final response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    return json.decode(response.body);
  }
}
