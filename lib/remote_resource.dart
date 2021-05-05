import 'api_request.dart';
import 'jsend.dart';

class RemoteResource {
  final String endpoint;

  late String singularName;

  List _allFromServer = [];

  List get allFromServer => _allFromServer;

  bool _loadedAll = false;

  RemoteResource(this.endpoint, {String? singularName}) {
    this.singularName =
        singularName ?? endpoint.substring(0, endpoint.length - 1);
  }

  bool _hasLoadedID(String id) {
    return (_allFromServer
        .map((e) {
          return e['_id'];
        })
        .toList()
        .contains(id));
  }

  Map<String, dynamic>? _getLoadedItemByID(String id) {
    if (!_hasLoadedID(id)) return null;
    var items =
        _allFromServer.where((element) => (element['_id'] == id)).toList();
    if (items.length == 1) return items[0];
    throw Exception('Item not found or multiple items found by given id.');
  }

  Map<String, dynamic> _getSingluarDataFromJsendResponse(jsendResponse res) {
    if (res.data.containsKey(singularName)) {
      return (res.data[singularName]);
    } else {
      return (res.data);
    }
  }

  void _setItem(Map<String, dynamic> singleItem) {
    if (!singleItem.containsKey('_id')) {
      throw Exception('_id not found in given input item.');
    }
    if (_hasLoadedID(singleItem['_id'])) {
      var updated = false;
      for (var oldItem in _allFromServer) {
        if (updated) break;
        if (oldItem['_id'] == singleItem['_id']) {
          _allFromServer[_allFromServer.indexOf(oldItem)] = singleItem;
          updated = true;
        }
      }
      if (!updated) throw Exception('Item not updated.');
    } else {
      _allFromServer.add(singleItem);
    }
  }

  Future<List> getAll(
      {bool force = false, List<JsendStatusHandler>? statusHandlers}) async {
    if (force) _loadedAll = false;
    if (!_loadedAll) {
      (await jsendResponse.fromAPIRequest(
          APIRequest(
            path: endpoint,
          ), onSuccess: (jsendResponse resp) {
        if (resp.data is List) {
          _allFromServer = resp.data;
        } else {
          if (!resp.data.containsKey(endpoint)) {
            throw Exception(
                'Malformed JSON Structure obtained from server. Didnt find key "data.' +
                    endpoint +
                    '" in response.');
          }
          _allFromServer = resp.data[endpoint];
        }
      }, statusHandlers: statusHandlers));
      _loadedAll = true;
    }
    return _allFromServer;
  }

  Future<Map<String, dynamic>?> get(String id,
      {bool force = false, List<JsendStatusHandler>? statusHandlers}) async {
    var hasLoadedCopy = _hasLoadedID(id);
    if (force) hasLoadedCopy = false;
    if (!hasLoadedCopy) {
      (await jsendResponse.fromAPIRequest(
        APIRequest(path: endpoint + '/' + id),
        onSuccess: (jsendResponse res) {
          _setItem(_getSingluarDataFromJsendResponse(res));
        },
        statusHandlers: statusHandlers,
      ));
    }
    return _getLoadedItemByID(id);
  }

  Future<void> createItem(Map<String, dynamic> itemDetails,
      {List<JsendStatusHandler>? statusHandlers}) async {
    (await jsendResponse.fromAPIRequest(
      APIRequest(
        path: endpoint,
        payload: itemDetails,
        method: 'POST',
      ),
      onSuccess: (jsendResponse res) {
        _setItem(_getSingluarDataFromJsendResponse(res));
      },
      statusHandlers: statusHandlers,
    ));
  }

  Future<void> updateItem(Map<String, dynamic> updatedItem, {List<JsendStatusHandler>? statusHandlers}) async {
    if (!updatedItem.containsKey('_id')) {
      throw Exception('_id not found in given input item.');
    }

    (await jsendResponse.fromAPIRequest(
      APIRequest(
        path: endpoint + '/' + updatedItem['_id'],
        method: 'PUT',
        payload: updatedItem,
      ),
      onSuccess: (jsendResponse res) {
        _setItem(_getSingluarDataFromJsendResponse(res));
      },
      statusHandlers: statusHandlers,
    ));
  }

  Future<void> deleteItem(Map<String, dynamic> itemToDelete,{List<JsendStatusHandler>? statusHandlers}) async {
    if (!itemToDelete.containsKey('_id')) {
      throw Exception('_id not found in given input item.');
    }
    (await jsendResponse.fromAPIRequest(
      APIRequest(
        path: endpoint + '/' + itemToDelete['_id'],
        method: 'DELETE',
      ),
      onSuccess: (jsendResponse res) {
        if (_loadedAll) {
          _allFromServer.remove(_getLoadedItemByID(itemToDelete['_id']));
        }
      },
      statusHandlers: statusHandlers
    ));
  }
}
