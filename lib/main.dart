// import 'dart:math';

// import 'package:jsend/api_request.dart';
import 'package:jsend/jsend.dart';
// import 'package:jsend/remote_resource.dart';

void main() async {
  APIRequest.base = 'http://localhost:5000/api/dalle/';
  var resource = RemoteResource('addons');
  // var all = await resource.getAll(
  //     // statusHandlers: [JsendStatusHandler(
  //     //   forSuccess: (_) {
  //     //     print('Successfully fetched.');
  //     //   },
  //     //   forError: (_) {
  //     //     print('Error Fetching.');
  //     //   },
  //     // ),]
  //     );

  // print(all);
  //
  var jr = jsendResponse.fromAPIRequest(
    APIRequest(path: 'quantities'),
    // onError: (jsendResponse r) {
    //   print('1');
    // },
    // onFail: defaultStatusHandler,
    // onSuccess: (_) {
    //   print("qwe");
    // },
    // statusHandlers: [
    //   JsendStatusHandler(forError: (jsr) {
    //     print('2');
    //   }, forSuccess: (_) {
    //     print("asd");
    //   })
    // ],
  );

  // var rand = Random();

  // var payload = {
  //   'name': 'Addon ' + rand.nextInt(200).toString(),
  // };

  // await resource.createItem(payload);

  // print(await resource.getAll());

  // print('last');
}
