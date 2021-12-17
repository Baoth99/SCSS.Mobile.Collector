import 'package:collector_app/blocs/models/scrap_category_detail_model.dart';
import 'package:collector_app/blocs/models/scrap_category_model.dart';
import 'package:collector_app/constants/text_constants.dart';
import 'package:collector_app/providers/networks/models/request/create_category_request_model.dart';
import 'package:collector_app/providers/networks/models/request/update_category_request_model.dart';
import 'package:collector_app/providers/networks/scrap_category_network.dart';
import 'package:collector_app/utils/common_utils.dart';

abstract class IScrapCategoryService {
  Future<String> uploadImage({
    required String imagePath,
  });
  Future<bool> checkScrapName({
    required String name,
  });
  Future<bool> createScrapCategory(
      {required CreateScrapCategoryRequestModel model});
  Future<List<ScrapCategoryModel>> getScrapCategories({
    int? page,
    int? pageSize,
  });
  Future<bool> updateScrapCategory(
      {required UpdateScrapCategoryRequestModel model});
  Future<ScrapCategoryDetailModel> getScrapCategoryDetail({
    required String id,
  });
  Future<bool> deleteScrapCategory({required String id});
}

class ScrapCategoryService implements IScrapCategoryService {
  Future<String> uploadImage({
    required String imagePath,
  }) async {
    try {
      //get access token
      var accessToken = await NetworkUtils.getBearerTokenPure();

      if (accessToken != null) {
        String resData = (await ScrapCategoryNetWork.postImage(
          bearerToken: accessToken,
          imagePath: imagePath,
        ))
            .resData;

        // Return image path on server
        return resData;
      } else
        throw Exception(TextConstants.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> checkScrapName({
    required String name,
  }) async {
    try {
      //get access token
      var accessToken = await NetworkUtils.getBearerTokenPure();
      if (accessToken != null) {
        var responseBody = await ScrapCategoryNetWork.getCheckScrapName(
          bearerToken: accessToken,
          name: name,
        );

        return responseBody['isSuccess'];
      } else
        throw Exception(TextConstants.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> createScrapCategory(
      {required CreateScrapCategoryRequestModel model}) async {
    try {
      //get access token
      var accessToken = await NetworkUtils.getBearerTokenPure();
      if (accessToken != null) {
        var responseBody = await ScrapCategoryNetWork.postScrapCategory(
          bearerToken: accessToken,
          body: createScrapCategoryRequestModelToJson(model),
        );

        return responseBody['isSuccess'];
      } else
        throw Exception(TextConstants.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> updateScrapCategory(
      {required UpdateScrapCategoryRequestModel model}) async {
    try {
      var accessToken = await NetworkUtils.getBearerTokenPure();
      if (accessToken != null) {
        var responseBody = await ScrapCategoryNetWork.putScrapCategory(
          bearerToken: accessToken,
          body: updateScrapCategoryRequestModelToJson(model),
        );

        return responseBody['isSuccess'];
      } else
        throw Exception(TextConstants.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<List<ScrapCategoryModel>> getScrapCategories({
    int? page,
    int? pageSize,
  }) async {
    try {
      //get access token
      var accessToken = await NetworkUtils.getBearerTokenPure();
      if (accessToken != null) {
        var scrapCategories = (await ScrapCategoryNetWork.getScrapCategories(
          bearerToken: accessToken,
          page: page?.toString(),
          pageSize: pageSize?.toString(),
        ))
            .scrapCategoryModels;

        //get scrap categories
        return scrapCategories;
      } else
        throw Exception(TextConstants.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<ScrapCategoryDetailModel> getScrapCategoryDetail({
    required String id,
  }) async {
    try {
      //get access token
      var accessToken = await NetworkUtils.getBearerTokenPure();
      if (accessToken != null) {
        var scrapCategoryDetailModel =
            (await ScrapCategoryNetWork.getScrapCategoryDetail(
          bearerToken: accessToken,
          id: id,
        ))
                .resData;

        //get scrap categories
        return scrapCategoryDetailModel;
      } else
        throw Exception(TextConstants.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> deleteScrapCategory({required String id}) async {
    try {
      var accessToken = await NetworkUtils.getBearerTokenPure();
      if (accessToken != null) {
        var responseBody = await ScrapCategoryNetWork.deleteScrapCategory(
          bearerToken: accessToken,
          id: id,
        );

        return responseBody['isSuccess'];
      } else
        throw Exception(TextConstants.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }
}
