import 'package:flutter/material.dart';
import 'package:peaman/views/widges/chat_convo_widgets/chat_compose_area.dart';
import 'package:peaman/views/widges/chat_convo_widgets/chat_convo_list.dart';
import 'package:peaman/views/widges/common_widgets/appbar.dart';

class ChatConvoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F5F8),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: SafeArea(
          child: CommonAppbar(
            title: Text(
              'Robert Richards',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Color(0xff3D4A5A),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: ChatComposeArea(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Container(
          color: Color(0xffF3F5F8),
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ChatConvoList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
