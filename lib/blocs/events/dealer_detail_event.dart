part of '../dealer_detail_bloc.dart';

class DealerDetailEvent extends AbstractEvent {
  const DealerDetailEvent();
}

class DealerDetailInitial extends DealerDetailEvent {
  DealerDetailInitial(
    this.id
  );
  final String id;
}
