part of '../statistic_bloc.dart';

abstract class StatisticEvent extends AbstractEvent {
  const StatisticEvent();
}

class StatisticGet extends StatisticEvent {}

class StatisticChanged extends StatisticEvent {
  StatisticChanged(this.fromDate, this.toDate);
  final DateTime fromDate;
  final DateTime toDate;
}
