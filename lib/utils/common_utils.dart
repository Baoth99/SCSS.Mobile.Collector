import 'dart:convert';
import 'dart:io';

import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/exceptions/custom_exceptions.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/networks/models/response/base_response_model.dart';
import 'package:collector_app/utils/env_util.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SharedPreferenceUtils {
  static Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();

    return await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}

class CommonUtils {
  static void launchTelephone(String phone) async {
    var url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      AppLog.error('Could not launch $url');
    }
  }

  static DateTime? convertDDMMYYYToDateTime(String date) {
    DateTime? result;
    try {
      DateFormat format = DateFormat(Others.ddMMyyyyPattern);
      result = format.parse(date);
    } catch (e) {
      AppLog.error('Exception at convertDDMMYYYToDateTime');
    }
    return result;
  }

  static String concatString(List<String> strs,
      [String seperator = Symbols.space]) {
    return strs.join(seperator);
  }

  static String convertToBase64(String str) {
    return base64Encode(utf8.encode(str));
  }
}

class NetworkUtils {
  static String toStringUrl(String uri, Map<String, dynamic>? queries) {
    var uRI = Uri.parse(uri).replace(queryParameters: queries);
    return uRI.toString();
  }

  static Future<String> getBearer() async {
    return await SharedPreferenceUtils.getString(APIKeyConstants.accessToken) ??
        Symbols.empty;
  }

  static String getBasicAuth() {
    return NetworkConstants.basicAuth.replaceFirst(
      NetworkConstants.data,
      CommonUtils.convertToBase64(
          '${EnvID4AppSettingValue.clientId}:${EnvID4AppSettingValue.clientSeret}'),
    );
  }

  static Future<Response> getNetworkWithBearer({
    required String uri,
    Map<String, String>? headers,
    Map<String, dynamic>? queries,
    required Client client,
  }) async {
    var newHeaders = <String, String>{
      HttpHeaders.authorizationHeader: await getBearerToken(),
    }..addAll(headers ?? {});

    return await getNetwork(
      uri: uri,
      headers: newHeaders,
      client: client,
      queries: queries,
    );
  }

  static Future<Response> getNetwork({
    required String uri,
    Map<String, String>? headers,
    Map<String, dynamic>? queries,
    required Client client,
  }) async {
    var url = Uri.parse(uri).replace(
      queryParameters: queries,
    );

    //create request
    var response = await client.get(
      url,
      headers: headers,
    );

    //add header

    return response;
  }

  static String getUrlWithQueryString(String uri, Map<String, String> queries) {
    // ignore: non_constant_identifier_names
    var URI = Uri.parse(uri);
    URI = URI.replace(queryParameters: queries);
    return URI.toString();
  }

  static Future<Response> putBodyWithBearerAuth({
    required String uri,
    Map<String, String>? headers,
    Object? body,
    required Client client,
  }) async {
    var mainHeader = <String, String>{
      HttpHeaders.authorizationHeader: await getBearerToken(),
    };

    if (headers != null) {
      mainHeader.addAll(headers);
    }

    return await putBody(
      uri: uri,
      headers: mainHeader,
      body: body,
      client: client,
    );
  }

  static Future<String> getBearerToken() async {
    String accessToken =
        await SharedPreferenceUtils.getString(APIKeyConstants.accessToken) ??
            Symbols.empty;
    accessToken = NetworkConstants.bearerPattern
        .replaceFirst(NetworkConstants.data, accessToken);

    return accessToken;
  }

  static Future<Response> putBody({
    required String uri,
    Map<String, String>? headers,
    Object? body,
    required Client client,
  }) async {
    var response = client.put(
      Uri.parse(
        uri,
      ),
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future<Response> postBody({
    required String uri,
    Map<String, String>? headers,
    Object? body,
    required Client client,
  }) async {
    var response = client.post(
      Uri.parse(
        uri,
      ),
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future<T>
      checkSuccessStatusCodeAPIMainResponseModel<T extends BaseResponseModel>(
    Response response,
    T Function(String) convertJson,
  ) async {
    var responseModel = await NetworkUtils.getModelOfResponseMainAPI<T>(
      response,
      convertJson,
    );

    if (responseModel.statusCode == NetworkConstants.ok200 &&
        responseModel.isSuccess) return responseModel;

    //
    throw Exception(
      'Exception from checkSuccessStatusCodeAPIMainResponseModel',
    );
  }

  static Future<T> getModelOfResponseMainAPI<T>(
      Response response, T Function(String) convert) async {
    switch (response.statusCode) {
      case NetworkConstants.ok200:
        T model = convert(response.body);
        return model;
      case NetworkConstants.unauthorized401:
        throw UnauthorizedException();
      default:
        throw Exception(
          'Exception from getModelOfResponseMainAPI',
        );
    }
  }
}
