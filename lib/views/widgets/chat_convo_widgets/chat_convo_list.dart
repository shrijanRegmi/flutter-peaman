import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/helpers/chat_helper.dart';
import 'package:peaman/models/app_models/message_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/message_provider.dart';
import 'package:peaman/views/widgets/chat_convo_widgets/chat_convo_list_item.dart';

class ChatConvoList extends StatelessWidget {
  final AppUser appUser;
  final AppUser friend;
  final bool isTypingActive;
  ChatConvoList({this.friend, this.appUser, this.isTypingActive});

  @override
  Widget build(BuildContext context) {
    final _chatId =
        ChatHelper().getChatId(myId: appUser.uid, friendId: friend.uid);

    return StreamBuilder<List<Message>>(
        stream: MessageProvider(chatId: _chatId).messagesList,
        builder: (context, AsyncSnapshot<List<Message>> messagesSnap) {
          if (messagesSnap.hasData) {
            return ListView.builder(
              itemCount: messagesSnap.data.length,
              physics: BouncingScrollPhysics(),
              reverse: true,
              itemBuilder: (context, index) {
                if (messagesSnap.data[index].senderId == appUser.uid) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: isTypingActive ? 20.0 : 120.0),
                      child: ChatConvoListItem(
                        chatId: _chatId,
                        message: messagesSnap.data[index],
                        friend: appUser,
                        alignment: Alignment.centerRight,
                        isLast: true,
                      ),
                    );
                  }
                  return ChatConvoListItem(
                    chatId: _chatId,
                    message: messagesSnap.data[index],
                    friend: appUser,
                    alignment: Alignment.centerRight,
                  );
                } else {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: isTypingActive ? 20.0 : 120.0),
                      child: ChatConvoListItem(
                        chatId: _chatId,
                        message: messagesSnap.data[index],
                        friend: friend,
                        alignment: Alignment.centerLeft,
                        isLast: true,
                      ),
                    );
                  }
                  return ChatConvoListItem(
                    chatId: _chatId,
                    message: messagesSnap.data[index],
                    friend: friend,
                    alignment: Alignment.centerLeft,
                  );
                }
              },
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 120.0),
            child: Lottie.asset(
              'assets/lottie/chat_loader.json',
              width: MediaQuery.of(context).size.width - 200.0,
              height: MediaQuery.of(context).size.width - 200.0,
            ),
          );
        });
  }
}
