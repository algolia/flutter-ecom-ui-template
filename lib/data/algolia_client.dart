import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ecom_demo/domain/query.dart';

/// API client for Algolia.
class AlgoliaAPIClient extends http.BaseClient {
  final String appID;
  final String apiKey;
  final String indexName;
  final http.Client _client = http.Client();

  AlgoliaAPIClient(this.appID, this.apiKey, this.indexName);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['content-type'] = "application/json";
    request.headers['X-Algolia-API-Key'] = apiKey;
    request.headers['X-Algolia-Application-Id'] = appID;
    return _client.send(request);
  }

  /// Run a search query and get a response.
  Future<Map<dynamic, dynamic>> search(Query query) async {
    var url = Uri.https('$appID-dsn.algolia.net', '1/indexes/$indexName/query');
    final request = http.Request("post", url);
    request.body = '{"params": "${query.toParams()}"}';
    log('[Request]: ${request.body}');
    final streamedResponse = await send(request);
    final response = await http.Response.fromStream(streamedResponse);
    log('[Response]: ${response.body}');
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  }

  void log(String string) {
    if (kDebugMode) print(string);
  }
}
