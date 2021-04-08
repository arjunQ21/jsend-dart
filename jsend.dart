import 'package:http/http.dart' as http;
import 'dart:convert';

class jsendResponse {
  http.Response _httpResponse;

  Map<String, dynamic> payload;
  jsendResponse(http.Response response) {
    _httpResponse = response;
    parse();
  }
  http.Response get httpResponse {
    return _httpResponse;
  }

  String get status {
    return getKey('status');
  }

  dynamic get data {
    return getKey('data');
  }

  String get message {
    return getKey('message');
  }

  dynamic getKey(String key) {
    if (!payload.containsKey(key)) {
      print("Payload doesnot contain key '$key'.");
      return null;
    }
    try {
      return payload[key];
    } catch (e) {
      throw Exception("Error getting key '" +
          key +
          "' from payload:\n " +
          _httpResponse.body +
          '\nOrignal Error: ' +
          e);
    }
  }

  void parse() {
    try {
      payload = jsonDecode(_httpResponse.body);
    } on FormatException catch (_, e) {
      throw Exception(
          "Response from server is not JSON. Server's Response: \n" +
              _httpResponse.body +
              'original error: ' +
              e.toString());
    }
  }

  bool hasErrorIn(String key) {
    if (data == null) return false;
    if (data is Map) {
      return data.containsKey(key);
    } else {
      return false;
    }
  }

  String errorIn(String key) {
    if (!hasErrorIn(key)) return null;
    return data[key];
  }
}
