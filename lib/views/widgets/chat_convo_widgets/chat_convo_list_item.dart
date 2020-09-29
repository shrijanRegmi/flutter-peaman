import 'package:flutter/material.dart';
import 'package:peaman/views/screens/friend_profile_screen.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';

class ChatConvoListItem extends StatelessWidget {
  final Alignment alignment;
  ChatConvoListItem({this.alignment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _messageBuilder(),
          SizedBox(
            height: 15.0,
          ),
          _userBuilder(context),
        ],
      ),
    );
  }

  Widget _messageBuilder() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xfff5f5f5),
          boxShadow: [
            BoxShadow(
              blurRadius: 10.0,
              color: Colors.black26,
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
            bottomRight: Radius.circular(
                alignment == Alignment.centerRight ? 0.0 : 15.0),
            bottomLeft:
                Radius.circular(alignment == Alignment.centerLeft ? 0.0 : 15.0),
          )),
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Text(
          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et',
          style: TextStyle(
            fontSize: 12.0,
            color: Color(0xff3D4A5A),
            height: 1.8,
          ),
        ),
      ),
    );
  }

  Widget _userBuilder(BuildContext context) {
    return alignment == Alignment.centerLeft
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FriendProfileScreen(),
                ),
              );
            },
            child: Row(
              children: <Widget>[
                AvatarBuilder(
                  imgUrl: '',
                  isOnline: false,
                  radius: 17.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Robert Richards',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Color(0xff3D4A5A),
                      ),
                    ),
                    Text(
                      '20m',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Me',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Color(0xff3D4A5A),
                    ),
                  ),
                  Text(
                    '20m',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.black26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10.0,
              ),
              AvatarBuilder(
                imgUrl: '',
                isOnline: false,
                radius: 17.0,
              ),
            ],
          );
  }
}
