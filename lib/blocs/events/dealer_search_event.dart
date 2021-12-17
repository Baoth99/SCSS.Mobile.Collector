part of '../dealer_search_bloc.dart';

class DealerSearchEvent extends AbstractEvent {
  const DealerSearchEvent();
}

class DealerSearchInitialEvent extends DealerSearchEvent {
  const DealerSearchInitialEvent();
}

class DealerSearch extends DealerSearchEvent {
  const DealerSearch(this.search);

  final String search;
}
