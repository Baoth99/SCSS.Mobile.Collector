import 'package:collector_app/constants/text_constants.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/networks/models/request/create_category_request_model.dart';
import 'package:collector_app/providers/services/scrap_category_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'events/add_category_event.dart';
import 'models/scrap_category_model.dart';
import 'states/add_category_state.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final _picker = ImagePicker();
  final _scrapCategoryHandler = getIt.get<IScrapCategoryService>();

  AddCategoryBloc() : super(AddCategoryState()) {
    add(EventInitData());
  }

  @override
  Stream<AddCategoryState> mapEventToState(AddCategoryEvent event) async* {
    if (event is EventInitData) {
      // Add one empty unit
      List<ScrapCategoryModel> units = [
        ScrapCategoryModel.createCategoryModel(
            unit: TextConstants.emptyString, price: 0),
      ];
      yield AddCategoryState(units: units);
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
      List<ScrapCategoryModel> units = List.from(state.units);
      units.add(ScrapCategoryModel.createCategoryModel(
        unit: TextConstants.emptyString,
        price: 0,
      ));

      yield state.copyWith(units: units);
    }
    if (event is EventChangeUnitAndPrice) {
      List<ScrapCategoryModel> units = List.from(state.units);
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
        scrapName: state.scrapName.trim(),
        isNameExisted: state.isNameExisted,
      );
      try {
        // Check if name hasn't changed
        bool checkNameResult =
            await _scrapCategoryHandler.checkScrapName(name: state.scrapName);
        if (checkNameResult) {
          String imagePath = state.initScrapImageUrl;
          if (state.pickedImageUrl.isNotEmpty) {
            // Upload image
            imagePath = await _scrapCategoryHandler.uploadImage(
                imagePath: state.pickedImageUrl);
          }

          // Submit category
          var result = await _scrapCategoryHandler.createScrapCategory(
            model: CreateScrapCategoryRequestModel(
              name: state.scrapName,
              imageUrl: imagePath,
              details: await _getListFiltered(units: state.units),
            ),
          );

          if (result) {
            yield SubmittedState(
                message: TextConstants.addScrapCategorySucessfull);
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
          yield AddCategoryState(
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
  }

  Future<List<ScrapCategoryModel>> _getListFiltered({
    required List<ScrapCategoryModel> units,
  }) async {
    List<ScrapCategoryModel> list = List.from(units);
    // Remove empty new unit
    list.removeWhere((element) =>
        element.unit.isEmpty && element.id == TextConstants.zeroId);
    return list;
  }
}
