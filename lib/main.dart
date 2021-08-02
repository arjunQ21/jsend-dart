import 'package:jsend/jsend.dart';

void main() async {
  APIRequest.base = 'http://localhost:5000/api/dalle/';
  APIRequest.addDefaultHeaders({'AC': 'asdf'});
}
