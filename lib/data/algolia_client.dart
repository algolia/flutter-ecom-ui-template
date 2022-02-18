import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_ecom_demo/model/query.dart';
import 'package:http/http.dart' as http;

/// API client for Algolia.
class AlgoliaAPIClient extends http.BaseClient {
  static final http.Client defaultHttpClient = http.Client();

  final String appID;
  final String apiKey;
  final String indexName;
  final http.Client _client = defaultHttpClient;

  AlgoliaAPIClient(this.appID, this.apiKey, this.indexName);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['content-type'] = "application/json";
    request.headers['X-Algolia-API-Key'] = apiKey;
    request.headers['X-Algolia-Application-Id'] = appID;
    return _client.send(request);
  }

  /// Run a search query and get a response.
  Future<Map<dynamic, dynamic>> search(Query query) async {
    final url = Uri.https('$appID-dsn.algolia.net', '1/indexes/$indexName/query');
    final request = http.Request("post", url);
    request.body = '{"params": "${query.toParams()}"}';
    _log('[Request]: ${request.body}');
    final streamedResponse = await send(request);
    final response = await http.Response.fromStream(streamedResponse);
    _log('[Response]: ${response.body}');
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  }

  void _log(String string) {
    if (kDebugMode) print(string);
  }
}
