import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService extends GetxService {
  String apiHost = '127.0.0.1:8000';
  bool useHttps = false;

  Uri _constructUri(String path,
      {Map<String, dynamic> queryParams = const {}}) {
    if (useHttps) {
      return Uri.https(apiHost, path, queryParams);
    }
    return Uri.http(apiHost, path, queryParams);
  }

  _get(String method, {Map<String, dynamic> queryParams = const {}}) async {
    final response = await http.get(
      _constructUri(method, queryParams: queryParams),
    );

    if (response.statusCode >= 400) {
      throw "http ${response.statusCode}: ${response.reasonPhrase}";
    }

    return jsonDecode(response.body);
  }

  getMenus() async {
    return await _get("main/menus");
  }

  doRequest(Map<String, dynamic> params) async {
    return await _get(
      "main/request",
      queryParams: params,
    );
  }
}
