import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/chat_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/widgets/chat_list_tab_widgets/chat_list_item.dart';

class OtherUsersList extends StatelessWidget {
  final List<Chat> chats;
  final AppUser appUser;
  OtherUsersList({this.chats, this.appUser});
  
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
        "Other",
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
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return ChatListItem(appUser: appUser, chat: chats[index]);
      },
    );
  }
}
