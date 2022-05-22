import 'package:flutter/cupertino.dart';
import 'package:lastpage/models/search_users/search_users_response.dart';
import 'package:typesense/typesense.dart';

class SearchUsers extends ChangeNotifier {
  late Client _client;
  List<SearchUsersResponse> _results = [];
  List<SearchUsersResponse> get results => _results;

  SearchUsers() {
    _client = _setupClient();
  }

  Client _setupClient() {
    final _config = Configuration(
      "iuR8nNgdpSp7uCojAlQXzymnh0FYGdmLjdKhS8yaRCvk23OR",
      nodes: {
        Node.withUri(
          Uri.parse(
            'https://iamharish.dev',
          ),
        )
      },
      numRetries: 4,
      connectionTimeout: const Duration(seconds: 2),
    );

    final _client = Client(_config);
    return _client;
  }

  Future<List<SearchUsersResponse>> searchUsers(String searchQuery) async {
    final searchParameters = {
      'q': searchQuery.toString(),
      'query_by': 'name, email, phone'
    };

    var searchResultJson = await _client
        .collection('lastpage-poc-users3')
        .documents
        .search(searchParameters);

    int noResponses = searchResultJson["found"] as int;
    List responseBody = searchResultJson["hits"];

    if (noResponses > 0) {
      _results.clear();
      _results = responseBody
          .map((resp) => SearchUsersResponse.fromJson(resp["document"]))
          .toList();
    }
    notifyListeners();
    print("Successfully parsed ${_results.length} search results!");
    return _results;
  }
}
