import 'package:flutter/cupertino.dart';
import 'package:typesense/typesense.dart';

class SearchUsers extends ChangeNotifier {
  late Client _client;

  SearchUsers() {
    _client = _setupClient();
  }

  Client _setupClient() {
    final _config = Configuration(
      "iuR8nNgdpSp7uCojAlQXzymnh0FYGdmLjdKhS8yaRCvk23OR",
      nodes: {
        Node.withUri(
          Uri.parse(
            "https://iamharish.dev",
          ),
        )
      },
      numRetries: 4,
      connectionTimeout: const Duration(seconds: 2),
    );

    final _client = Client(_config);
    return _client;
  }

  searchUsers(String searchQuery) async {
    final searchParameters = {
      'q': searchQuery.toString(),
      'query_by': 'name, email, phone'
    };

    var searchResultJson = await _client
        .collection('lastpag-poc-users')
        .documents
        .search(searchParameters);

    print(searchResultJson.keys.toString());
  }
}
