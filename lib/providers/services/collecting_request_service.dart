import 'package:collector_app/blocs/models/request_model.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/networks/request_network.dart';
import 'package:http/http.dart' as http;

abstract class CollectingRequestService {
  Future<List<Request>> getNowRequest(
    double lat,
    double lag,
    int page,
    int size,
  );
  Future<List<Request>> getBookRequest(
    double lat,
    double lag,
    int page,
    int size,
  );
}

class CollectingRequestServiceImpl implements CollectingRequestService {
  CollectingRequestServiceImpl({
    CollectingRequestNetwork? collectingRequestNetwork,
  }) {
    _collectingRequestNetwork =
        collectingRequestNetwork ?? getIt.get<CollectingRequestNetwork>();
  }

  late final CollectingRequestNetwork _collectingRequestNetwork;
  @override
  Future<List<Request>> getNowRequest(
    double lat,
    double lag,
    int page,
    int size,
  ) async {
    http.Client client = http.Client();
    var responseModel = await _collectingRequestNetwork
        .getCollectingRequests(
          lat,
          lag,
          page,
          size,
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var result = <Request>[];
    if (responseModel.resData.isNotEmpty) {
      for (var m in responseModel.resData) {
        result.add(
          Request(
            id: m.id,
            collectingRequestCode: m.collectingRequestCode,
            area: m.area,
            collectingRequestDate: m.collectingRequestDate,
            distance: m.distance,
            distanceText: m.distanceText,
            durationTimeText: m.durationTimeText,
            durationTimeVal: m.durationTimeVal,
            fromTime: m.fromTime,
            isBulky: m.isBulky,
            latitude: m.latitude,
            longtitude: m.longtitude,
            requestType: m.requestType,
            dayOfWeek: m.dayOfWeek,
            sellerName: m.sellerName,
            toTime: m.toTime,
          ),
        );
      }
    }

    return result;
  }

  @override
  Future<List<Request>> getBookRequest(
      double lat, double lag, int page, int size) async {
    http.Client client = http.Client();
    var responseModel = await _collectingRequestNetwork
        .getBookingRequests(
          lat,
          lag,
          page,
          size,
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var result = <Request>[];
    if (responseModel.resData.isNotEmpty) {
      for (var m in responseModel.resData) {
        result.add(
          Request(
            id: m.id,
            collectingRequestCode: m.collectingRequestCode,
            area: m.area,
            collectingRequestDate: m.collectingRequestDate,
            distance: m.distance,
            distanceText: m.distanceText,
            durationTimeText: m.durationTimeText,
            durationTimeVal: m.durationTimeVal,
            fromTime: m.fromTime,
            isBulky: m.isBulky,
            latitude: m.latitude,
            longtitude: m.longtitude,
            requestType: m.requestType,
            dayOfWeek: m.dayOfWeek,
            sellerName: m.sellerName,
            toTime: m.toTime,
          ),
        );
      }
    }

    return result;
  }
}
