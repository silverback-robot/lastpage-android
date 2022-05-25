import 'package:flutter/material.dart';
import 'package:lastpage/models/search_users/search_users_response.dart';
import 'package:lastpage/widgets/groups/add_new_member/user_search_result.dart';
import 'package:lastpage/models/search_users.dart';
import 'package:provider/provider.dart';

class UserSearchBar extends StatefulWidget {
  const UserSearchBar({Key? key}) : super(key: key);

  @override
  State<UserSearchBar> createState() => _UserSearchBarState();
}

class _UserSearchBarState extends State<UserSearchBar> {
  late TextEditingController controller;
  OverlayEntry? entry;
  List<SearchUsersResponse> results = [];
  var link = LayerLink();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showOverlay();
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void showOverlay() {
    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: buildOverlay(),
        ),
      ),
    );

    overlay.insert(entry!);
  }

  Widget buildOverlay() {
    return ListView(
      shrinkWrap: true,
      children: results.isNotEmpty
          ? results
              .map((e) => UserSearchResult(
                    key: UniqueKey(),
                    result: e,
                    onTapCallback: () {
                      focusNode.unfocus();
                      hideOverlay();
                    },
                  ))
              .toList()
          : [],
    );
  }

  void hideOverlay() {
    print("Hiding overlay...");
    entry?.remove();
    entry = null;
    print(entry);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        enabled: true,
        keyboardType: TextInputType.name,
        enableSuggestions: true,
        onChanged: (query) async {
          print(results.length);
          if (query.length > 2) {
            results = await Provider.of<SearchUsers>(context, listen: false)
                .searchUsers(query);
          } else {
            results.clear();
          }
        },
      ),
    );
  }
}
