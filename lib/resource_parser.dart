import 'remote_resource.dart';

abstract class ResourceParser {
  RemoteResource fromJson(dynamic payload) ;
}
