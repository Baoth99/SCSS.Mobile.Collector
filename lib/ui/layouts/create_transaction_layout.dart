import 'package:collector_app/blocs/create_transaction_bloc.dart';
import 'package:collector_app/blocs/events/create_transaction_event.dart';
import 'package:collector_app/blocs/models/scrap_category_unit_model.dart';
import 'package:collector_app/blocs/states/create_transaction_state.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/constants/text_constants.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/utils/cool_alert.dart';
import 'package:collector_app/utils/currency_text_formatter.dart';
import 'package:collector_app/utils/custom_formats.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CreateTransactionLayout extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _itemFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Map? arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arguments != null) {
      return BlocProvider(
        create: (context) => CreateTransactionBloc(
          collectingRequestId: arguments['collectingRequestId'],
          collectingRequestCode: arguments['collectingRequestCode'],
          sellerName: arguments['sellerName'],
          sellerPhone: arguments['collectingRequestId'],
          sellerAvatarUrl: arguments['collectingRequestId'],
        ),
        child: MultiBlocListener(
          listeners: [
            BlocListener<CreateTransactionBloc, CreateTransactionState>(
              listener: (context, state) {
                if (state.isModalBottomSheetShowed) {
                  _showItemDialog(context);
                }
                //process
                if (state.process == CreateTransactionProcess.processed) {
                  EasyLoading.dismiss();
                } else if (state.process == CreateTransactionProcess.error) {
                  CustomCoolAlert.showCoolAlert(
                    context: context,
                    title: TextConstants.createTransactionFailedText,
                    type: CoolAlertType.error,
                  );
                } else if (state.process == CreateTransactionProcess.valid) {
                  CustomCoolAlert.showCoolAlert(
                    context: context,
                    title: TextConstants.createTransactionSuccessfullyText,
                    type: CoolAlertType.success,
                  );
                }
              },
            ),
            BlocListener<CreateTransactionBloc, CreateTransactionState>(
                listenWhen: (previous, current) {
              return previous.process == CreateTransactionProcess.neutral;
            }, listener: (context, state) {
              if (state.process == CreateTransactionProcess.processing) {
                EasyLoading.show(status: 'Đang xử lí...');
              }
            }),
          ],
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              title: Text(
                TextConstants.createTransaction,
              ),
            ),
            body: _body(),
          ),
        ),
      );
    } else
      return FunctionalWidgets.customErrorWidget();
  }

  _body() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 90,
                  fit: FlexFit.tight,
                  child: ListView(
                    children: [
                      // _phoneField(),
                      // _nameField(),
                      _detailText(),
                      _items(),
                      const Divider(),
                      const Divider(),
                      _total(),
                    ],
                  ),
                ),
                Flexible(
                  flex: 10,
                  child: _transactionButtons(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _phoneField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: TextConstants.sellerPhone,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            enabled: false,
          ),
        );
      },
    );
  }

  _nameField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            enabled: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: TextConstants.sellerName,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        );
      },
    );
  }

  _detailText() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(TextConstants.detail),
            //add item button
            Visibility(
              visible: state.scrapCategoryMap.length != 0,
              child: InkWell(
                onTap: () {
                  context
                      .read<CreateTransactionBloc>()
                      .add(EventShowItemDialog());
                },
                child: SizedBox(width: 50, child: Icon(Icons.add)),
              ),
            ),
          ],
        );
      },
    );
  }

  _items() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      buildWhen: (previous, current) {
        return previous.isItemsUpdated == false &&
            current.isItemsUpdated == true;
      },
      builder: (context, state) {
        return FormField(
          builder: (formFieldState) => Column(
            children: [
              ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      context
                          .read<CreateTransactionBloc>()
                          .add(EventShowItemDialog(
                            key: index,
                            detail: state.items[index],
                          ));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    tileColor: AppConstants.lightGray,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              state.scrapCategories
                                  .firstWhere((element) =>
                                      element.id ==
                                      state.items[index].collectorCategoryId)
                                  .name,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        if (state.items[index].quantity != 0 &&
                            state.items[index].unit != null &&
                            state.items[index].isCalculatedByUnitPrice)
                          Flexible(
                            flex: 3,
                            fit: FlexFit.loose,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                state.items[index].quantity != 0 &&
                                        state.items[index].unit != null
                                    ? '${CustomFormats.numberFormat.format(state.items[index].quantity)} ${state.items[index].unit}'
                                    : TextConstants.emptyString,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        Flexible(
                          flex: 4,
                          fit: FlexFit.tight,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              CustomFormats.currencyFormat
                                  .format(state.items[index].total),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10,
                  );
                },
              ),
              if (formFieldState.hasError && formFieldState.errorText != null)
                Text(
                  formFieldState.errorText!,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          validator: (value) {
            if (state.items.length == 0) return TextConstants.noItemsErrorText;
          },
        );
      },
    );
  }

  _total() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(TextConstants.total),
            Text(CustomFormats.currencyFormat.format(state.total)),
          ],
        );
      },
    );
  }

  _transactionButtons() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Container(
          height: 40,
          child: FunctionalWidgets.rowFlexibleBuilder(
            FunctionalWidgets.customCancelButton(context, TextConstants.cancel),
            FunctionalWidgets.customElevatedButton(
                context, TextConstants.createTransaction, () {
              if (_formKey.currentState!.validate()) {
                context
                    .read<CreateTransactionBloc>()
                    .add(EventSubmitNewTransaction());
              }
            }),
            rowFlexibleType.smallToBig,
          ),
        );
      },
    );
  }

// Item fields
  void _showItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<CreateTransactionBloc>(context),
        child: AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 320,
            height: 400,
            child: Form(
              key: _itemFormKey,
              child: ListView(
                children: [
                  _calculatedByUnitPriceSwitch(),
                  FunctionalWidgets.rowFlexibleBuilder(
                    _scrapCategoryUnitField(),
                    _scrapCategoryField(),
                    rowFlexibleType.bigToSmall,
                  ),
                  _quantityField(),
                  _unitPriceField(),
                  _totalField(),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
                  builder: (context, state) {
                    return Visibility(
                      visible: state.key != null && !state.isNewItem,
                      child: _deleteItemButton(),
                    );
                  },
                ),
                Row(
                  children: [
                    FunctionalWidgets.customCancelButton(
                        context, TextConstants.cancel),
                    SizedBox(
                      width: 10,
                    ),
                    _addAndUpdateItemButton(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ).then((value) =>
        context.read<CreateTransactionBloc>().add(EventDissmissPopup()));
  }

  _calculatedByUnitPriceSwitch() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return ListTile(
          isThreeLine: true,
          title: Text(TextConstants.calculatedByUnitPrice),
          subtitle: Text(TextConstants.calculatedByUnitPriceExplaination),
          trailing: Switch(
            value: state.isItemTotalCalculatedByUnitPrice,
            onChanged: state.itemDealerCategoryId != TextConstants.zeroId
                ? (value) {
                    context.read<CreateTransactionBloc>().add(
                        EventCalculatedByUnitPriceChanged(
                            isCalculatedByUnitPrice: value));
                  }
                : null,
          ),
        );
      },
    );
  }

  _scrapCategoryField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: DropdownSearch(
            mode: Mode.DIALOG,
            maxHeight: 250,
            showSelectedItems: true,
            showSearchBox: true,
            label: TextConstants.scrapType,
            items: state.scrapCategoryMap.keys.toList(),
            selectedItem:
                state.itemDealerCategoryId != TextConstants.emptyString
                    ? state.itemDealerCategoryId
                    : null,
            compareFn: (String? item, String? selectedItem) =>
                item == selectedItem,
            itemAsString: (String? id) => id != null
                ? state.scrapCategoryMap[id] ?? TextConstants.emptyString
                : TextConstants.emptyString,
            validator: (value) {
              if (value == null || value == TextConstants.emptyString)
                return TextConstants.scrapTypeBlank;
              if (!state.isScrapCategoryValid)
                return TextConstants.scrapTypeNotChoosenError;
            },
            onChanged: (String? selectedValue) {
              if (selectedValue != null)
                context.read<CreateTransactionBloc>().add(
                    EventDealerCategoryChanged(
                        collectorCategoryId: selectedValue));
            },
          ),
        );
      },
    );
  }

  _scrapCategoryUnitField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: DropdownSearch(
            enabled: state.scrapCategoryDetails.isNotEmpty &&
                state.isItemTotalCalculatedByUnitPrice,
            selectedItem: state.itemDealerCategoryDetailId != null &&
                    state.isItemTotalCalculatedByUnitPrice
                ? state.scrapCategoryDetails.firstWhere(
                    (element) => element.id == state.itemDealerCategoryDetailId)
                : null,
            mode: Mode.DIALOG,
            maxHeight: 250,
            showSelectedItems: true,
            label: TextConstants.unit,
            items: state.scrapCategoryDetails,
            compareFn: (ScrapCategoryUnitModel? item,
                    ScrapCategoryUnitModel? selectedItem) =>
                item?.id == selectedItem?.id,
            itemAsString: (ScrapCategoryUnitModel? model) =>
                model != null ? model.unit : TextConstants.emptyString,
            validator: (value) {
              if (state.isItemTotalCalculatedByUnitPrice) {
                if (value == null || value == TextConstants.emptyString)
                  return TextConstants.scrapCategoryUnitBlank;
              }
            },
            onChanged: (ScrapCategoryUnitModel? selectedValue) {
              if (selectedValue != null)
                context.read<CreateTransactionBloc>().add(
                    EventDealerCategoryUnitChanged(
                        collectorCategoryDetailId: selectedValue.id));
            },
          ),
        );
      },
    );
  }

  _quantityField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isItemTotalCalculatedByUnitPrice,
          child: SizedBox(
            height: 90,
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: TextConstants.quantity,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyTextFormatter()],
              initialValue:
                  CustomFormats.numberFormat.format(state.itemQuantity),
              onChanged: (value) {
                if (value != TextConstants.emptyString) {
                  context.read<CreateTransactionBloc>().add(
                      EventQuantityChanged(
                          quantity: value.replaceAll(RegExp(r'[^0-9]'), '')));
                } else {
                  context.read<CreateTransactionBloc>().add(
                      EventQuantityChanged(quantity: TextConstants.zeroString));
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty)
                  return TextConstants.quantityBlank;
                if (!state.isItemQuantityValid) {
                  return TextConstants.quantityZero;
                }
              },
            ),
          ),
        );
      },
    );
  }

  _unitPriceField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isItemTotalCalculatedByUnitPrice,
          child: SizedBox(
            height: 90,
            child: TextFormField(
              key: state.itemDealerCategoryDetailId != null
                  ? Key(state.itemDealerCategoryDetailId!)
                  : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: TextConstants.unitPrice,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                suffixText: Symbols.vndSymbolText,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyTextFormatter()],
              //get the unit price for each unit
              initialValue: CustomFormats.numberFormat.format(state.itemPrice),
              onChanged: (value) {
                if (value != TextConstants.emptyString) {
                  context.read<CreateTransactionBloc>().add(
                      EventUnitPriceChanged(
                          unitPrice: value.replaceAll(RegExp(r'[^0-9]'), '')));
                } else {
                  context.read<CreateTransactionBloc>().add(
                      EventUnitPriceChanged(
                          unitPrice: TextConstants.zeroString));
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty)
                  return TextConstants.unitPriceBlank;
                if (!state.isItemPriceValid) {
                  return TextConstants.unitPriceNegative;
                }
              },
            ),
          ),
        );
      },
    );
  }

  _totalField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          key: state.isItemTotalCalculatedByUnitPrice ? UniqueKey() : null,
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: TextConstants.total,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixText: Symbols.vndSymbolText,
              errorStyle: TextStyle(
                color: Theme.of(context).errorColor, // or any other color
              ),
            ),
            enabled: !state.isItemTotalCalculatedByUnitPrice,
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyTextFormatter()],
            initialValue: state.isItemTotalCalculatedByUnitPrice
                ? CustomFormats.numberFormat.format(state.itemTotalCalculated)
                : CustomFormats.numberFormat.format(state.itemTotal),
            onChanged: (value) {
              if (value != TextConstants.emptyString) {
                context.read<CreateTransactionBloc>().add(EventItemTotalChanged(
                    total: value.replaceAll(RegExp(r'[^0-9]'), '')));
              } else {
                context.read<CreateTransactionBloc>().add(
                    EventItemTotalChanged(total: TextConstants.zeroString));
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty)
                return TextConstants.totalBlank;
              if (!state.isItemTotalNegative) {
                return TextConstants.totalNegative;
              }
              if (!state.isItemTotalUnderLimit) {
                return TextConstants.totalOverLimit;
              }
            },
          ),
        );
      },
    );
  }

  _addAndUpdateItemButton() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return FunctionalWidgets.customElevatedButton(
            context,
            state.key == null
                ? TextConstants.addScrap
                : TextConstants.saveUpdate, () {
          if (_itemFormKey.currentState!.validate()) {
            if (state.isNewItem)
              context.read<CreateTransactionBloc>().add(EventAddNewItem());
            else
              context.read<CreateTransactionBloc>().add(EventUpdateItem());
            Navigator.of(context).pop();
          }
        });
      },
    );
  }

  _deleteItemButton() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return FunctionalWidgets.customSecondaryButton(
          text: TextConstants.delete,
          action: () {
            context
                .read<CreateTransactionBloc>()
                .add(EventDeleteItem(key: state.key!));
            Navigator.of(context).pop();
          },
          textColor: MaterialStateProperty.all(Colors.white),
          backgroundColor: MaterialStateProperty.all(Colors.red),
        );
      },
    );
  }
}
