import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/enums/message_types.dart';
import 'package:peaman/models/app_models/message_model.dart';
import 'package:peaman/models/app_models/temporary_img_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/storage_services/chat_storage_service.dart';
import 'package:peaman/viewmodels/temp_img_vm.dart';
import 'package:peaman/views/screens/call_screen.dart';
import 'package:peaman/views/widgets/common_widgets/single_icon_btn.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatComposeArea extends StatefulWidget {
  final String chatId;
  final AppUser appUser;
  final AppUser friend;
  final Function sendMessage;
  final Function(bool newIsTypingVal) updateIsTyping;
  final bool isTypingActive;
  final FocusNode focusNode;
  final GlobalKey<ScaffoldState> scaffoldKey;
  ChatComposeArea({
    this.chatId,
    this.sendMessage,
    this.appUser,
    this.friend,
    this.updateIsTyping,
    this.focusNode,
    this.isTypingActive = false,
    this.scaffoldKey,
  });
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
              radius: 50.0,
              icon: 'assets/images/svgs/send_image_btn.svg',
              onPressed: () async {
                final _chatConvoVmProvider =
                    Provider.of<TempImgVm>(context, listen: false);

                final _pickedImg = await ImagePicker().getImage(
                  source: ImageSource.gallery,
                  maxWidth: 640.0,
                  maxHeight: 640.0,
                );

                final _imgFile =
                    _pickedImg != null ? File(_pickedImg.path) : null;

                final _message = TextMessage(
                  senderId: widget.appUser.uid,
                  receiverId: widget.friend.uid,
                  milliseconds: DateTime.now().millisecondsSinceEpoch,
                  type: MessageType.Image,
                );

                if (_imgFile != null) {
                  final _tempImg = TempImage(
                    chatId: widget.chatId,
                    imgFile: _imgFile,
                  );

                  _chatConvoVmProvider.addItemToTempImagesList(_tempImg);
                  await ChatStorage(
                    chatId: widget.chatId,
                    message: _message,
                    sendMsgCallback: widget.sendMessage,
                  ).uploadChatImage(imgFile: _imgFile);

                  _chatConvoVmProvider.removeItemToTempImagesList(_tempImg);
                }
              },
            ),
            SizedBox(
              width: 20.0,
            ),
            SingleIconBtn(
              radius: 80.0,
              icon: 'assets/images/svgs/send_btn.svg',
              onPressed: () {
                widget.updateIsTyping(true);
                widget.focusNode.requestFocus();
              },
            ),
            SizedBox(
              width: 20.0,
            ),
            SingleIconBtn(
              radius: 50.0,
              icon: 'assets/images/svgs/call_btn.svg',
              onPressed: () async {
                // await _handleCameraAndMic();
                // await Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => CallScreen(
                //               channelName: 'shirjan',
                //               role: ClientRole.Broadcaster,
                //             )));

                widget.scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text('This feature is being developed')));
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
                    final _message = TextMessage(
                      text: _text,
                      senderId: widget.appUser.uid,
                      receiverId: widget.friend.uid,
                      milliseconds: DateTime.now().millisecondsSinceEpoch,
                      type: MessageType.Text,
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
          Padding(
            padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add_circle_outline,
                  color: Color(0xff3D4A5A),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Icon(
                  Icons.tag_faces,
                  color: Color(0xff3D4A5A),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    await [Permission.camera, Permission.microphone].request();
  }
}
