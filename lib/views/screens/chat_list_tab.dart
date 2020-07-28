import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/viewmodels/chat_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/chat_list_tab_widgets/other_users_list.dart';

class ChatListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider(
      vm: ChatVm(context: context),
      builder: (BuildContext context, ChatVm vm) {
        return vm.chats == null
            ? Center(
                child: Lottie.asset(
                  'assets/lottie/loader.json',
                  width: MediaQuery.of(context).size.width - 100.0,
                  height: MediaQuery.of(context).size.width - 100.0,
                ),
              )
            : Container(
                color: Color(0xffF3F5F8),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    _topSectionBuilder(),
                    // PinnedUsersList(),
                    // SizedBox(
                    //   height: 20.0,
                    // ),
                    OtherUsersList(
                      chats: vm.chats,
                      appUser: vm.appUser,
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _topSectionBuilder() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
              // messages text
              Text(
                'Messages',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Color(0xff3D4A5A)),
              ),
              SizedBox(
                width: 10.0,
              ),
              // dropdown
              Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xff3D4A5A),
              ),
            ],
          ),
          // searchbar
          SvgPicture.asset('assets/images/svgs/search_icon.svg'),
        ],
      ),
    );
  }
}
