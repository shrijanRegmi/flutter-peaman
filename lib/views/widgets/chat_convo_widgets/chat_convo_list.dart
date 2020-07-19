import 'package:flutter/material.dart';
import 'package:peaman/views/widges/chat_convo_widgets/chat_convo_list_item.dart';

class ChatConvoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      physics: BouncingScrollPhysics(),
      reverse: true,
      itemBuilder: (context, index) {
        if (index.isEven) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 120.0),
              child: ChatConvoListItem(
                alignment: Alignment.centerRight,
              ),
            );
          }
          return ChatConvoListItem(
            alignment: Alignment.centerRight,
          );
        }

        return ChatConvoListItem(
          alignment: Alignment.centerLeft,
        );
      },
    );
  }
}
