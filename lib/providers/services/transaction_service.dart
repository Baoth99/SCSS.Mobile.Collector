import 'package:collector_app/blocs/dealer_transaction_bloc.dart';
import 'package:collector_app/blocs/dealer_transaction_detail_bloc.dart';
import 'package:collector_app/blocs/payable_amount_bloc.dart';
import 'package:collector_app/blocs/seller_transaction_bloc.dart';
import 'package:collector_app/blocs/seller_transaction_detail_bloc.dart';
import 'package:collector_app/blocs/statistic_bloc.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/constants/text_constants.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/networks/models/request/create_collect_deal_transaction_request_model.dart.dart';
import 'package:collector_app/providers/networks/models/request/feedback_dealer_transaction_request_model.dart';
import 'package:collector_app/providers/networks/models/response/get_sell_collect_transaction_info_review_response_model.dart';
import 'package:collector_app/providers/networks/models/response/sell_collect_complaint_request_model.dart';
import 'package:collector_app/providers/networks/transaction_network.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:http/http.dart';

import 'models/create_sell_collect_transaction_request_model.dart';

abstract class TransactionService {
  Future<List<SellerTransaction>> getSellerTransaction(
    int page,
    int size,
  );
  Future<List<DealerTransaction>> getDealerTransaction(
    int page,
    int size,
  );
  Future<SellerTransactionDetailState?> getSellerTransactionDetail(String id);
  Future<DealerTransactionDetailState?> getDealerTransactionDetail(String id);
  Future<bool> feedbackDealerTransaction(
      String collectDealTransId, double rate, String sellingReview);
  Future<StatisticData> getStatistic(DateTime fromDate, DateTime toDate);
  Future<bool> complainTransaction(String collectDealTransactionId,
      String sellingFeedback, int complaintType);
  Future<bool> createSellCollectTransaction(
      {required CreateSellCollectTransactionRequestModel model});
  Future<GetSellCollectTransactionInfoReviewModel>
      getSellCollectTransactionInfoReview(
          {required String collectingRequestId});

  Future<PayableAmountState> getPayableAmount();
}

class TransactionServiceImpl implements TransactionService {
  TransactionServiceImpl({
    TransactionNetwork? transactionNetwork,
  }) {
    _transactionNetwork = transactionNetwork ?? getIt.get<TransactionNetwork>();
  }

  late final TransactionNetwork _transactionNetwork;
  @override
  Future<List<SellerTransaction>> getSellerTransaction(
      int page, int size) async {
    Client client = Client();

    var responseModel = await _transactionNetwork
        .getSellerTransaction(
          page,
          size,
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var result = <SellerTransaction>[];

    var data = responseModel.resData;
    if (data != null && data.isNotEmpty) {
      for (var m in data) {
        String time = CommonUtils.combineTime(m.dayOfWeek, m.date, m.time);
        result.add(
          SellerTransaction(
            id: m.collectingRequestId,
            name: m.sellerName,
            time: time,
            price: m.total ?? 0,
            status: m.status,
          ),
        );
      }
    }

    return result;
  }

  @override
  Future<List<DealerTransaction>> getDealerTransaction(
      int page, int size) async {
    Client client = Client();

    var responseModel = await _transactionNetwork
        .getDealerTransaction(
          page,
          size,
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var result = <DealerTransaction>[];

    var data = responseModel.resData;
    if (data != null && data.isNotEmpty) {
      for (var m in data) {
        String time = CommonUtils.combineTime(
            m.dayOfWeek, m.transactionDate, m.transactionTime);
        var imageUrl = Symbols.empty;
        if (m.dealerImageUrl != null && m.dealerImageUrl!.isNotEmpty) {
          imageUrl = NetworkUtils.getUrlWithQueryString(
              APIServiceURI.imageGet, {'imageUrl': m.dealerImageUrl!});
        }
        result.add(
          DealerTransaction(
            id: m.transactionId,
            dealerName: m.dealerName,
            time: time,
            price: m.total,
            dealerImage: imageUrl,
          ),
        );
      }
    }

    return result;
  }

  @override
  Future<SellerTransactionDetailState?> getSellerTransactionDetail(
      String id) async {
    Client client = Client();
    var responseModel = await _transactionNetwork
        .getSellerTransactionDetail(
          id,
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var d = responseModel.resData;
    if (d != null) {
      var result = SellerTransactionDetailState(
        collectingRequestCode: d.collectingRequestCode,
        serviceFee: d.transactionFee ?? 0,
        billTotal: (d.total ?? 0) - (d.transactionFee ?? 0),
        itemTotal: d.total ?? 0,
        doneActivityTime: CommonUtils.combineTime(d.dayOfWeek, d.date, d.time),
        sellerName: d.sellerName,
        transaction: d.items
            ?.map(
              (e) => TransactionItem(
                name: e.scrapCategoryName ?? Symbols.empty,
                unitInfo: e.unit ?? Symbols.empty,
                quantity: e.quantity ?? 0,
                total: e.total,
              ),
            )
            .toList(),
        status: d.status,
        complaint: SellerComplaint(
          complaintStatus: d.complaint.complaintStatus,
          adminReply: d.complaint.adminReply ?? Symbols.empty,
          complaintContent: d.complaint.complaintContent ?? Symbols.empty,
        ),
      );
      return result;
    }
    return null;
  }

  @override
  Future<DealerTransactionDetailState?> getDealerTransactionDetail(
      String id) async {
    Client client = Client();
    var responseModel = await _transactionNetwork
        .getDealerTransactionDetail(
          id,
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var d = responseModel.resData;
    if (d != null) {
      String dealerImageUrl = Symbols.empty;
      if (d.dealerInfo.dealerImageUrl != null &&
          d.dealerInfo.dealerImageUrl!.isNotEmpty) {
        dealerImageUrl = NetworkUtils.getUrlWithQueryString(
            APIServiceURI.imageGet, {'imageUrl': d.dealerInfo.dealerImageUrl!});
      }

      var result = DealerTransactionDetailState(
        id: d.transId,
        code: d.transactionCode,
        transactionTime: d.trasactionDateTime,
        dealerName: d.dealerInfo.dealerName,
        dealerPhone: d.dealerInfo.dealerPhone,
        dealerImageUrl: dealerImageUrl,
        feedbackStatus: d.feedback.feedbackStatus,
        ratingFeedback: d.feedback.ratingFeedback ?? 0,
        transaction: d.itemDetails
            .map(
              (e) => Item(
                name: e.scrapCategoryName ?? Symbols.empty,
                unitInfo: e.unit ?? Symbols.empty,
                quantity: e.quantity,
                total: e.total,
                isBonus: e.isBonus,
                bonusAmount: e.bonusAmount,
                promoAppliedBonus: e.promoAppliedBonus ?? 0,
                promotionCode: e.promotionCode ?? Symbols.empty,
              ),
            )
            .toList(),
        itemTotal: d.total,
        awardPoint: d.awardPoint,
        totalBonus: d.totalBonus,
        billTotal: d.total + d.totalBonus,
        complaint: StateComplaint(
          complaintStatus: d.complaint.complaintStatus,
          adminReply: d.complaint.adminReply ?? Symbols.empty,
          complaintContent: d.complaint.complaintContent ?? Symbols.empty,
        ),
      );
      return result;
    }
    return null;
  }

  @override
  Future<bool> feedbackDealerTransaction(
      String collectDealTransId, double rate, String sellingReview) async {
    Client client = Client();
    var responseModel = await _transactionNetwork
        .feedbackDealerTransaction(
          FeedbackDealerTransactionRequestModel(
            collectDealTransId: collectDealTransId,
            rate: rate,
            review: sellingReview,
          ),
          client,
        )
        .whenComplete(() => client.close());

    return responseModel.isSuccess &&
        responseModel.statusCode == NetworkConstants.ok200;
  }

  @override
  Future<StatisticData> getStatistic(DateTime fromDate, DateTime toDate) async {
    StatisticData reuslt = StatisticData();
    Client client = Client();
    var responseModel = await _transactionNetwork
        .getStatistic(
          fromDate,
          toDate,
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var d = responseModel.resData;
    if (d != null) {
      reuslt = StatisticData(
        collectingTotal: d.totalCollecting,
        sellingTotal: d.totalSale,
        completeRequest: d.totalCompletedCr,
        cancelRequest: d.totalCancelCr,
      );
    }
    return reuslt;
  }

  @override
  Future<bool> complainTransaction(String collectDealTransactionId,
      String complaint, int complaintType) async {
    Client client = Client();
    var result;
    if (complaintType == ComplaintType.dealer) {
      result = await _transactionNetwork
          .createCollectDealComplaint(
              CreateCollectDealTransactionRequestModel(
                collectDealTransactionId: collectDealTransactionId,
                complaintContent: complaint,
              ),
              client)
          .whenComplete(() => client.close());
    } else if (complaintType == ComplaintType.seller) {
      result = await _transactionNetwork
          .createSellCollectComplaint(
              SellCollectComplaintRequestModel(
                collectingRequestId: collectDealTransactionId,
                complaintContent: complaint,
              ),
              client)
          .whenComplete(() => client.close());
    }
    return result.isSuccess && result.statusCode == NetworkConstants.ok200;
  }

  Future<bool> createSellCollectTransaction(
      {required CreateSellCollectTransactionRequestModel model}) async {
    try {
      //get access token
      var accessToken = await NetworkUtils.getBearerTokenPure();
      if (accessToken.isNotEmpty) {
        var result = await TransactionNetworkImpl.postSellCollectTransaction(
          bearerToken: accessToken,
          body: createSellCollectTransactionRequestModelToJson(model),
        );
        //get info review
        return result['isSuccess'] ?? false;
      } else
        throw Exception(TextConstants.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<GetSellCollectTransactionInfoReviewModel>
      getSellCollectTransactionInfoReview(
          {required String collectingRequestId}) async {
    try {
      //get access token
      var accessToken = await NetworkUtils.getBearerTokenPure();
      if (accessToken.isNotEmpty) {
        var result =
            await TransactionNetworkImpl.getSellCollectTransactionInfoReview(
          bearerToken: accessToken,
          collectingRequestId: collectingRequestId,
        );
        //get info review
        return result.resData;
      } else
        throw Exception(TextConstants.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  @override
  Future<PayableAmountState> getPayableAmount() async {
    PayableAmountState result = PayableAmountState();
    Client client = Client();
    var responseModel = await _transactionNetwork
        .getServiceFee(
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var d = responseModel.resData;

    List<PayableAmount> data = d
        .map((e) => PayableAmount(
            id: e.id,
            timePeriod: e.timePeriod,
            dateTimeFrom: e.dateTimeFrom,
            dateTimeTo: e.dateTimeTo,
            isFinished: e.isFinished,
            amount: e.amount))
        .toList();
    result = PayableAmountState(listPayableAmount: data);
    return result;
  }
}
