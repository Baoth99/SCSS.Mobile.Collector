import 'package:collector_app/constants/text_constants.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/networks/models/request/create_category_request_model.dart';
import 'package:collector_app/providers/services/scrap_category_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'events/add_category_event.dart';
import 'models/scrap_category_model.dart';
import 'states/add_category_state.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final _picker = ImagePicker();
  final _scrapCategoryHandler = getIt.get<IScrapCategoryService>();

  AddCategoryBloc()
      : super(
          AddCategoryState(
            controllers: {
              new TextEditingController(): new TextEditingController(),
            },
          ),
        );

  @override
  Stream<AddCategoryState> mapEventToState(AddCategoryEvent event) async* {
    if (event is EventChangeScrapImageRequest) {
      yield state.copyWith(isImageSourceActionSheetVisible: true);
    }
    if (event is EventOpenImagePicker) {
      yield state.copyWith(isImageSourceActionSheetVisible: false);
      final pickedImage = await _picker.pickImage(source: event.imageSource);
      if (pickedImage != null) {
        yield state.copyWith(
          pickedImageUrl: pickedImage.path,
          isImageSourceActionSheetVisible: false,
        );
      } else
        return;
    }
    if (event is EventChangeScrapName) {
      yield state.copyWith(
        isImageSourceActionSheetVisible: false,
        scrapName: event.scrapName,
        isNameExisted: false,
      );
    }
    if (event is EventAddScrapCategoryUnit) {
      yield state.copyWith(
          isImageSourceActionSheetVisible: false,
          controllers: event.controllers);
    }
    if (event is EventSubmitScrapCategory) {
      yield LoadingState(
        controllers: state.controllers,
        isImageSourceActionSheetVisible: state.isImageSourceActionSheetVisible,
        pickedImageUrl: state.pickedImageUrl,
        scrapName: state.scrapName,
        isNameExisted: state.isNameExisted,
      );
      try {
        bool checkNameResult =
            await _scrapCategoryHandler.checkScrapName(name: state.scrapName);
        print(checkNameResult);
        if (checkNameResult) {
          String imagePath = TextConstants.emptyString;
          if (state.pickedImageUrl.isNotEmpty) {
            // Upload image
            imagePath = await _scrapCategoryHandler.uploadImage(
                imagePath: state.pickedImageUrl);
          }
          // Create details list
          List<ScrapCategoryModel> details =
              await _getScrapCategoryUnitPriceList(
                  controllers: state.controllers);

          // Submit category
          var result = await _scrapCategoryHandler.createScrapCategory(
            model: CreateScrapCategoryRequestModel(
              name: state.scrapName,
              imageUrl: imagePath,
              details: details,
            ),
          );

          if (result) {
            yield SubmittedState(
                message: TextConstants.addScrapCategorySucessfull);
          } else {
            yield ErrorState(
              message: TextConstants.errorHappenedTryAgain,
              controllers: state.controllers,
              isImageSourceActionSheetVisible:
                  state.isImageSourceActionSheetVisible,
              pickedImageUrl: state.pickedImageUrl,
              scrapName: state.scrapName,
              isNameExisted: state.isNameExisted,
            );
          }
        } else {
          yield AddCategoryState(
            controllers: state.controllers,
            isImageSourceActionSheetVisible:
                state.isImageSourceActionSheetVisible,
            pickedImageUrl: state.pickedImageUrl,
            scrapName: state.scrapName,
            isNameExisted: true,
          );
        }
      } catch (e) {
        print(e);
        yield ErrorState(
          message: TextConstants.errorHappenedTryAgain,
          controllers: state.controllers,
          isImageSourceActionSheetVisible:
              state.isImageSourceActionSheetVisible,
          pickedImageUrl: state.pickedImageUrl,
          scrapName: state.scrapName,
          isNameExisted: state.isNameExisted,
        );
      }
    }
    if (event is EventCloseImagePicker) {
      yield state.copyWith(isImageSourceActionSheetVisible: false);
    }
  }

  Future<List<ScrapCategoryModel>> _getScrapCategoryUnitPriceList({
    required Map<TextEditingController, TextEditingController> controllers,
  }) async {
    List<ScrapCategoryModel> list = [];
    for (var key in controllers.keys) {
      if (key.text != TextConstants.emptyString)
        list.add(ScrapCategoryModel.createCategoryModel(
            unit: key.text,
            price: int.tryParse(
                    controllers[key]?.text ?? TextConstants.zeroString) ??
                0));
    }
    return list;
  }
}
