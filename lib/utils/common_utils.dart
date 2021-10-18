import 'dart:io';

import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/exceptions/custom_exceptions.dart';
import 'package:collector_app/providers/networks/models/response/base_response_model.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static String concatString(List<String> strs,
      [String seperator = Symbols.space]) {
    return strs.join(seperator);
  }
}

class NetworkUtils {
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
        responseModel.isSuccess != null &&
        responseModel.isSuccess!) return responseModel;

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
