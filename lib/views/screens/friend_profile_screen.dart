import 'package:flutter/material.dart';
import 'package:peaman/views/widgets/common_widgets/scroll_appbar.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/friend_btns.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/friends_status.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/photos.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/videos.dart';

class FriendProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ScrollAppbar(),
              _userDetailBuilder(context),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FriendBtns(),
                    SizedBox(
                      height: 40.0,
                    ),
                    FriendStatus(),
                    SizedBox(
                      height: 50.0,
                    ),
                    Photos(),
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
              image: AssetImage('assets/images/man.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Antonio Petez',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Color(0xff3D4A5A)),
        ),
        Text(
          'I am a person with good heart',
          style: TextStyle(
            fontSize: 14.0,
            color: Color(0xff3D4A5A),
          ),
        ),
      ],
    );
  }
}
