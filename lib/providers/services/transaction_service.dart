import 'package:collector_app/blocs/dealer_transaction_bloc.dart';
import 'package:collector_app/blocs/seller_transaction_bloc.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/networks/transaction_network.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:http/http.dart';

abstract class TransactionService {
  Future<List<SellerTransaction>> getSellerTransaction(
    int page,
    int size,
  );
  Future<List<DealerTransaction>> getDealerTransaction(
    int page,
    int size,
  );
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
}
