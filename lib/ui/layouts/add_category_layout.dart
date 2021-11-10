import 'dart:io';

import 'package:collector_app/blocs/add_category_bloc.dart';
import 'package:collector_app/blocs/events/add_category_event.dart';
import 'package:collector_app/blocs/states/add_category_state.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/constants/text_constants.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/utils/cool_alert.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryLayout extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  //controllers
  final TextEditingController _scrapNameController = TextEditingController();
  final Map<TextEditingController, TextEditingController> _unitControllers = {
    new TextEditingController(): new TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCategoryBloc(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddCategoryBloc, AddCategoryState>(
              listenWhen: (p, c) => !p.isImageSourceActionSheetVisible,
              listener: (context, state) {
                if (state.isImageSourceActionSheetVisible) {
                  _showImageSourceActionSheet(context);
                }
              }),
          BlocListener<AddCategoryBloc, AddCategoryState>(
              // listenWhen: (p, c) => state,
              listener: (context, state) {
            if (state is LoadingState) {
              EasyLoading.show(status: TextConstants.processing);
            } else {
              EasyLoading.dismiss();
              if (state is SubmittedState) {
                CustomCoolAlert.showCoolAlert(
                    context: context,
                    title: state.message,
                    type: CoolAlertType.success,
                    onTap: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName(Routes.categories));
                    });
              }
              if (state is ErrorState) {
                CustomCoolAlert.showCoolAlert(
                  context: context,
                  title: state.message,
                  type: CoolAlertType.error,
                );
              }
            }
          }),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              TextConstants.addCategory,
            ),
          ),
          body: _addCategoryBody(),
        ),
      ),
    );
  }

  _addCategoryBody() {
    return BlocBuilder<AddCategoryBloc, AddCategoryState>(
      builder: (blocContext, state) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 90,
                  child: ListView(
                    primary: false,
                    shrinkWrap: true,
                    children: [
                      FunctionalWidgets.customText(text: TextConstants.image),
                      _scrapImage(),
                      _scrapNameField(),
                      _detailTextAndButton(blocContext),
                      _scrapUnit(),
                    ],
                  ),
                ),
                //Form submit button
                Flexible(
                  flex: 10,
                  fit: FlexFit.loose,
                  child: _buttons(blocContext),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _scrapNameField() {
    return BlocBuilder<AddCategoryBloc, AddCategoryState>(
      buildWhen: (p, c) => p.isNameExisted != c.isNameExisted,
      builder: (context, state) {
        return TextFormField(
          controller: _scrapNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: TextConstants.scrapCategoryName,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          onChanged: (value) {
            context
                .read<AddCategoryBloc>()
                .add(EventChangeScrapName(scrapName: value));
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty)
              return TextConstants.inputScrapCategoryName;
            if (state.isNameExisted) return TextConstants.scrapNameExisted;
          },
        );
      },
    );
  }

  Row _detailTextAndButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FunctionalWidgets.customText(text: TextConstants.detail),
        InkWell(
          onTap: () {
            _unitControllers.putIfAbsent(
                new TextEditingController(), () => new TextEditingController());
            context
                .read<AddCategoryBloc>()
                .add(EventAddScrapCategoryUnit(controllers: _unitControllers));
          },
          child: SizedBox(width: 50, child: Icon(Icons.add)),
        )
      ],
    );
  }

  _scrapImage() {
    return BlocBuilder<AddCategoryBloc, AddCategoryState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
          height: 150,
          child: Center(
            child: InkWell(
              onTap: () {
                context
                    .read<AddCategoryBloc>()
                    .add(EventChangeScrapImageRequest());
              },
              child: state.pickedImageUrl != TextConstants.emptyString
                  ? Image.file(File(state.pickedImageUrl))
                  : Icon(
                      Icons.add_a_photo,
                      size: 100,
                    ),
            ),
          ),
        );
      },
    );
  }

  _scrapUnit() {
    return BlocBuilder<AddCategoryBloc, AddCategoryState>(
      builder: (context, state) {
        return FormField(
          builder: (formFieldState) => Column(
            children: [
              if (formFieldState.hasError && formFieldState.errorText != null)
                Text(
                  formFieldState.errorText!,
                  style: TextStyle(color: Colors.red),
                ),
              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: state.controllers.length,
                  itemBuilder: (context, index) {
                    return FunctionalWidgets.rowFlexibleBuilder(
                      SizedBox(
                        height: 90,
                        child: TextFormField(
                          controller: state.controllers.keys.elementAt(index),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: TextConstants.unit,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                          validator: (value) {
                            if (value == TextConstants.emptyString) return null;
                            var text = TextConstants.unitIsExisted;
                            var count = 0;
                            _unitControllers.keys.forEach((element) {
                              if (element.text == value?.trim()) {
                                count++;
                              }
                            });
                            if (count >= 2)
                              return text;
                            else
                              return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 90,
                        child: TextFormField(
                          controller: state.controllers.values.elementAt(index),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: TextConstants.unitPrice,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                      ),
                      rowFlexibleType.bigToSmall,
                    );
                  }),
            ],
          ),
          validator: (value) {
            if (!state.isOneUnitExist)
              return TextConstants.eachScrapCategoryHasAtLeastOneUnit;
          },
        );
      },
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    Function(ImageSource) selectImageSource = (imageSource) {
      context
          .read<AddCategoryBloc>()
          .add(EventOpenImagePicker(imageSource: imageSource));
    };

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (_) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text(TextConstants.camera),
            onTap: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text(TextConstants.gallery),
            onTap: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.gallery);
            },
          ),
        ],
      ),
    ).then((value) =>
        context.read<AddCategoryBloc>().add(EventCloseImagePicker()));
  }

  Container _buttons(BuildContext blocContext) {
    return Container(
      height: 40,
      child: FunctionalWidgets.rowFlexibleBuilder(
        FunctionalWidgets.customCancelButton(blocContext, TextConstants.cancel),
        FunctionalWidgets.customElevatedButton(
            blocContext, TextConstants.addScrapCategory, () {
          if (_formKey.currentState!.validate()) {
            blocContext.read<AddCategoryBloc>().add(EventSubmitScrapCategory());
          }
        }),
        rowFlexibleType.smallToBig,
      ),
    );
  }
}
