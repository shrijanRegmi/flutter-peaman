import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/friend_profile_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/scroll_appbar.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/friend_btns.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/friends_status.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/photos.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/videos.dart';

class FriendProfileScreen extends StatelessWidget {
  final AppUser user;
  FriendProfileScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<FriendProfileVm>(
      vm: FriendProfileVm(),
      onInit: (vm) => vm.onInit(user),
      builder: (context, vm, appVm, appUser) {
        // bool _isAppUser = user == appUser;
        bool _isAppUser = false;
        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          body: SafeArea(
            child: vm.isLoading
                ? Center(
                    child: Lottie.asset(
                      'assets/lottie/loader.json',
                      width: MediaQuery.of(context).size.width - 100.0,
                      height: MediaQuery.of(context).size.width - 100.0,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_isAppUser)
                          SizedBox(
                            height: 20.0,
                          ),
                        if (!_isAppUser) ScrollAppbar(),
                        _userDetailBuilder(context),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!_isAppUser) FriendBtns(),
                              SizedBox(
                                height: !_isAppUser ? 40.0 : 30.0,
                              ),
                              FriendStatus(user),
                              SizedBox(
                                height: 50.0,
                              ),
                              Photos(vm.feeds),
                              SizedBox(
                                height: 50.0,
                              ),
                              Videos(),
                              SizedBox(
                                height: 100.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _userDetailBuilder(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 0.50;
    return Column(
      children: <Widget>[
        Container(
          width: _width,
          height: _width,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 10.0,
            ),
            boxShadow: [
              BoxShadow(
                  offset: Offset(2.0, 10.0),
                  blurRadius: 20.0,
                  color: Colors.black12)
            ],
            image: DecorationImage(
              image: CachedNetworkImageProvider(user.photoUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          '${user.name}',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Color(0xff3D4A5A)),
        ),
        Text(
          '${user.profileStatus}',
          style: TextStyle(
            fontSize: 14.0,
            color: Color(0xff3D4A5A),
          ),
        ),
      ],
    );
  }
}
