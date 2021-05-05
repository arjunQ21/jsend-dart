import 'package:jsend/jsend.dart';

void main() async {
  APIRequest.base = 'http://localhost:5000/api/dalle/';
  var remote = RemoteResource('addons');
  try {
    await remote.createItem({
      'id': 'nullass'
    }, statusHandlers: [
      JsendStatusHandler(
        forSuccess: (jsendResponse resp) async {
          print('New addon Added');
        },
        forError: (_) {
          print('Error12345');
        },
        forFail: (_) {
          print("fail");
        },
      ),
      // ... statusHandlers ?? []
    ]);
  } catch (e, trace) {
    print('1212sdasdf' + trace.toString());
  }
}
