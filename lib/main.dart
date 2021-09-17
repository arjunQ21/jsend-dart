import 'package:jsend/jsend.dart';

void main() async {
  APIRequest.base = 'http://localhost:3000/api/dalle/';
  APIRequest.addDefaultHeaders({'AC': 'asdf'});
}
