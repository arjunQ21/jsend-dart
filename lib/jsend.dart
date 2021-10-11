import 'package:http/http.dart' as http;
import 'dart:convert';
import './api_request.dart';

// Exporting from this file import

export './api_request.dart';
export './remote_resource.dart';

typedef jsendStatusHandler = void Function(jsendResponse response);

final jsendStatusHandler defaultStatusHandler = (jsendResponse response) {
  print(response);
};

class JsendStatusHandler {
  jsendStatusHandler? forError, forSuccess, forFail;
  JsendStatusHandler({this.forError, this.forFail, this.forSuccess});
}

class jsendResponse {
  late http.Response _httpResponse;

  List<JsendStatusHandler> statusHandlers = [];

  jsendStatusHandler? onError = defaultStatusHandler;
  jsendStatusHandler? onFail = defaultStatusHandler;
  jsendStatusHandler? onSuccess = defaultStatusHandler;

  late Map<String, dynamic> payload;

  jsendResponse.fromPayload(
    this.payload, {
    this.onError,
    this.onFail,
    this.onSuccess,
    List<JsendStatusHandler>? statusHandlers,
  }) {
    if (statusHandlers != null) this.statusHandlers = statusHandlers;
    _callHandlers();
  }

  jsendResponse(http.Response response,
      {this.onError,
      this.onFail,
      this.onSuccess,
      List<JsendStatusHandler>? statusHandlers}) {
    _httpResponse = response;
    if (statusHandlers != null) this.statusHandlers = statusHandlers;
    parse();
    _callHandlers();
  }

  void _callHandlers() {
    var calledOneHanlder = false;

    var allOnHanlders = {
      'error': onError,
      'success': onSuccess,
      'fail': onFail
    };
    allOnHanlders.forEach((key, hanlder) {
      if (allOnHanlders[key] != null) {
        if (status == key) {
          print("calling handler with key '$status'");
          calledOneHanlder = true;
          allOnHanlders[key]!(this);
        }
      }
    });

    // calling hanlders from statusHanlders list

    statusHandlers.forEach((statusHandler) {
      var config = {
        'error': statusHandler.forError,
        'success': statusHandler.forSuccess,
        'fail': statusHandler.forFail
      };
      config.forEach((key, handler) {
        if (status == key) {
          if (handler != null) {
            calledOneHanlder = true;
            handler(this);
          }
        }
      });
    });

    // print('Called 1 hanlder: ' + calledOneHanlder.toString());
    if (!calledOneHanlder) {
      // print('calling default handler');
      defaultStatusHandler(this);
    }
  }

  static Future<jsendResponse> fromAPIRequest(
    APIRequest request, {
    jsendStatusHandler? onError,
    jsendStatusHandler? onFail,
    jsendStatusHandler? onSuccess,
    List<JsendStatusHandler>? statusHandlers,
  }) async {
    try {
      var httpResponse = await request.send();
      return jsendResponse(httpResponse,
          onError: onError,
          onFail: onFail,
          onSuccess: onSuccess,
          statusHandlers: statusHandlers);
    } catch (e, trace) {
      print(e);
      print(trace);
      print('Connection Error');
      var r = jsendResponse.fromPayload({
        'status': 'error',
        'message': 'HTTP Error: ' + e.toString(),
        'data': {}
      },
          onError: onError,
          onFail: onFail,
          onSuccess: onSuccess,
          statusHandlers: statusHandlers);
      return r;
    }
  }

  http.Response get httpResponse {
    return _httpResponse;
  }

  String get status {
    if (getKey('status') != null) return getKey('status');
    // print('Invalid Jsend');
    print(this);
    throw Exception("Invalid Jsend. Key 'status' not found.");
    // return 'undefined';
  }

  dynamic get data {
    return getKey('data') ?? {};
  }

  @override
  String toString() {
    return payload.toString();
  }

  String? get message {
    // return getKey('message') ?? data.message ?? data ?? data.error ?? data;
    print('hi');
    if (getKey('message') != null) return getKey('message');
    if (data.containsKey('message')) return data['message'].toString();
    if (data.containsKey('error')) return data['error'].toString();
    return data.toString();
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
          e.toString());
    }
  }

  void parse() {
    try {
      payload = jsonDecode(_httpResponse.body);
    } on FormatException catch (_, e) {
      // Generating Custom Error on some error
      payload = {
        'status': 'error',
        'message': 'The response is not JSON. Server\'s Response: \n' +
            _httpResponse.body +
            'original error: ' +
            e.toString()
      };
    } catch (e) {
      payload = {
        'status': 'error',
        'message': 'Error Occurred: ' +
            _httpResponse.body +
            'original error: ' +
            e.toString()
      };
    }
  }

  bool hasErrorIn(String key) {
    if (status != 'fail') return false;
    if (data == null) return false;
    if (data is Map) {
      return data.containsKey(key);
    } else {
      return false;
    }
  }

  String? errorIn(String key) {
    if (!hasErrorIn(key)) return null;
    return data[key];
  }
}
