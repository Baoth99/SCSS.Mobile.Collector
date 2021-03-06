import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/providers/networks/models/response/dealer_detail_response.dart';
import 'package:collector_app/providers/networks/models/response/dealer_promotion_response_model.dart';
import 'package:collector_app/providers/networks/models/response/dealer_search_response_model.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:http/http.dart';

abstract class DealerNetwork {
  Future<DelaerSearchResponseModel> searchDealers(
    String searchWord,
    double radius,
    double latitude,
    double logitude,
    int page,
    int size,
    Client client,
  );

  Future<DealerDetailResponseModel> getDealerDetail(
    String id,
    Client client,
  );

  Future<DealerPromotionResposeModel> getPromotions(
    String id,
    Client client,
  );
}

class DealerNetworkImpl implements DealerNetwork {
  @override
  Future<DelaerSearchResponseModel> searchDealers(
    String searchWord,
    double radius,
    double latitude,
    double logitude,
    int page,
    int size,
    Client client,
  ) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.dealerSearch,
      client: client,
      queries: {
        'SearchWord': searchWord,
        'Radius': radius.toString(),
        'OriginLatitude': latitude.toString(),
        'OriginLongtitude': logitude.toString(),
        'Page': page.toString(),
        'PageSize': size.toString(),
      },
    );
    // get model
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<DelaerSearchResponseModel>(
      response,
      delaerSearchResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<DealerDetailResponseModel> getDealerDetail(
      String id, Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
        uri: APIServiceURI.dealerDetail,
        client: client,
        queries: {
          "id": id,
        });
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel(
            response, dealerDetailResponseModelFromJson);
    return responseModel;
  }

  @override
  Future<DealerPromotionResposeModel> getPromotions(
      String id, Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
        uri: APIServiceURI.dealerInfoPromotion,
        client: client,
        queries: {
          "dealerId": id,
        });
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel(
            response, dealerPromotionResposeModelFromJson);
    return responseModel;
  }
}
