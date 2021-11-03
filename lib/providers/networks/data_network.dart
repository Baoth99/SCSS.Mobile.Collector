import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/utils/env_util.dart';
import 'package:http/http.dart' as http;

import 'models/response/category_response_model.dart';
import 'models/response/category_unit_response_model.dart';
import 'models/response/collector_phone_response_model.dart';

class DataNetWork {
  static Future<ScrapCategoryResponseModel> getScrapCategories(
      {required String bearerToken}) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    final uri = Uri.http(EnvBaseAppSettingValue.baseApiUrlWithoutHttp,
        APIServiceURI.apiUrlGetScrapCategoriesFromData);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ScrapCategoryResponseModel.fromJsonToCreateTransactionModel(
          jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CommonApiConstants.getScrapCategoriesFailedException);
    }
  }

  static Future<ScrapCategoryUnitResponseModel> getScrapCategoryDetails({
    required String bearerToken,
    required String scrapCategoryId,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    Map<String, String> queryParams = {
      'id': scrapCategoryId,
    };

    final uri = Uri.http(EnvBaseAppSettingValue.baseApiUrlWithoutHttp,
        APIServiceURI.apiUrlGetScrapCategoryDetails, queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ScrapCategoryUnitResponseModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          CommonApiConstants.getScrapCategoryDetailsFailedException);
    }
  }

  static Future<CollectorPhoneResponseModel> getCollectorPhones({
    required String bearerToken,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };

    final uri = Uri.http(EnvBaseAppSettingValue.baseApiUrlWithoutHttp,
        APIServiceURI.apiUrlGetCollectorPhones);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return CollectorPhoneResponseModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CommonApiConstants.getCollectorPhonesFailedException);
    }
  }

  static Future<Uint8List> getImageBytes({
    required String bearerToken,
    required String imageUrl,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    Map<String, dynamic> queryParams = {
      'imageUrl': imageUrl,
    };

    final uri = Uri.http(EnvBaseAppSettingValue.baseApiUrlWithoutHttp,
        APIServiceURI.apiUrlGetImage, queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.bodyBytes;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CommonApiConstants.getImageFailedException);
    }
  }
}
