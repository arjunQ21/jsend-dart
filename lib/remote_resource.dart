import 'api_request.dart';
import 'jsend.dart';

class RemoteResource {
  final String endpoint;

  RemoteResource(this.endpoint);

  List<Map> _allFromServer = [];

  bool _loadedAll = false;

  bool _hasLoadedID(String id) {
    return (_allFromServer
        .map((e) {
          return e['_id'];
        })
        .toList()
        .contains(id));
  }

  List<Map> get allFromServer => _allFromServer;

  Future<List<Map>> getAll({bool force = false}) async {
    var req = APIRequest(
      path: endpoint,
    );
    if (force) _loadedAll = false;
    if (!_loadedAll) {
      var resp = await req.send();
      var jsendResp = jsendResponse(resp);
      if (jsendResp.status == 'success') {
        _allFromServer = jsendResp.data;
      } else if (jsendResp.status == 'fail') {
        print('Error with input data: ');
        print(jsendResp.message);
      } else {
        print('Error Processing requset.');
        print(jsendResp.message);
      }
    }
    return _allFromServer;
  }

  Future<Map> get(String id) async {
    if (!_hasLoadedID(id)) {
      var jsendResp = await jsendResponse.fromAPIRequest(APIRequest(
        path: endpoint + '/' + id,
      ));
    }
    return _allFromServer[0];
  }
}
