import 'package:collector_app/blocs/models/collector_phone_model.dart';
import 'package:collector_app/blocs/models/scrap_category_model.dart';
import 'package:collector_app/blocs/models/scrap_category_unit_model.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/text_constants.dart';
import 'package:collector_app/providers/networks/data_network.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:flutter/material.dart';

abstract class IDataService {
  Future<List<ScrapCategoryModel>?> getScrapCategoryList();
  Future<List<ScrapCategoryUnitModel>?> getScrapCategoryDetailList(
      {required String scrapCategoryId});
  Future<List<CollectorPhoneModel>?> getCollectorPhoneList();
  Future<ImageProvider> getImageBytes({required String imageUrl});
}

class DataService implements IDataService {
  Future<List<ScrapCategoryModel>?> getScrapCategoryList() async {
    try {
      //get access token
      var accessToken = await NetworkUtils.getBearerTokenPure();
      if (accessToken != null) {
        var scrapCategories = (await DataNetWork.getScrapCategories(
          bearerToken: accessToken,
        ))
            .scrapCategoryModels;
        if (scrapCategories != null) {
          scrapCategories.sort((cat1, cat2) => cat1.name.compareTo(cat2.name));
          //insert to first position
          scrapCategories.insert(0, CommonApiConstants.unnamedScrapCategory);
        }
        //get scrap categories
        return scrapCategories;
      } else
        throw Exception(TextConstants.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<List<ScrapCategoryUnitModel>?> getScrapCategoryDetailList(
      {required String scrapCategoryId}) async {
    try {
      //get access token
      var accessToken = await NetworkUtils.getBearerTokenPure();
      if (accessToken != null) {
        var scrapCategoryDetails = (await DataNetWork.getScrapCategoryDetails(
          bearerToken: accessToken,
          scrapCategoryId: scrapCategoryId,
        ))
            .scrapCategoryDetailModels;
        if (scrapCategoryDetails != null) {
          scrapCategoryDetails
              .sort((cat1, cat2) => cat1.unit.compareTo(cat2.unit));
        }
        //get scrap category details
        return scrapCategoryDetails;
      } else
        throw Exception(TextConstants.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<List<CollectorPhoneModel>?> getCollectorPhoneList() async {
    try {
      //get access token
      var accessToken = await NetworkUtils.getBearerTokenPure();
      if (accessToken != null) {
        var collectorPhones = (await DataNetWork.getCollectorPhones(
          bearerToken: accessToken,
        ))
            .collectorPhoneModels;
        //get collector phones
        return collectorPhones;
      } else
        throw Exception(TextConstants.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<ImageProvider> getImageBytes({required String imageUrl}) async {
    try {
      //get access token
      var accessToken = await NetworkUtils.getBearerTokenPure();

      if (accessToken != null) {
        var image = MemoryImage(await DataNetWork.getImageBytes(
          bearerToken: accessToken,
          imageUrl: imageUrl,
        ));
        return image;
      } else
        throw Exception(TextConstants.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }
}
