import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {}

class EventInitData extends CategoriesEvent {
  @override
  List<Object?> get props => [];
}

class EventLoadMoreCategories extends CategoriesEvent {
  @override
  List<Object?> get props => [];
}

class EventChangeSearchName extends CategoriesEvent {
  final String searchName;

  EventChangeSearchName({required this.searchName});

  @override
  List<Object> get props => [searchName];
}
