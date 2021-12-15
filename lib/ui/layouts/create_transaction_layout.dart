import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collector_app/blocs/create_transaction_bloc.dart';
import 'package:collector_app/blocs/events/create_transaction_event.dart';
import 'package:collector_app/blocs/models/scrap_category_unit_model.dart';
import 'package:collector_app/blocs/states/create_transaction_state.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/constants/text_constants.dart';
import 'package:collector_app/ui/layouts/seller_transaction_detail_layout.dart';
import 'package:collector_app/ui/widgets/avartar_widget.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/ui/widgets/radiant_gradient_mask.dart';
import 'package:collector_app/utils/currency_text_formatter.dart';
import 'package:collector_app/utils/custom_formats.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'activity_layout.dart';

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
                if (state.process == CreateTransactionProcess.processing) {
                  EasyLoading.show(status: 'Đang xử lí...');
                } else {
                  EasyLoading.dismiss();
                  if (state.process == CreateTransactionProcess.error) {
                    FunctionalWidgets.showAwesomeDialog(
                      context,
                      dialogType: DialogType.ERROR,
                      desc: TextConstants.createTransactionFailedText,
                      btnOkText: 'Đóng',
                    );
                  } else if (state.process == CreateTransactionProcess.valid) {
                    FunctionalWidgets.showAwesomeDialog(
                      context,
                      dialogType: DialogType.SUCCES,
                      desc: TextConstants.createTransactionSuccessfullyText,
                      btnOkText: 'Đóng',
                      btnOkOnpress: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(
                          Routes.sellerTransactionDetail,
                          arguments: SellerTransctionDetailArgs(
                            arguments['collectingRequestId'],
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ],
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              title: Text(
                TextConstants.createTransaction,
              ),
            ),
            body: _body(arguments: arguments),
          ),
        ),
      );
    } else
      return FunctionalWidgets.customErrorWidget();
  }

  _body({required Map arguments}) {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 48.w),
                        child: Row(
                          children: [
                            RadiantGradientMask(
                              child: Icon(
                                Icons.description_outlined,
                                color: AppColors.greenFF01C971,
                                size: 60.sp,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  child: CustomText(
                                    text:
                                        'Mã Đơn: ${arguments['collectingRequestCode']}',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 35.sp,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 20.h,
                        height: 100.h,
                        color: AppColors.greyFFEEEEEE,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 48.w),
                        child: Row(
                          children: [
                            AvatarRadiantGradientMask(
                              child: Icon(
                                Icons.account_circle_sharp,
                                color: Colors.white,
                                size: 130.sp,
                              ),
                            ),
                            SizedBox(
                              width: 40.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: '${arguments['sellerName']}',
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(height: 10),
                                // Text('SĐT người bán: ${arguments['sellerPhone']}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 20.h,
                        height: 100.h,
                        color: AppColors.greyFFEEEEEE,
                      ),
                      _detailText(),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 30.h),
                        child: _items(),
                      ),
                      if (state.transactionFee != 0) const Divider(),
                      if (state.transactionFee != 0) _transactionFee(),
                      _getDottedDivider(),
                      _total(),
                    ],
                  ),
                ),
                Flexible(
                    flex: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 48.w),
                      child: _transactionButtons(),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  _detailText() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 48.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Chi tiết',
                color: AppColors.black,
                fontSize: 42.sp,
              ),
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
          ),
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
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 48.w),
          child: FormField(
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
                      tileColor: Colors.grey[200],
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: CustomText(
                                text: state.scrapCategories
                                    .firstWhere((element) =>
                                        element.id ==
                                        state.items[index].collectorCategoryId)
                                    .name,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 42.sp,
                                color: Colors.grey[800],
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
                                child: CustomText(
                                  text: state.items[index].quantity != 0 &&
                                          state.items[index].unit != null
                                      ? '${CustomFormats.replaceDotWithComma(CustomFormats.quantityFormat.format(state.items[index].quantity))} ${state.items[index].unit}'
                                      : TextConstants.emptyString,
                                  textAlign: TextAlign.center,
                                  fontSize: 42.sp,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          if (!(state.items[index].quantity != 0 &&
                              state.items[index].unit != null &&
                              state.items[index].isCalculatedByUnitPrice))
                            Flexible(
                              flex: 3,
                              fit: FlexFit.loose,
                              child: Align(
                                alignment: Alignment.center,
                                child: CustomText(
                                  text: '-',
                                  fontSize: 60.sp,
                                  color: Colors.grey[800],
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          Flexible(
                            flex: 4,
                            fit: FlexFit.tight,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CustomText(
                                text: CustomFormats.currencyFormat(
                                    state.items[index].total),
                                textAlign: TextAlign.right,
                                fontSize: 42.sp,
                                color: Colors.grey[800],
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
              if (state.items.length == 0)
                return TextConstants.noItemsErrorText;
            },
          ),
        );
      },
    );
  }

  _getDottedDivider() {
    return Container(
      padding:
          EdgeInsets.only(top: 50.h, bottom: 50.h, left: 48.w, right: 48.w),
      child: DottedLine(
        direction: Axis.horizontal,
        dashGapLength: 3.0,
        dashColor: AppColors.greyFFB5B5B5,
      ),
    );
  }

  _transactionFee() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 48.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(TextConstants.transactionFee),
              Text(CustomFormats.currencyFormat(state.transactionFee)),
            ],
          ),
        );
      },
    );
  }

  _total() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 48.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: TextConstants.total,
                fontSize: 48.sp,
                fontWeight: FontWeight.w500,
              ),
              CustomText(
                text: CustomFormats.currencyFormat(state.grandTotal),
                fontSize: 48.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
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
            FunctionalWidgets.customCancelButton(context, 'Quay lại'),
            FunctionalWidgets.customElevatedButton(
                context, TextConstants.createTransaction, () {
              if (_formKey.currentState!.validate()) {
                FunctionalWidgets.showAwesomeDialog(
                  context,
                  dialogType: DialogType.QUESTION,
                  desc: 'Tạo giao dịch?',
                  btnCancelText: 'Hủy',
                  btnOkText: 'Đồng ý',
                  btnOkOnpress: () {
                    context
                        .read<CreateTransactionBloc>()
                        .add(EventSubmitNewTransaction());
                  },
                );
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
          content: Scrollbar(
            isAlwaysShown: true,
            child: SizedBox(
              width: 320,
              height: 340,
              child: Form(
                key: _itemFormKey,
                child: Container(
                  padding: EdgeInsets.only(right: 15.w),
                  child: ListView(
                    children: [
                      _calculatedByUnitPriceSwitch(),
                      FunctionalWidgets.rowFlexibleBuilder(
                        _scrapCategoryUnitField(),
                        _scrapCategoryField(),
                        rowFlexibleType.bigToSmall,
                      ),
                      _quantityField(),
                      BlocBuilder<CreateTransactionBloc,
                          CreateTransactionState>(
                        builder: (context, state) {
                          return Visibility(
                            visible: (state.itemQuantity -
                                    state.itemQuantity.truncate()) >
                                0,
                            child: Container(
                              padding:
                                  EdgeInsets.only(bottom: 40.h, left: 20.w),
                              child: CustomText(
                                text: '* Chữ số thập phân sử dụng dấu "," '
                                    'nên dùng cho các loại đơn vị như kilogam, gam, tạ, tấn,... ',
                                fontSize: 35.sp,
                                color: AppColors.greyFF939393,
                              ),
                            ),
                          );
                        },
                      ),
                      _unitPriceField(),
                      _totalField(),
                    ],
                  ),
                ),
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
        return Container(
          decoration: BoxDecoration(
            color: AppColors.greyFFF8F8F8,
            borderRadius: BorderRadius.circular(30.0.r),
          ),
          margin: EdgeInsets.only(bottom: 50.h),
          child: SizedBox(
            height: 210.h,
            child: ListTile(
              isThreeLine: true,
              title: Text(
                TextConstants.calculatedByUnitPrice,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                TextConstants.calculatedByUnitPriceExplaination,
                style: TextStyle(fontSize: 36.sp),
              ),
              trailing: SizedBox(
                height: 80.h,
                child: Switch(
                  value: state.isItemTotalCalculatedByUnitPrice,
                  onChanged: state.itemDealerCategoryId != TextConstants.zeroId
                      ? (value) {
                          context.read<CreateTransactionBloc>().add(
                              EventCalculatedByUnitPriceChanged(
                                  isCalculatedByUnitPrice: value));
                        }
                      : null,
                ),
              ),
            ),
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
            dropdownSearchDecoration: InputDecoration(
              labelText: TextConstants.scrapType,
              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              border: OutlineInputBorder(),
            ),
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
            dropdownSearchDecoration: InputDecoration(
              labelText: TextConstants.unit,
              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              border: OutlineInputBorder(),
            ),
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
          child: Container(
            margin: EdgeInsets.only(bottom: 30.h),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: TextConstants.quantity,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*,?\d*)')),
              ],
              initialValue: CustomFormats.replaceDotWithComma(
                  CustomFormats.quantityFormat.format(state.itemQuantity)),
              onChanged: (value) {
                if (value != TextConstants.emptyString && value != ',') {
                  var valueWithDot = value.replaceAll(RegExp(r'[^0-9],'), '');
                  valueWithDot = valueWithDot.replaceAll(RegExp(r','), '.');
                  context
                      .read<CreateTransactionBloc>()
                      .add(EventQuantityChanged(quantity: valueWithDot));
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
          child: Container(
            margin: EdgeInsets.only(top: 16),
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
                  suffixText: Symbols.vndSymbolUnderlined,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyTextFormatter()],
                //get the unit price for each unit
                initialValue: CustomFormats.numberFormat(state.itemPrice),
                onChanged: (value) {
                  if (value != TextConstants.emptyString) {
                    context.read<CreateTransactionBloc>().add(
                        EventUnitPriceChanged(
                            unitPrice:
                                value.replaceAll(RegExp(r'[^0-9]'), '')));
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
              suffixText: Symbols.vndSymbolUnderlined,
              errorStyle: TextStyle(
                color: Theme.of(context).errorColor, // or any other color
              ),
            ),
            enabled: !state.isItemTotalCalculatedByUnitPrice,
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyTextFormatter()],
            initialValue: state.isItemTotalCalculatedByUnitPrice
                ? CustomFormats.numberFormat(state.itemTotalCalculated)
                : CustomFormats.numberFormat(state.itemTotal),
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
              if (!state.isItemTotalSmallerThanZero) {
                return TextConstants.totalSmallerThanZero;
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
