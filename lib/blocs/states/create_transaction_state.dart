import 'package:collector_app/blocs/models/create_transaction_detail_model.dart';
import 'package:collector_app/blocs/models/scrap_category_model.dart';
import 'package:collector_app/blocs/models/scrap_category_unit_model.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/constants/text_constants.dart';

enum CreateTransactionProcess {
  neutral,
  processing,
  processed,
  valid,
  invalid,
  error,
}

class CreateTransactionState {
  String? collectorId;
  String collectorPhone;
  String? collectorName;
  int total;
  double transactionFeePercent;

  List<SellCollectTransactionDetailModel> items;

  CreateTransactionProcess process;
  bool isModalBottomSheetShowed;
  bool isItemsUpdated;
  bool isCollectorPhoneExist;
  bool isQRScanned;

  //item data
  bool isNewItem;
  int? key;
  String itemDealerCategoryId;
  String? itemDealerCategoryDetailId;
  int itemTotal;
  double itemQuantity;
  int itemPrice;
  bool isItemTotalCalculatedByUnitPrice;
  List<ScrapCategoryUnitModel> scrapCategoryDetails;

  //data
  List<ScrapCategoryModel> scrapCategories;
  Map<String, String>
      scrapCategoryMap; //map contains unique categories <id, name> for dropdown list
  // List<CollectorPhoneModel> collectorPhoneList;

  int get itemTotalCalculated {
    if (isItemTotalCalculatedByUnitPrice && itemPrice != 0)
      return (itemPrice * itemQuantity).truncate();
    else
      return 0;
  }

  int get initialUnitPrice {
    if (scrapCategoryDetails.isNotEmpty &&
        itemDealerCategoryDetailId != TextConstants.emptyString) {
      return scrapCategoryDetails
          .firstWhere((element) => element.id == itemDealerCategoryDetailId)
          .price;
    }
    return itemPrice;
  }

  int get transactionFee {
    return (transactionFeePercent * total).truncate();
  }

  int get grandTotal {
    return total - transactionFee;
  }

  //validators
  bool get isScrapCategoryValid {
    if (itemDealerCategoryId == TextConstants.emptyString ||
        (isItemTotalCalculatedByUnitPrice &&
            itemDealerCategoryId == TextConstants.zeroId)) {
      return false;
    } else
      return true;
  }

  bool get isScrapCategoryUnitValid {
    if (isItemTotalCalculatedByUnitPrice) {
      if (itemDealerCategoryDetailId == TextConstants.emptyString ||
          itemDealerCategoryDetailId == null) {
        return false;
      } else
        return true;
    } else
      return true;
  }

  bool get isItemQuantityValid {
    if (isItemTotalCalculatedByUnitPrice) {
      if (itemQuantity <= 0) {
        return false;
      } else
        return true;
    } else
      return true;
  }

  bool get isItemPriceValid {
    if (isItemTotalCalculatedByUnitPrice) {
      if (itemPrice < 0) {
        return false;
      } else
        return true;
    } else
      return true;
  }

  bool get isItemTotalSmallerThanZero {
    if (isItemTotalCalculatedByUnitPrice) {
      if (itemTotalCalculated <= 0) {
        return false;
      } else
        return true;
    } else {
      if (itemTotal <= 0) {
        return false;
      } else
        return true;
    }
  }

  bool get isItemTotalUnderLimit {
    if (isItemTotalCalculatedByUnitPrice) {
      if (itemTotalCalculated >= CreateTransactionConstants.totalLimit) {
        return false;
      } else
        return true;
    } else {
      if (itemTotal >= CreateTransactionConstants.totalLimit) {
        return false;
      } else
        return true;
    }
  }

  bool get isPhoneValid =>
      RegExp(CustomRegexs.phoneRegex).hasMatch(collectorPhone);

  CreateTransactionState({
    String? collectorId,
    String? collectorPhone,
    String? collectorName,
    int? total,
    double? transactionFeePercent,
    List<SellCollectTransactionDetailModel>? items,
    CreateTransactionProcess? process,
    bool? isModalBottomSheetShowed,
    bool? isItemsUpdated,
    bool? isCollectorPhoneExist,
    bool? isQRScanned,
    //New item
    bool? isNewItem,
    int? key,
    String? itemDealerCategoryId,
    String? itemDealerCategoryDetailId,
    double? itemQuantity,
    String? itemPromotionId,
    int? itemBonusAmount,
    int? itemTotal,
    int? itemPrice,
    bool? isItemTotalCalculatedByUnitPrice,
    List<ScrapCategoryUnitModel>? scrapCategoryDetails,
    bool? isPromotionApplied,
    //Data
    List<ScrapCategoryModel>? scrapCategories,
    Map<String, String>? scrapCategoryMap,
    // List<CollectorPhoneModel>? collectorPhoneList,
  })  : collectorId = collectorId,
        collectorPhone = collectorPhone ?? '',
        collectorName = collectorName,
        total = total ?? 0,
        transactionFeePercent = transactionFeePercent ?? 0,
        items = items ?? [],
        process = process ?? CreateTransactionProcess.neutral,
        isModalBottomSheetShowed = isModalBottomSheetShowed ?? false,
        isItemsUpdated = isItemsUpdated ?? false,
        isCollectorPhoneExist = isCollectorPhoneExist ?? false,
        isQRScanned = isQRScanned ?? false,
        //New item
        isNewItem = isNewItem ?? true,
        key = key,
        itemDealerCategoryId = itemDealerCategoryId ?? TextConstants.zeroId,
        itemDealerCategoryDetailId = itemDealerCategoryDetailId,
        itemQuantity = itemQuantity ?? 0,
        itemTotal = itemTotal ?? 0,
        itemPrice = itemPrice ?? 0,
        isItemTotalCalculatedByUnitPrice =
            isItemTotalCalculatedByUnitPrice ?? false,
        scrapCategoryDetails = scrapCategoryDetails ?? [],
        //Data
        scrapCategories = scrapCategories ?? [],
        scrapCategoryMap = scrapCategoryMap ?? {};
  // collectorPhoneList = collectorPhoneList ?? [];

  CreateTransactionState copyWith({
    String? collectorId,
    String? collectorPhone,
    String? collectorName,
    int? total,
    double? transactionFeePercent,
    List<SellCollectTransactionDetailModel>? items,
    CreateTransactionProcess? process,
    bool? isItemDialogShowed,
    bool? isItemsUpdated,
    bool? isCollectorPhoneExist,
    bool? isQRScanned,
    //New item
    bool? isNewItem,
    int? key,
    String? itemDealerCategoryId,
    String? itemDealerCategoryDetailId,
    double? itemQuantity,
    String? itemPromotionId,
    int? itemBonusAmount,
    int? itemTotal,
    int? itemPrice,
    bool? isItemTotalCalculatedByUnitPrice,
    List<ScrapCategoryUnitModel>? scrapCategoryDetails,
    bool? isPromotionApplied,
    //Data
    List<ScrapCategoryModel>? scrapCategories,
    Map<String, String>? scrapCategoryMap,
    // List<CollectorPhoneModel>? collectorPhoneList,
  }) {
    return CreateTransactionState(
      collectorId: collectorId ?? this.collectorId,
      collectorPhone: collectorPhone ?? this.collectorPhone,
      collectorName: collectorName ?? this.collectorName,
      total: total ?? this.total,
      transactionFeePercent:
          transactionFeePercent ?? this.transactionFeePercent,
      items: items ?? this.items,
      process: process ?? this.process,
      isModalBottomSheetShowed:
          isItemDialogShowed ?? this.isModalBottomSheetShowed,
      isItemsUpdated: isItemsUpdated ?? this.isItemsUpdated,
      isCollectorPhoneExist:
          isCollectorPhoneExist ?? this.isCollectorPhoneExist,
      isQRScanned: isQRScanned ?? this.isQRScanned,
      //New item
      isNewItem: isNewItem ?? this.isNewItem,
      key: key ?? this.key,
      itemDealerCategoryId: itemDealerCategoryId ?? this.itemDealerCategoryId,
      itemDealerCategoryDetailId:
          itemDealerCategoryDetailId ?? this.itemDealerCategoryDetailId,
      itemQuantity: itemQuantity ?? this.itemQuantity,
      itemTotal: itemTotal ?? this.itemTotal,
      itemPrice: itemPrice ?? this.itemPrice,
      isItemTotalCalculatedByUnitPrice: isItemTotalCalculatedByUnitPrice ??
          this.isItemTotalCalculatedByUnitPrice,
      scrapCategoryDetails: scrapCategoryDetails ?? this.scrapCategoryDetails,
      //Data
      scrapCategories: scrapCategories ?? this.scrapCategories,
      scrapCategoryMap: scrapCategoryMap ?? this.scrapCategoryMap,
      // collectorPhoneList: collectorPhoneList ?? this.collectorPhoneList,
    );
  }

  CreateTransactionState clearCollector(
      {String? collectorPhone, bool? isQRScanned}) {
    return CreateTransactionState(
      collectorId: null,
      collectorPhone: collectorPhone ?? this.collectorPhone,
      collectorName: null,
      total: this.total,
      transactionFeePercent: null,
      items: this.items,
      process: this.process,
      isModalBottomSheetShowed: this.isModalBottomSheetShowed,
      isItemsUpdated: this.isItemsUpdated,
      isCollectorPhoneExist: false,
      isQRScanned: isQRScanned ?? this.isQRScanned,
      //New item
      isNewItem: this.isNewItem,
      key: this.key,
      itemDealerCategoryId: this.itemDealerCategoryId,
      itemDealerCategoryDetailId: this.itemDealerCategoryDetailId,
      itemQuantity: this.itemQuantity,
      itemTotal: this.itemTotal,
      itemPrice: this.itemPrice,
      isItemTotalCalculatedByUnitPrice: this.isItemTotalCalculatedByUnitPrice,
      scrapCategoryDetails: this.scrapCategoryDetails,
      //data
      scrapCategories: this.scrapCategories,
      scrapCategoryMap: this.scrapCategoryMap,
      // collectorPhoneList: this.collectorPhoneList,
    );
  }
}
