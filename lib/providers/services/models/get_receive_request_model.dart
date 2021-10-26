import 'package:collector_app/blocs/models/collecting_request_model.dart';

class GetReceiveRequestModel {
  final CollectingRequestModel? collectingRequestModel;
  final int total;

  GetReceiveRequestModel({
    required this.collectingRequestModel,
    required this.total,
  });
}
