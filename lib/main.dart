import 'api_request.dart';
import 'jsend.dart';

void main() async {
  APIRequest.base = 'http://localhost:5000/api/ads/';
  var apiRequest = APIRequest(
    // path: 'auth/register',
    url: 'http://localhost:5000/api/ads/auth/register',
    payload: {'name': 'Arjun', 'email': 'arju@gmail.com'},
    method: 'POST',
  );

  //testing apirequest pending

  var httpResponse = await apiRequest.send();
  var jsonResp = jsendResponse(httpResponse);
  print(httpResponse.body);
  print(jsonResp);
}
