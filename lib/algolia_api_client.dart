import 'package:http/http.dart' as http;
import 'dart:convert';

class AlgoliaAPIClient extends http.BaseClient {

  final String appID;
  final String apiKey;
  final http.Client _inner;

  AlgoliaAPIClient(this.appID, this.apiKey, this._inner);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['content-type'] = "application/json";
    request.headers['X-Algolia-API-Key'] = apiKey;
    request.headers['X-Algolia-Application-Id'] = appID;
    print(request);
    print(request.headers);
    return _inner.send(request);
  }

  Future<Map<dynamic, dynamic>> search(String query) async {
    final request = http.Request("post", Uri.https('$appID-dsn.algolia.net', '1/indexes/STAGING_native_ecom_demo_products/query'));
    request.body = '{"params": "query=$query"}';
    final streamedResponse = await send(request);
    final response = await http.Response.fromStream(streamedResponse);
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  }
}
