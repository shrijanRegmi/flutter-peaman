import 'package:flutter/material.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/chat_convo_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/chat_convo_widgets/chat_compose_area.dart';
import 'package:peaman/views/widgets/chat_convo_widgets/chat_convo_list.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';

class ChatConvoScreen extends StatelessWidget {
  final AppUser friend;
  ChatConvoScreen({this.friend});

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider(
      vm: ChatConvoVm(
        context: context,
      ),
      builder: (BuildContext context, ChatConvoVm vm) {
        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: SafeArea(
              child: CommonAppbar(
                title: Row(
                  children: <Widget>[
                    Text(
                      friend.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color(0xff3D4A5A),
                      ),
                    ),
                    if (friend.onlineStatus == OnlineStatus.active)
                      SizedBox(
                        width: 10.0,
                      ),
                    if (friend.onlineStatus == OnlineStatus.active)
                      CircleAvatar(
                        maxRadius: 4.0,
                        backgroundColor: Colors.pink,
                      )
                  ],
                ),
              ),
            ),
          ),
          bottomSheet: vm.isTyping
              ? ChatComposeArea(
                  sendMessage: vm.sendMessage,
                  appUser: vm.appUser,
                  friend: friend,
                  updateIsTyping: vm.updateTypingValue,
                  isTypingActive: vm.isTyping,
                  focusNode: _focusNode,
                )
              : null,
          floatingActionButton: !vm.isTyping
              ? ChatComposeArea(
                  sendMessage: vm.sendMessage,
                  appUser: vm.appUser,
                  friend: friend,
                  updateIsTyping: vm.updateTypingValue,
                  isTypingActive: vm.isTyping,
                  focusNode: _focusNode,
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                _focusNode.unfocus();
              },
              child: Container(
                color: Color(0xffF3F5F8),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ChatConvoList(
                          isTypingActive: vm.isTyping,
                          friend: friend,
                          appUser: vm.appUser,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
