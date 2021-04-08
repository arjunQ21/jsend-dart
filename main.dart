import 'api_request.dart';
import 'jsend.dart';

void main() async {
  var apiRequest = APIRequest(
    'auth/register',
    payload: {'name': 'Arjun'},
    method: 'POST',
  );

  var httpResponse = await apiRequest.send();
  var jsonResp = jsendResponse(httpResponse);
  print(httpResponse.body);
  print(jsonResp);
}
