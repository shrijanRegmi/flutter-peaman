import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/viewmodels/chat_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/search_screen.dart';
import 'package:peaman/views/widgets/chat_list_tab_widgets/other_users_list.dart';
import 'package:peaman/views/widgets/chat_list_tab_widgets/pinned_users_list.dart';

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
                    _topSectionBuilder(context),
                    vm.chats.isEmpty
                        ? _emptyChat(context)
                        : Column(
                            children: <Widget>[
                              PinnedUsersList(
                                chats: vm.pinnedChats,
                                appUser: vm.appUser,
                              ),
                              if (vm.pinnedChats.isNotEmpty)
                                SizedBox(
                                  height: 20.0,
                                ),
                              OtherUsersList(
                                chats: vm.otherChats,
                                appUser: vm.appUser,
                              ),
                            ],
                          ),
                  ],
                ),
              );
      },
    );
  }

  Widget _topSectionBuilder(BuildContext context) {
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
            ],
          ),
          // searchbar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(),
                ),
              );
            },
            child: SvgPicture.asset('assets/images/svgs/search_icon.svg'),
          ),
        ],
      ),
    );
  }

  Widget _emptyChat(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Lottie.asset(
          'assets/lottie/chat_empty.json',
          width: MediaQuery.of(context).size.width - 100.0,
          height: MediaQuery.of(context).size.width - 100.0,
        ),
        Text(
          "It's very quite in here",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Color(0xff3D4A5A)),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Tap the "search" icon in top right corner to search a user and start chatting',
            style: TextStyle(
              fontSize: 14.0,
              color: Color(0xff3D4A5A),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
