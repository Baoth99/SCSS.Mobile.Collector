import 'package:collector_app/blocs/collecting_request_detail_bloc.dart';
import 'package:collector_app/blocs/models/gender_model.dart';
import 'package:collector_app/blocs/models/request_model.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/exceptions/custom_exceptions.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/networks/models/response/base_response_model.dart';
import 'package:collector_app/providers/networks/request_network.dart';
import 'package:collector_app/utils/common_utils.dart';
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

  Future<CollectingRequestDetailState> getCollectingRequest(String id);
  Future<CollectingRequestDetailState> getApprovedRequest(String id);
  Future<bool> approveRequest(String id);
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

  @override
  Future<CollectingRequestDetailState> getCollectingRequest(String id) async {
    http.Client client = http.Client();
    var responseModel = await _collectingRequestNetwork
        .getCollectingRequestDetail(
          id,
          client,
        )
        .whenComplete(() => client.close());
    var data = responseModel.resData;
    if (data != null) {
      String dayOfWeek = VietnameseDate.weekdayServer[data.dayOfWeek] ??
          (throw Exception('Day of week is not proper'));
      String scrapImageUrl = Symbols.empty;
      if (data.scrapImageUrl != null && data.scrapImageUrl!.isNotEmpty) {
        scrapImageUrl = NetworkUtils.getUrlWithQueryString(
            APIServiceURI.imageGet, {'imageUrl': data.scrapImageUrl!});
      }
      String sellerImageUrl = Symbols.empty;
      if (data.sellerProfileUrl != null && data.sellerProfileUrl!.isNotEmpty) {
        sellerImageUrl = NetworkUtils.getUrlWithQueryString(
            APIServiceURI.imageGet, {'imageUrl': data.sellerProfileUrl!});
      }
      CollectingRequestDetailState result = CollectingRequestDetailState(
        id: data.id,
        area: data.area,
        collectingRequestCode: data.collectingRequestCode,
        isBulky: data.isBulky,
        latitude: data.latitude,
        longtitude: data.longtitude,
        sellerName: data.sellerName,
        requestType: data.requestType,
        note: data.note,
        scrapImageUrl: scrapImageUrl,
        isAllowedToApprove: data.isAllowedToApprove,
        time:
            '$dayOfWeek, ${data.collectingRequestDate}, ${data.fromTime} - ${data.toTime}',
        collectingRequestDetailStatus: CollectingRequestDetailStatus.pending,
        gender: data.sellerGender == 1 ? Gender.male : Gender.female,
        sellerAvatarUrl: sellerImageUrl,
      );
      return result;
    }
    throw Exception(CommonApiConstants.errorSystem);
  }

  @override
  Future<bool> approveRequest(String id) async {
    http.Client client = http.Client();
    var responseModel = await _collectingRequestNetwork
        .approveRequest(
          id,
          client,
        )
        .whenComplete(
          () => client.close(),
        );

    if (responseModel.isSuccess &&
        responseModel.statusCode == NetworkConstants.ok200) {
      return true;
    } else if (!responseModel.isSuccess &&
        responseModel.statusCode == NetworkConstants.badRequest400 &&
        responseModel.msgCode ==
            IdentityAPIConstants.isApprovedBuOtherCollector) {
      throw ApprovedByOtherCollectorException();
    } else {
      throw Exception('Exception: approveRequest');
    }
  }

  @override
  Future<CollectingRequestDetailState> getApprovedRequest(String id) async {
    http.Client client = http.Client();
    var responseModel = await _collectingRequestNetwork
        .getApprovedRequestDetail(
          id,
          client,
        )
        .whenComplete(() => client.close());
    var data = responseModel.resData;
    if (data != null) {
      String dayOfWeek = VietnameseDate.weekdayServer[data.dayOfWeek] ??
          (throw Exception('Day of week is not proper'));
      String scrapImageUrl = Symbols.empty;
      if (data.scrapImgUrl != null && data.scrapImgUrl!.isNotEmpty) {
        scrapImageUrl = NetworkUtils.getUrlWithQueryString(
            APIServiceURI.imageGet, {'imageUrl': data.scrapImgUrl!});
      }
      String sellerImageUrl = Symbols.empty;
      if (data.sellerImgUrl != null && data.sellerImgUrl!.isNotEmpty) {
        sellerImageUrl = NetworkUtils.getUrlWithQueryString(
            APIServiceURI.imageGet, {'imageUrl': data.sellerImgUrl!});
      }
      CollectingRequestDetailState result = CollectingRequestDetailState(
        id: data.id,
        collectingAddress: data.collectingAddress,
        collectingAddressName: data.collectingAddressName,
        collectingRequestCode: data.collectingRequestCode,
        isBulky: data.isBulky,
        latitude: data.latitude,
        longtitude: data.longtitude,
        sellerName: data.sellerName,
        note: data.note,
        scrapImageUrl: scrapImageUrl,
        time:
            '$dayOfWeek, ${data.collectingRequestDate}, ${data.fromTime} - ${data.toTime}',
        collectingRequestDetailStatus: CollectingRequestDetailStatus.pending,
        gender: data.sellerGender == 1 ? Gender.male : Gender.female,
        sellerAvatarUrl: sellerImageUrl,
        sellerPhone: data.sellerPhone,
      );
      return result;
    }
    throw Exception(CommonApiConstants.errorSystem);
  }
}
