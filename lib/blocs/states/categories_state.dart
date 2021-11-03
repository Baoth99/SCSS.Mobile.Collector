import 'package:collector_app/blocs/models/scrap_category_model.dart';
import 'package:collector_app/constants/text_constants.dart';
import 'package:equatable/equatable.dart';

abstract class CategoriesState extends Equatable {}

class NotLoadedState extends CategoriesState {
  @override
  List<Object?> get props => [];
}

class LoadedState extends CategoriesState {
  final List<ScrapCategoryModel> categoryList;
  final List<ScrapCategoryModel> filteredCategories;
  final String searchName;

  LoadedState({
    required this.categoryList,
    required this.filteredCategories,
    this.searchName = TextConstants.emptyString,
  });

  LoadedState copyWith({
    List<ScrapCategoryModel>? categoryList,
    List<ScrapCategoryModel>? filteredCategories,
    String? searchName,
  }) {
    return LoadedState(
      categoryList: categoryList ?? this.categoryList,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      searchName: searchName ?? this.searchName,
    );
  }

  @override
  List<Object> get props => [categoryList, filteredCategories, searchName];
}

class ErrorState extends CategoriesState {
  final String errorMessage;

  ErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
