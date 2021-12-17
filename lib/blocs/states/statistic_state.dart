part of '../statistic_bloc.dart';

class StatisticState extends Equatable {
  StatisticState({
    DateTime? fromDate,
    DateTime? toDate,
    this.statisticData = const StatisticData(),
    this.status = FormzStatus.pure,
  }) {
    this.fromDate = fromDate ?? DateTime.now().onlyDate();
    this.toDate = toDate ?? DateTime.now().onlyDate();
  }

  late final DateTime fromDate;
  late final DateTime toDate;
  final StatisticData statisticData;
  final FormzStatus status;

  StatisticState copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    StatisticData? statisticData,
    FormzStatus? status,
  }) {
    return StatisticState(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      statisticData: statisticData ?? this.statisticData,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        fromDate,
        toDate,
        statisticData,
        status,
      ];
}

class StatisticData extends Equatable {
  final int collectingTotal;
  final int sellingTotal;
  final int completeRequest;
  final int cancelRequest;

  const StatisticData({
    this.collectingTotal = 0,
    this.sellingTotal = 0,
    this.completeRequest = 0,
    this.cancelRequest = 0,
  });

  StatisticData copyWith({
    int? collectingTotal,
    int? sellingTotal,
    int? completeRequest,
    int? cancelRequest,
  }) {
    return StatisticData(
      collectingTotal: collectingTotal ?? this.collectingTotal,
      sellingTotal: sellingTotal ?? this.sellingTotal,
      completeRequest: completeRequest ?? this.completeRequest,
      cancelRequest: cancelRequest ?? this.cancelRequest,
    );
  }

  @override
  List<int> get props => [
        collectingTotal,
        sellingTotal,
        completeRequest,
        cancelRequest,
      ];
}
