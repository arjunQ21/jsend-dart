import 'dart:convert';

import 'package:http/http.dart' as http;

class APIRequest {
  static final _hostName = 'http://localhost:5000/';
  static final _apiRoute = 'api/dalle/';
  static final Map<String, Function> _acceptedMethods = {
    'GET': http.get,
    'POST': http.post,
    'PUT': http.put,
    'DELETE': http.delete
  };
  String _uri;
  String _method;
  Map<String, String> _headers = {};
  Map<String, String> get headers {
    return _headers;
  }

  set headers(Map<String, String> h) {
    _headers.addAll(h);
  }

  Map<String, dynamic> _payload = {};
  static final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json'
  };

  APIRequest(String uri,
      {Map<String, String> headers,
      Map<String, dynamic> payload,
      String method = 'GET'}) {
    _headers = {..._defaultHeaders};
    if (headers != null) {
      _headers = {...headers};
    }
    _uri = (uri[0] == '/') ? uri.substring(1) : uri;
    if (!_acceptedMethods.containsKey(method)) {
      throw Exception("Unsupported method '$method'.");
    }
    _method = method;
    if (payload != null) _payload = payload;
    if (_method == 'GET') _payload = null;
  }
  Future<http.Response> send() {
    var url = _hostName + _apiRoute + _uri;
    switch (_method) {
      case 'GET':
      case 'DELETE':
        return _acceptedMethods[_method](url, headers: _headers);
        break;
      default:
        return _acceptedMethods[_method](url,
            headers: _headers, body: jsonEncode(_payload));
    }
  }
}
