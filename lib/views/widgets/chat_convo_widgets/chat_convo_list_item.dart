import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/message_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatConvoListItem extends StatelessWidget {
  final Message message;
  final AppUser friend;
  final Alignment alignment;
  ChatConvoListItem({this.friend, this.alignment, this.message});

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
          _userBuilder(),
        ],
      ),
    );
  }

  Widget _messageBuilder() {
    return Row(
      mainAxisAlignment: alignment == Alignment.centerRight
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Align(
            alignment: alignment,
            child: Container(
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
                    bottomLeft: Radius.circular(
                        alignment == Alignment.centerLeft ? 0.0 : 15.0),
                  )),
              padding: const EdgeInsets.all(20.0),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0xff3D4A5A),
                  height: 1.8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _userBuilder() {
    return alignment == Alignment.centerLeft
        ? Row(
            children: <Widget>[
              AvatarBuilder(
                imgUrl: friend.photoUrl_60x60,
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
                    friend.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Color(0xff3D4A5A),
                    ),
                  ),
                  Text(
                    _getTime(message.milliseconds),
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.black26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
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
                    _getTime(message.milliseconds),
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
                imgUrl: friend.photoUrl_60x60,
                isOnline: false,
                radius: 17.0,
              ),
            ],
          );
  }

  String _getTime(final int milliseconds) {
    return timeago
        .format(
          DateTime.fromMillisecondsSinceEpoch(message.milliseconds),
        )
        .replaceAll('ago', '')
        .replaceAll('minutes', 'm')
        .replaceAll('hours', 'h')
        .replaceAll('days', 'd')
        .replaceAll('months', 'mon')
        .replaceAll('a day', '1 d')
        .replaceAll('a minute', '1 m')
        .replaceAll('about an hour', '1 h')
        .replaceAll('a moment', 'Just now');
  }
}
