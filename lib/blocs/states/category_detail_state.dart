import 'package:collector_app/blocs/models/scrap_category_detail_item_model.dart';
import 'package:collector_app/constants/text_constants.dart';
import 'package:flutter/cupertino.dart';

class CategoryDetailState {
  String initScrapName;
  ImageProvider? initScrapImage;
  String initScrapImageUrl;
  String scrapName;
  String pickedImageUrl;
  List<CategoryDetailItemModel> units;

  bool isImageSourceActionSheetVisible;
  bool isNameExisted;

  bool get isOneUnitExist {
    var result = false;
    units.forEach((value) {
      if (value.unit.isNotEmpty) result = true;
    });
    return result;
  }

  CategoryDetailState({
    isImageSourceActionSheetVisible = false,
    String? pickedImageUrl,
    String? initScrapName,
    ImageProvider? initScrapImage,
    String? initScrapImageUrl,
    String? scrapName,
    List<CategoryDetailItemModel>? units,
    this.isNameExisted = false,
  })  : this.isImageSourceActionSheetVisible = isImageSourceActionSheetVisible,
        this.pickedImageUrl = pickedImageUrl ?? TextConstants.emptyString,
        this.initScrapName = initScrapName ?? TextConstants.emptyString,
        this.initScrapImage = initScrapImage,
        this.initScrapImageUrl = initScrapImageUrl ?? TextConstants.emptyString,
        this.scrapName = scrapName ?? TextConstants.emptyString,
        this.units = units ?? [];

  CategoryDetailState copyWith({
    bool? isImageSourceActionSheetVisible,
    String? pickedImageUrl,
    String? initScrapName,
    ImageProvider? initScrapImage,
    String? initScrapImageUrl,
    String? scrapName,
    List<CategoryDetailItemModel>? units,
    bool? isNameExisted,
  }) {
    //return state
    return CategoryDetailState(
      isImageSourceActionSheetVisible: isImageSourceActionSheetVisible ??
          this.isImageSourceActionSheetVisible,
      pickedImageUrl: pickedImageUrl ?? this.pickedImageUrl,
      initScrapName: initScrapName ?? this.initScrapName,
      initScrapImage: initScrapImage ?? this.initScrapImage,
      initScrapImageUrl: initScrapImageUrl ?? this.initScrapImageUrl,
      scrapName: scrapName ?? this.scrapName,
      units: units ?? this.units,
      isNameExisted: isNameExisted ?? this.isNameExisted,
    );
  }
}

class ScrapCategorySubmittedState extends CategoryDetailState {}

class LoadingState extends CategoryDetailState {
  LoadingState({
    required isImageSourceActionSheetVisible,
    required units,
    required pickedImageUrl,
    required initScrapName,
    required initScrapImage,
    required initScrapImageUrl,
    required scrapName,
    required isNameExisted,
  }) : super(
          isImageSourceActionSheetVisible: isImageSourceActionSheetVisible,
          units: units,
          initScrapName: initScrapName,
          initScrapImage: initScrapImage,
          initScrapImageUrl: initScrapImageUrl,
          pickedImageUrl: pickedImageUrl,
          scrapName: scrapName,
          isNameExisted: isNameExisted,
        );
}

class SubmittedState extends CategoryDetailState {
  final String message;

  SubmittedState({required this.message});
}

class ErrorState extends CategoryDetailState {
  final String message;

  ErrorState({
    required this.message,
    required isImageSourceActionSheetVisible,
    required units,
    required pickedImageUrl,
    required initScrapName,
    required initScrapImage,
    required initScrapImageUrl,
    required scrapName,
    required isNameExisted,
  }) : super(
          isImageSourceActionSheetVisible: isImageSourceActionSheetVisible,
          units: units,
          pickedImageUrl: pickedImageUrl,
          initScrapName: initScrapName,
          initScrapImage: initScrapImage,
          initScrapImageUrl: initScrapImageUrl,
          scrapName: scrapName,
          isNameExisted: isNameExisted,
        );
}

class DeleteState extends CategoryDetailState {
  final String message;

  DeleteState({
    required this.message,
    required isImageSourceActionSheetVisible,
    required units,
    required pickedImageUrl,
    required initScrapName,
    required initScrapImage,
    required initScrapImageUrl,
    required scrapName,
    required isNameExisted,
  }) : super(
          isImageSourceActionSheetVisible: isImageSourceActionSheetVisible,
          units: units,
          pickedImageUrl: pickedImageUrl,
          initScrapName: initScrapName,
          initScrapImage: initScrapImage,
          initScrapImageUrl: initScrapImageUrl,
          scrapName: scrapName,
          isNameExisted: isNameExisted,
        );
}
