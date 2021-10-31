import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/providers/networks/models/response/dealer_transaction_response_model.dart';
import 'package:collector_app/providers/networks/models/response/seller_transaction_detail_response_model.dart';
import 'package:collector_app/providers/networks/models/response/seller_transaction_response_model.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:http/http.dart';

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
}
