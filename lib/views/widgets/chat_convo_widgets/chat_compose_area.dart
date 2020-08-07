import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peaman/models/app_models/message_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/widgets/common_widgets/single_icon_btn.dart';

class ChatComposeArea extends StatefulWidget {
  final AppUser appUser;
  final AppUser friend;
  final Function sendMessage;
  final Function(bool newIsTypingVal) updateIsTyping;
  final bool isTypingActive;
  final FocusNode focusNode;
  ChatComposeArea(
      {this.sendMessage,
      this.appUser,
      this.friend,
      this.updateIsTyping,
      this.focusNode,
      this.isTypingActive = false});
  @override
  _ChatComposeAreaState createState() => _ChatComposeAreaState();
}

class _ChatComposeAreaState extends State<ChatComposeArea> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return !widget.isTypingActive
        ? _actionButtonBuilder()
        : _typingInputBuilder();
  }

  Widget _actionButtonBuilder() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleIconBtn(
              radius: 80.0,
              icon: 'assets/images/svgs/send_btn.svg',
              onPressed: () {
                widget.updateIsTyping(true);
                widget.focusNode.requestFocus();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _typingInputBuilder() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  focusNode: widget.focusNode,
                  controller: _messageController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type something...',
                    contentPadding: const EdgeInsets.only(
                      left: 20.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                  ),
                  maxLines: 3,
                  minLines: 1,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_messageController.text != '') {
                    final _text = _messageController.text.trim();
                    _messageController.clear();
                    final _message = Message(
                      text: _text,
                      senderId: widget.appUser.uid,
                      receiverId: widget.friend.uid,
                      milliseconds: DateTime.now().millisecondsSinceEpoch,
                    );
                    widget.sendMessage(
                      myId: widget.appUser.uid,
                      friendId: widget.friend.uid,
                      message: _message,
                    );
                  }
                },
                child: ClipOval(
                  child: Container(
                    width: 35.0,
                    height: 35.0,
                    color: Colors.green,
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/svgs/send_btn.svg',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
