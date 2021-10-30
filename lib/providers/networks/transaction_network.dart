import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/providers/networks/models/response/seller_transaction_response_model.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:http/http.dart';

abstract class TransactionNetwork {
  Future<SellerTransactionResponseModel> getSellerTransaction(
    int page,
    int size,
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
}
