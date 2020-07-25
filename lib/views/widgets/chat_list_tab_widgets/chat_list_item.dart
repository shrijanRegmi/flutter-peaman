import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/screens/chat_convo_screen.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';

class ChatListItem extends StatelessWidget {
  final AppUser friend;
  ChatListItem({this.friend});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatConvoScreen(
              friend: friend,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                // user image
                AvatarBuilder(
                  imgUrl: friend?.photoUrl_100x100,
                  radius: 25.0,
                  isOnline: true,
                ),
                SizedBox(
                  width: 20.0,
                ),
                _textBuilder(),
              ],
            ),
            _messageCountBuilder(),
          ],
        ),
      ),
    );
  }

  Widget _textBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // user name
        Text(
          "${friend?.name}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 3.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // user message
            Text(
              "hello tomorrow at 5 o'clock",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black38,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 4.0),
              child: CircleAvatar(
                maxRadius: 2.0,
                backgroundColor: Colors.black12,
              ),
            ),
            // message date
            Text(
              "5m",
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.black26,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _messageCountBuilder() {
    return CircleAvatar(
      backgroundColor: Colors.blue[600],
      maxRadius: 10.0,
      child: Center(
        child: Text(
          '2',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }
}
