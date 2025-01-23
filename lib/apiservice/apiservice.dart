import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

class URLS {
  static const String baseUrl =
      // 'http://portal.prospectatech.com/erp3.1webservices/v1';
      'http://192.168.235.191:3001/api';
}

class Headers {
  static const Map<String, String> headers = {
    "Content-type": "application/json",
    "Authorization": "b8416f2680eb194d61b33f9909f94b9d"
  };
}

class ApiService {
  static Future getToken(body, url) async {
    try {
      final response = await http.post(Uri.parse('${URLS.baseUrl}/$url'),
          headers: Headers.headers,
          encoding: Encoding.getByName('utf-8'),
          body: body);
      log('${URLS.baseUrl}/$url');
      log(response.statusCode.toString());
      return response;
    } catch (e) {
      return e;
    }
  }

  static Future post(url, body,) async {
    try {
      final response = await http.post(Uri.parse('${URLS.baseUrl}/$url'),
          headers: Headers.headers,
          body: body);
      log(HttpHeaders.requestHeaders.toString());
      log('${URLS.baseUrl}/$url');
      log(response.statusCode.toString());
      return response;
    } catch (e) {
      return e;
    }
  }

  static Future get(url) async {
    try {
      final response = await http.get(
        Uri.parse('${URLS.baseUrl}/$url'),
        headers: Headers.headers,
        // headers: {
        //   "Content-type": "application/json",
        //   "Authorization": "Bearer " + token
        // }
      );
      log(HttpHeaders.requestHeaders.toString());
      log('${URLS.baseUrl}/$url');
      log(response.statusCode.toString());
      return response;
    } catch (e) {
      return e;
    }
  }
}
