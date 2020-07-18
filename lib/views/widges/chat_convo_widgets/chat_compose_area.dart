import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peaman/views/widges/common_widgets/single_icon_btn.dart';

class ChatComposeArea extends StatefulWidget {
  @override
  _ChatComposeAreaState createState() => _ChatComposeAreaState();
}

class _ChatComposeAreaState extends State<ChatComposeArea> {
  bool _isTypingActive = false;

  @override
  Widget build(BuildContext context) {
    return !_isTypingActive ? _actionButtonBuilder() : _typingInputBuilder();
  }

  Widget _actionButtonBuilder() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleIconBtn(
              radius: 50.0,
              icon: 'assets/images/svgs/send_image_btn.svg',
              onPressed: () {},
            ),
            SizedBox(
              width: 20.0,
            ),
            SingleIconBtn(
              radius: 80.0,
              icon: 'assets/images/svgs/send_btn.svg',
              onPressed: () {
                setState(() {
                  _isTypingActive = true;
                });
              },
            ),
            SizedBox(
              width: 20.0,
            ),
            SingleIconBtn(
              radius: 50.0,
              icon: 'assets/images/svgs/call_btn.svg',
              onPressed: () {},
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
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type something...',
                    contentPadding: const EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0,),
                  ),
                  maxLines: 3,
                  minLines: 1,
                ),
              ),
              ClipOval(
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
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.add_circle_outline),
                SizedBox(
                  width: 10.0,
                ),
                Icon(Icons.tag_faces),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
