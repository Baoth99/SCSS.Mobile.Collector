import 'package:collector_app/blocs/dealer_detail_bloc.dart';
import 'package:collector_app/blocs/dealer_search_bloc.dart';
import 'package:collector_app/blocs/promotion_bloc.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/networks/dealer_network.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:http/http.dart';

abstract class DealerService {
  Future<List<DealerInfo>> getDealers(
    String searchWord,
    double radius,
    double latitude,
    double logitude,
    int page,
    int size,
  );

  Future<DealerDetailState> getDealerDetail(
    String id,
  );

  Future<List<PromotionModel>> getPromotions(String id);
}

class DealerServiceImpl extends DealerService {
  DealerServiceImpl({
    DealerNetwork? dealerNetwork,
  }) {
    _dealerNetwork = dealerNetwork ?? getIt.get<DealerNetwork>();
  }

  late final DealerNetwork _dealerNetwork;

  @override
  Future<List<DealerInfo>> getDealers(
    String searchWord,
    double radius,
    double latitude,
    double logitude,
    int page,
    int size,
  ) async {
    Client client = Client();
    List<DealerInfo> result = await _dealerNetwork
        .searchDealers(
      searchWord,
      radius,
      latitude,
      logitude,
      page,
      size,
      client,
    )
        .then((value) {
      var data = value.resData;
      if (data != null) {
        var r = data.map(
          (e) {
            String imageUrl = Symbols.empty;
            if (e.dealerImageUrl != null && e.dealerImageUrl!.isNotEmpty) {
              imageUrl = NetworkUtils.getUrlWithQueryString(
                  APIServiceURI.imageGet, {'imageUrl': e.dealerImageUrl!});
            }
            return DealerInfo(
              dealerId: e.dealerId ?? Symbols.empty,
              dealerName: e.dealerName ?? Symbols.empty,
              isActive: e.isActive ?? false,
              dealerAddress: e.dealerAddress ?? Symbols.empty,
              latitude: e.latitude ?? 0,
              longtitude: e.longtitude ?? 0,
              dealerImageUrl: imageUrl,
              openTime: e.openTime ?? Symbols.empty,
              closeTime: e.closeTime ?? Symbols.empty,
              distance: e.distance ?? 0,
              distanceText: e.distanceText ?? Symbols.empty,
            );
          },
        ).toList();
        return r;
      }
      AppLog.error('ResData is null');
      return [];
    });
    return result;
  }

  @override
  Future<DealerDetailState> getDealerDetail(String id) async {
    Client client = Client();
    var responseModel = await _dealerNetwork
        .getDealerDetail(
          id,
          client,
        )
        .whenComplete(() => client.close());
    var data = responseModel.resData;
    if (data != null) {
      String dealerImageUrl = Symbols.empty;
      if (data.dealerImageUrl != null && data.dealerImageUrl!.isNotEmpty) {
        dealerImageUrl = NetworkUtils.getUrlWithQueryString(
            APIServiceURI.imageGet, {'imageUrl': data.dealerImageUrl!});
      }
      DealerDetailState result = DealerDetailState(
          id: data.dealerId,
          dealerName: data.dealerName,
          dealerImageUrl: dealerImageUrl,
          dealerPhone: data.dealerPhone,
          rate: data.rating,
          openTime: data.openTime,
          closeTime: data.closeTime,
          dealerAddress: data.dealerAddress,
          latitude: data.latitude,
          longtitude: data.longtitude);
      return result;
    }
    throw Exception(CommonApiConstants.errorSystem);
  }

  @override
  Future<List<PromotionModel>> getPromotions(String id) async {
    Client client = Client();
    List<PromotionModel> result = await _dealerNetwork
        .getPromotions(
      id,
      client,
    )
        .then((value) {
      var data = value.resData;
      if (data != null) {
        var r = data.map(
          (e) {
            return PromotionModel(
                id: e.id,
                code: e.code,
                promotionName: e.promotionName,
                bonusAmount: e.bonusAmount,
                appliedAmount: e.appliedAmount,
                appliedScrapCategory: e.appliedScrapCategory,
                appliedFromTime: e.appliedFromTime,
                appliedToTime: e.appliedToTime);
          },
        ).toList();
        return r;
      }
      AppLog.error('ResData is null');
      return [];
    });
    return result;
  }
}
