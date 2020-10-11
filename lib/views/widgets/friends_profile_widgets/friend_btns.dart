import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/friend_profile_vm.dart';
import 'package:peaman/views/screens/chat_convo_screen.dart';
import 'package:peaman/views/widgets/common_widgets/single_icon_btn.dart';

class FriendBtns extends StatelessWidget {
  final FriendProfileVm vm;
  final AppUser appUser;
  final AppUser user;
  final bool fromSearch;
  FriendBtns({this.vm, this.appUser, this.user, this.fromSearch});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MaterialButton(
            color: Color(0xff5C49E0),
            textColor: Colors.white,
            onPressed: () {
              if (vm.btnText == 'Follow') {
                vm.followUser(appUser, user);
              } else if (vm.btnText == 'Accept Follow') {
                vm.acceptFollow(appUser, user);
              } else if (vm.btnText == 'Follow Back') {
                vm.followBack(appUser, user);
              } else if (vm.btnText == 'Cancle Follow') {
                vm.cancleFollow(appUser, user);
              }
            },
            height: 40.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
            child: Text(
              '${vm.btnText}',
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        SingleIconBtn(
          radius: 40.0,
          icon: 'assets/images/svgs/chat_tab.svg',
          color: Color(0xff5C49E0).withOpacity(0.7),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatConvoScreen(
                  fromSearch: true,
                  friend: user,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
