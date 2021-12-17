import 'package:collector_app/blocs/states/category_detail_state.dart';
import 'package:collector_app/constants/text_constants.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/networks/models/request/update_category_request_model.dart';
import 'package:collector_app/providers/services/data_service.dart';
import 'package:collector_app/providers/services/scrap_category_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'events/category_detail_event.dart';
import 'models/scrap_category_detail_item_model.dart';
import 'models/scrap_category_detail_model.dart';

class CategoryDetailBloc
    extends Bloc<CategoryDetailEvent, CategoryDetailState> {
  final _picker = ImagePicker();
  final String id;
  final _scrapCategoryHandler = getIt.get<IScrapCategoryService>();
  final _dataHandler = getIt.get<IDataService>();

  CategoryDetailBloc({required this.id}) : super(CategoryDetailState()) {
    add(EventInitData());
  }

  @override
  Stream<CategoryDetailState> mapEventToState(
      CategoryDetailEvent event) async* {
    if (event is EventInitData) {
      yield LoadingState(
        isImageSourceActionSheetVisible: false,
        units: null,
        pickedImageUrl: null,
        initScrapName: null,
        initScrapImage: null,
        initScrapImageUrl: null,
        scrapName: null,
        isNameExisted: false,
      );
      try {
        ScrapCategoryDetailModel model =
            await _scrapCategoryHandler.getScrapCategoryDetail(id: id);
        // Get Image
        ImageProvider? initImage;
        if (model.imageUrl != TextConstants.emptyString)
          initImage =
              await _dataHandler.getImageBytes(imageUrl: model.imageUrl);

        yield CategoryDetailState(
          isImageSourceActionSheetVisible: false,
          isNameExisted: false,
          initScrapName: model.name,
          initScrapImage: initImage,
          initScrapImageUrl: model.imageUrl,
          scrapName: model.name,
          pickedImageUrl: null,
          units: model.details,
        );
      } catch (e) {
        yield ErrorState(
          message: TextConstants.errorHappenedTryAgain,
          units: state.units,
          isImageSourceActionSheetVisible:
              state.isImageSourceActionSheetVisible,
          pickedImageUrl: state.pickedImageUrl,
          initScrapName: state.initScrapName,
          initScrapImage: state.initScrapImage,
          initScrapImageUrl: state.initScrapImageUrl,
          scrapName: state.scrapName,
          isNameExisted: state.isNameExisted,
        );
      }
    }
    if (event is EventChangeScrapImageRequest) {
      yield state.copyWith(isImageSourceActionSheetVisible: true);
      yield state.copyWith(isImageSourceActionSheetVisible: false);
    }
    if (event is EventOpenImagePicker) {
      final pickedImage = await _picker.pickImage(source: event.imageSource);
      if (pickedImage != null) {
        yield state.copyWith(pickedImageUrl: pickedImage.path);
      } else
        return;
    }
    if (event is EventChangeScrapName) {
      yield state.copyWith(
        scrapName: event.scrapName,
        isNameExisted: false,
      );
    }
    if (event is EventAddScrapCategoryUnit) {
      List<CategoryDetailItemModel> units = List.from(state.units);
      units.add(CategoryDetailItemModel.updateCategoryModel(
          unit: TextConstants.emptyString));

      yield state.copyWith(units: units);
    }
    if (event is EventChangeUnitAndPrice) {
      List<CategoryDetailItemModel> units = List.from(state.units);
      units[event.index].unit = event.unit;
      units[event.index].price = int.parse(event.price);

      yield state.copyWith(units: units);
    }
    if (event is EventSubmitScrapCategory) {
      yield LoadingState(
        units: state.units,
        isImageSourceActionSheetVisible: state.isImageSourceActionSheetVisible,
        pickedImageUrl: state.pickedImageUrl,
        initScrapName: state.initScrapName,
        initScrapImage: state.initScrapImage,
        initScrapImageUrl: state.initScrapImageUrl,
        scrapName: state.scrapName,
        isNameExisted: state.isNameExisted,
      );
      try {
        // Check if name hasn't changed
        bool checkNameResult = state.scrapName == state.initScrapName;
        if (!checkNameResult)
          checkNameResult =
              await _scrapCategoryHandler.checkScrapName(name: state.scrapName);
        print(checkNameResult);
        if (checkNameResult) {
          String imagePath = state.initScrapImageUrl;
          if (state.pickedImageUrl.isNotEmpty) {
            // Upload image
            imagePath = await _scrapCategoryHandler.uploadImage(
                imagePath: state.pickedImageUrl);
          }

          // Submit category
          var result = await _scrapCategoryHandler.updateScrapCategory(
            model: UpdateScrapCategoryRequestModel(
              id: id,
              name: state.scrapName,
              imageUrl: imagePath,
              details: await _getListFiltered(units: state.units),
            ),
          );

          if (result) {
            yield SubmittedState(
                message: TextConstants.updateScrapCategorySucessfull);
          } else {
            yield ErrorState(
              message: TextConstants.errorHappenedTryAgain,
              units: state.units,
              isImageSourceActionSheetVisible:
                  state.isImageSourceActionSheetVisible,
              pickedImageUrl: state.pickedImageUrl,
              initScrapName: state.initScrapName,
              initScrapImage: state.initScrapImage,
              initScrapImageUrl: state.initScrapImageUrl,
              scrapName: state.scrapName,
              isNameExisted: state.isNameExisted,
            );
          }
        } else {
          yield CategoryDetailState(
            units: state.units,
            isImageSourceActionSheetVisible:
                state.isImageSourceActionSheetVisible,
            pickedImageUrl: state.pickedImageUrl,
            initScrapName: state.initScrapName,
            initScrapImageUrl: state.initScrapImageUrl,
            scrapName: state.scrapName,
            isNameExisted: true,
          );
        }
      } catch (e) {
        print(e);
        yield ErrorState(
          message: TextConstants.errorHappenedTryAgain,
          units: state.units,
          isImageSourceActionSheetVisible:
              state.isImageSourceActionSheetVisible,
          pickedImageUrl: state.pickedImageUrl,
          initScrapName: state.initScrapName,
          initScrapImage: state.initScrapImage,
          initScrapImageUrl: state.initScrapImageUrl,
          scrapName: state.scrapName,
          isNameExisted: state.isNameExisted,
        );
      }
    }
    if (event is EventDeleteScrapCategory) {
      yield LoadingState(
        units: state.units,
        isImageSourceActionSheetVisible: state.isImageSourceActionSheetVisible,
        pickedImageUrl: state.pickedImageUrl,
        initScrapName: state.initScrapName,
        initScrapImage: state.initScrapImage,
        initScrapImageUrl: state.initScrapImageUrl,
        scrapName: state.scrapName,
        isNameExisted: state.isNameExisted,
      );
      try {
        // Submit category
        var result = await _scrapCategoryHandler.deleteScrapCategory(id: id);

        if (result) {
          yield SubmittedState(
              message: TextConstants.deleteScrapCategorySucessfull);
        } else {
          yield ErrorState(
            message: TextConstants.errorHappenedTryAgain,
            units: state.units,
            isImageSourceActionSheetVisible:
                state.isImageSourceActionSheetVisible,
            pickedImageUrl: state.pickedImageUrl,
            initScrapName: state.initScrapName,
            initScrapImage: state.initScrapImage,
            initScrapImageUrl: state.initScrapImageUrl,
            scrapName: state.scrapName,
            isNameExisted: state.isNameExisted,
          );
        }
      } catch (e) {
        print(e);
        yield ErrorState(
          message: TextConstants.errorHappenedTryAgain,
          units: state.units,
          isImageSourceActionSheetVisible:
              state.isImageSourceActionSheetVisible,
          pickedImageUrl: state.pickedImageUrl,
          initScrapName: state.initScrapName,
          initScrapImage: state.initScrapImage,
          initScrapImageUrl: state.initScrapImageUrl,
          scrapName: state.scrapName,
          isNameExisted: state.isNameExisted,
        );
      }
    }
    if (event is EventTapDeleteButton) {
      yield DeleteState(
        message: TextConstants.deleteScrapCategory(name: state.scrapName),
        units: state.units,
        isImageSourceActionSheetVisible: state.isImageSourceActionSheetVisible,
        pickedImageUrl: state.pickedImageUrl,
        initScrapName: state.initScrapName,
        initScrapImage: state.initScrapImage,
        initScrapImageUrl: state.initScrapImageUrl,
        scrapName: state.scrapName,
        isNameExisted: state.isNameExisted,
      );
    }
  }

  Future<List<CategoryDetailItemModel>> _getListFiltered({
    required List<CategoryDetailItemModel> units,
  }) async {
    List<CategoryDetailItemModel> list = List.from(units);
    // Remove empty new unit
    list.removeWhere((element) =>
        element.unit.isEmpty && element.id == TextConstants.zeroId);
    // Change status of empty old unit
    for (var item in list) {
      if (item.id != TextConstants.zeroId && item.unit.isEmpty)
        item.status = Status.DEACTIVE.number;
    }
    return list;
  }
}
