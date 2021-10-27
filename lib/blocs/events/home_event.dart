part of '../home_bloc.dart';

class HomeEvent extends AbstractEvent {
  const HomeEvent();
}

class HomeInitial extends HomeEvent {}

class HomeFetch extends HomeEvent {}

class HomeSearch extends HomeEvent {
  final String searchValue;
  HomeSearch(this.searchValue);
}
