import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../utils/app_helper/app_strings.dart';
import '../app_exceptions/app_exception.dart';
import 'base_api_service.dart';

class NetworkApiServices extends BaseApiServices {
  
  @override
  Future getAPI(String url) async {
    http.Response res;
    try {
      res = await http.get(Uri.parse(url));
      return returnResponse(res);
    } on SocketException {
      throw InternetException(AppStrings.noNetwork);
    } on RequestTimeOut {
      throw RequestTimeOut(AppStrings.takingMoreTime);
    }
  }

  @override
  Future postAPI(String url, dynamic data)async {
     http.Response res;
    try {
      res = await http.post(Uri.parse(url), body: jsonEncode(data));
      return returnResponse(res);
    } on SocketException {
      throw InternetException(AppStrings.noNetwork);
    } on RequestTimeOut {
      throw RequestTimeOut(AppStrings.takingMoreTime);
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw InvalidUrl(AppStrings.invalidUrl);
      default:
        throw FetchDataException(AppStrings.unableToFetchData);
    }
  }
}
