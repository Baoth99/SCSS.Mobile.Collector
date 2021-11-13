import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class AddCategoryEvent extends Equatable {}

class EventInitData extends AddCategoryEvent {
  @override
  List<Object?> get props => [];
}

class EventChangeScrapImageRequest extends AddCategoryEvent {
  @override
  List<Object?> get props => [];
}

class EventOpenImagePicker extends AddCategoryEvent {
  final ImageSource imageSource;

  EventOpenImagePicker({required this.imageSource});

  @override
  List<Object?> get props => [imageSource];
}

class EventAddScrapCategoryUnit extends AddCategoryEvent {
  @override
  List<Object?> get props => [];
}

class EventSubmitScrapCategory extends AddCategoryEvent {
  @override
  List<Object?> get props => [];
}

class EventChangeScrapName extends AddCategoryEvent {
  final String scrapName;

  EventChangeScrapName({required this.scrapName});

  @override
  List<Object?> get props => [scrapName];
}

class EventChangeUnitAndPrice extends AddCategoryEvent {
  final int index;
  final String unit;
  final String price;

  EventChangeUnitAndPrice({
    required this.index,
    required this.unit,
    required this.price,
  });

  @override
  List<Object?> get props => [index, unit, price];
}
