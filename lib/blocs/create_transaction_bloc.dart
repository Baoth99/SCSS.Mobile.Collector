import 'package:collector_app/constants/text_constants.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/data_service.dart';
import 'package:collector_app/providers/services/models/create_sell_collect_transaction_request_model.dart';
import 'package:collector_app/providers/services/transaction_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events/create_transaction_event.dart';
import 'models/create_transaction_detail_model.dart';
import 'models/scrap_category_unit_model.dart';
import 'states/create_transaction_state.dart';

class CreateTransactionBloc
    extends Bloc<CreateTransactionEvent, CreateTransactionState> {
  var dataHandler = getIt.get<IDataService>();
  var collectDealTransactionHandler = getIt.get<TransactionService>();

  CreateTransactionBloc({
    required this.collectingRequestId,
    required this.collectingRequestCode,
    required this.sellerName,
    required this.sellerPhone,
    required this.sellerAvatarUrl,
  }) : super(CreateTransactionState()) {
    add(EventInitValues());
  }

  final String collectingRequestId;
  final String collectingRequestCode;
  final String sellerName;
  final String sellerPhone;
  final String sellerAvatarUrl;

  @override
  Stream<CreateTransactionState> mapEventToState(
      CreateTransactionEvent event) async* {
    if (event is EventInitValues) {
      //get categories
      yield state.copyWith(process: CreateTransactionProcess.processing);
      try {
        var scrapCategories = await dataHandler.getScrapCategoryList();
        if (scrapCategories != null) {
          Map<String, String> scrapCategoryMap = {};
          scrapCategories.forEach((element) {
            scrapCategoryMap.putIfAbsent(element.id, () => element.name);
          });
          yield state.copyWith(
            scrapCategories: scrapCategories,
            scrapCategoryMap: scrapCategoryMap,
            itemDealerCategoryId: TextConstants.zeroId,
          );
        }
        yield state.copyWith(process: CreateTransactionProcess.processed);
      } catch (e) {
        yield state.copyWith(process: CreateTransactionProcess.processed);
        yield state.copyWith(process: CreateTransactionProcess.error);
      } finally {
        yield state.copyWith(process: CreateTransactionProcess.neutral);
      }
    } else if (event is EventShowItemDialog) {
      //clear item values
      _resetItemValue();
      // Update dropdown list
      _updateScrapCategoryMap();
      if (event.key == null || event.detail == null) {
        var itemDealerCategoryId = state.scrapCategoryMap.keys.first;
        // Get details
        if (itemDealerCategoryId != TextConstants.zeroId) {
          List<ScrapCategoryUnitModel>? details =
              await dataHandler.getScrapCategoryDetailList(
                  scrapCategoryId: itemDealerCategoryId);
          if (details != null && details.isNotEmpty) {
            state.scrapCategoryDetails = details;
            state.itemDealerCategoryDetailId = details.first.id;
            state.itemPrice = details.first.price;
          }
        }
      }
      // If item is choosen instead
      else {
        // Add scrap category back to the dropdown list
        var scrapCategory = state.scrapCategories.firstWhere(
            (element) => element.id == event.detail!.collectorCategoryId);
        _addScrapCategoryOnItemSelected(
          id: scrapCategory.id,
          name: scrapCategory.name,
        );
        // Get details
        List<ScrapCategoryUnitModel>? details;
        if (event.detail!.collectorCategoryId != TextConstants.zeroId) {
          details = await dataHandler.getScrapCategoryDetailList(
              scrapCategoryId: event.detail!.collectorCategoryId);
        }
        // Add item data
        state.isNewItem = false;
        state.key = event.key;
        state.itemDealerCategoryDetailId =
            event.detail!.collectorCategoryDetailId;
        state.itemDealerCategoryId = event.detail!.collectorCategoryId;
        state.isItemTotalCalculatedByUnitPrice =
            event.detail!.isCalculatedByUnitPrice;
        state.itemPrice = event.detail!.price;
        state.itemQuantity = event.detail!.quantity;
        state.itemTotal = event.detail!.total;
        state.scrapCategoryDetails = details ?? [];
      }
      // Open dialog
      yield state.copyWith(isItemDialogShowed: true);
      yield state.copyWith(isItemDialogShowed: false);
    } else if (event is EventCalculatedByUnitPriceChanged) {
      // If switched on
      yield state.copyWith(
          isItemTotalCalculatedByUnitPrice: event.isCalculatedByUnitPrice);
    } else if (event is EventDealerCategoryChanged) {
      yield state.copyWith(itemDealerCategoryId: event.collectorCategoryId);
      // If not default category
      if (event.collectorCategoryId != TextConstants.zeroId) {
        try {
          //get category details
          yield state.copyWith(process: CreateTransactionProcess.processing);
          var scrapCategoryDetailList =
              await dataHandler.getScrapCategoryDetailList(
                  scrapCategoryId: event.collectorCategoryId);
          if (scrapCategoryDetailList != null)
            yield state.copyWith(
              scrapCategoryDetails: scrapCategoryDetailList,
              itemDealerCategoryDetailId: scrapCategoryDetailList.first.id,
              itemQuantity: 0,
              itemPrice: scrapCategoryDetailList.first.price,
            );
          yield state.copyWith(process: CreateTransactionProcess.processed);
        } catch (e) {
          yield state.copyWith(process: CreateTransactionProcess.processed);
          yield state.copyWith(process: CreateTransactionProcess.error);
        } finally {
          yield state.copyWith(process: CreateTransactionProcess.neutral);
        }
      }
      // If default then switch off calculated option, remove unit list, remove default unit
      else {
        yield state.copyWith(
          scrapCategoryDetails: [],
          isItemTotalCalculatedByUnitPrice: false,
          itemDealerCategoryDetailId: null,
          itemPrice: 0,
          itemQuantity: 0,
        );
      }
    } else if (event is EventDealerCategoryUnitChanged) {
      var unitPrice = state.scrapCategoryDetails
          .firstWhere(
              (element) => element.id == event.collectorCategoryDetailId)
          .price;
      if (unitPrice != null) {
        yield state.copyWith(
            itemDealerCategoryDetailId: event.collectorCategoryDetailId,
            itemPrice: unitPrice);
      } else {
        yield state.copyWith(
            itemDealerCategoryDetailId: event.collectorCategoryDetailId);
      }
    } else if (event is EventItemTotalChanged) {
      var totalInt = int.tryParse(event.total);
      if (totalInt != null)
        yield state.copyWith(itemTotal: totalInt);
      else {
        yield state.copyWith(process: CreateTransactionProcess.error);
        yield state.copyWith(process: CreateTransactionProcess.neutral);
      }
    } else if (event is EventQuantityChanged) {
      var quantity = int.tryParse(event.quantity);
      if (quantity != null)
        yield state.copyWith(itemQuantity: quantity);
      else {
        yield state.copyWith(process: CreateTransactionProcess.error);
        yield state.copyWith(process: CreateTransactionProcess.neutral);
      }
    } else if (event is EventUnitPriceChanged) {
      var unitPrice = int.tryParse(event.unitPrice);
      if (unitPrice != null)
        yield state.copyWith(itemPrice: unitPrice);
      else {
        yield state.copyWith(process: CreateTransactionProcess.error);
        yield state.copyWith(process: CreateTransactionProcess.neutral);
      }
    } else if (event is EventAddNewItem) {
      // Put new item
      state.items.add(SellCollectTransactionDetailModel(
        collectorCategoryId: state.itemDealerCategoryId,
        collectorCategoryDetailId: state.itemDealerCategoryDetailId,
        quantity: state.itemQuantity,
        unit: state.itemDealerCategoryDetailId != null
            ? state.scrapCategoryDetails
                .firstWhere(
                    (element) => element.id == state.itemDealerCategoryDetailId)
                .unit
            : null,
        total: state.isItemTotalCalculatedByUnitPrice
            ? state.itemTotalCalculated
            : state.itemTotal,
        price: state.itemPrice,
        isCalculatedByUnitPrice: state.isItemTotalCalculatedByUnitPrice,
      ));
      // Update category dropdown
      _updateScrapCategoryMap();
      // Update the item list
      yield state.copyWith(isItemsUpdated: true);
      yield state.copyWith(isItemsUpdated: false);
      //clear item values
      _resetItemValue();
      // Reload values
      add(EventReloadValues());
    } else if (event is EventSubmitNewTransaction) {
      //start progress indicator
      yield state.copyWith(process: CreateTransactionProcess.processing);
      try {
        // Remove quantity and price if isCalculatedByUnitPrice = false
        var items = List<SellCollectTransactionDetailModel>.from(state.items);
        items.forEach((element) {
          if (!element.isCalculatedByUnitPrice) {
            element.quantity = 0;
            element.price = 0;
          }
        });

        // Create request model
        var model = CreateSellCollectTransactionRequestModel(
          collectingRequestId: collectingRequestId,
          scrapCategoryItems: items,
          transactionServiceFee: state.transactionFee,
          total: state.total,
        );

        bool result = await collectDealTransactionHandler
            .createSellCollectTransaction(model: model);
        if (result) {
          yield state.copyWith(process: CreateTransactionProcess.processed);
          yield state.copyWith(process: CreateTransactionProcess.valid);
        } else {
          yield state.copyWith(process: CreateTransactionProcess.processed);
          yield state.copyWith(process: CreateTransactionProcess.error);
        }
      } on Exception {
        yield state.copyWith(process: CreateTransactionProcess.processed);
        yield state.copyWith(process: CreateTransactionProcess.error);
      } finally {
        yield state.copyWith(process: CreateTransactionProcess.neutral);
      }
    } else if (event is EventUpdateItem) {
      if (state.key != null) {
        // update item
        state.items[state.key!] = SellCollectTransactionDetailModel(
          collectorCategoryId: state.itemDealerCategoryId,
          collectorCategoryDetailId: state.itemDealerCategoryDetailId,
          quantity: state.itemQuantity,
          unit: state.itemDealerCategoryDetailId != null
              ? state.scrapCategoryDetails
                  .firstWhere((element) =>
                      element.id == state.itemDealerCategoryDetailId)
                  .unit
              : null,
          total: state.isItemTotalCalculatedByUnitPrice
              ? state.itemTotalCalculated
              : state.itemTotal,
          price: state.itemPrice,
          isCalculatedByUnitPrice: state.isItemTotalCalculatedByUnitPrice,
        );
        // Update category dropdown
        _updateScrapCategoryMap();
        // Update the item list
        yield state.copyWith(isItemsUpdated: true);
        yield state.copyWith(isItemsUpdated: false);
        //clear item values
        _resetItemValue();
        // Reload values
        add(EventReloadValues());
      }
    } else if (event is EventReloadValues) {
      // Recalculate total and total bonus amount
      _recalculateTotalAndBonusAmount();
      yield state.copyWith();
    } else if (event is EventDissmissPopup) {
      // Update category dropdown
      _updateScrapCategoryMap();
      yield state.copyWith();
    } else if (event is EventDeleteItem) {
      // Update items
      List<SellCollectTransactionDetailModel> items = List.from(state.items);
      items.removeAt(event.key);
      yield state.copyWith(items: items);
      // Update category dropdown
      _updateScrapCategoryMap();
      // Recalculate total and total bonus amount
      _recalculateTotalAndBonusAmount();
      // Update the item list
      yield state.copyWith(isItemsUpdated: true);
      yield state.copyWith(isItemsUpdated: false);
    }
  }

  _updateScrapCategoryMap() {
    state.items.forEach((item) {
      state.scrapCategoryMap.removeWhere(
          (mapKey, mapValue) => mapKey == item.collectorCategoryId);
    });
  }

  _addScrapCategoryOnItemSelected({required id, required name}) {
    state.scrapCategoryMap.putIfAbsent(id, () => name);
  }

  _resetItemValue() {
    state.isNewItem = true;
    state.key = null;
    state.itemDealerCategoryId = state.scrapCategoryMap.isNotEmpty
        ? state.scrapCategoryMap.keys.first
        : TextConstants.emptyString;
    state.itemDealerCategoryDetailId = null;
    state.itemQuantity = 0;
    state.itemTotal = 0;
    state.itemPrice = 0;
    state.isItemTotalCalculatedByUnitPrice = false;
    state.scrapCategoryDetails = [];
  }

  _recalculateTotalAndBonusAmount() {
    var total = 0;
    state.items.forEach((item) {
      total += item.isCalculatedByUnitPrice ? item.totalCalculated : item.total;
    });
    // Set value
    state.total = total;
  }
}
