import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class CategoryDetailEvent extends Equatable {}

class EventInitData extends CategoryDetailEvent {
  @override
  List<Object?> get props => [];
}

class EventChangeScrapImageRequest extends CategoryDetailEvent {
  @override
  List<Object?> get props => [];
}

class EventOpenImagePicker extends CategoryDetailEvent {
  final ImageSource imageSource;

  EventOpenImagePicker({required this.imageSource});

  @override
  List<Object?> get props => [imageSource];
}

class EventAddScrapCategoryUnit extends CategoryDetailEvent {
  @override
  List<Object?> get props => [];
}

class EventSubmitScrapCategory extends CategoryDetailEvent {
  @override
  List<Object?> get props => [];
}

class EventChangeScrapName extends CategoryDetailEvent {
  final String scrapName;

  EventChangeScrapName({required this.scrapName});

  @override
  List<Object?> get props => [scrapName];
}

class EventChangeUnitAndPrice extends CategoryDetailEvent {
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

class EventDeleteScrapCategory extends CategoryDetailEvent {
  @override
  List<Object?> get props => [];
}

class EventTapDeleteButton extends CategoryDetailEvent {
  @override
  List<Object?> get props => [];
}
