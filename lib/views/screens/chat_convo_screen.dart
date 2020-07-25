import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/chat_convo_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/chat_convo_widgets/chat_compose_area.dart';
import 'package:peaman/views/widgets/chat_convo_widgets/chat_convo_list.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';

class ChatConvoScreen extends StatelessWidget {
  final AppUser friend;
  ChatConvoScreen({this.friend});

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
                title: Text(
                  friend.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Color(0xff3D4A5A),
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: ChatComposeArea(
            sendMessage: vm.sendMessage,
            appUser: vm.appUser,
            friend: friend,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: SafeArea(
            child: Container(
              color: Color(0xffF3F5F8),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ChatConvoList(
                        friend: friend,
                        appUser: vm.appUser,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
