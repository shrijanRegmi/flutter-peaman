import 'package:flutter/material.dart';
import 'package:peaman/views/widges/chat_list_tab_widgets/chat_list_item.dart';

class PinnedUsersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // pinned text
        _pinnedTextBuilder(),
        // list of users
        _usersListBuilder(),
      ],
    );
  }

  Widget _pinnedTextBuilder() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        "Pinned",
        style: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _usersListBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return ChatListItem();
      },
    );
  }
}
