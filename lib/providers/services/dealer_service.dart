import 'package:collector_app/blocs/dealer_search_bloc.dart';
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
}
