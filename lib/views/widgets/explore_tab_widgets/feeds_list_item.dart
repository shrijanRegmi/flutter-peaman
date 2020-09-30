import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peaman/views/screens/friend_profile_screen.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feed_img_carousel.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/people_who_reacted.dart';

class FeedsListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        right: 10.0,
        left: 10.0,
        bottom: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerBuilder(context),
          SizedBox(
            height: 10.0,
          ),
          FeedImageCarousel(),
          SizedBox(
            height: 15.0,
          ),
          _actionButtonBuilder(),
          SizedBox(
            height: 15.0,
          ),
          PeopleWhoReacted(3),
          SizedBox(
            height: 10.0,
          ),
          _descriptionBuilder(),
        ],
      ),
    );
  }

  Widget _headerBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FriendProfileScreen(),
              ),
            );
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                AvatarBuilder(
                  imgUrl: '',
                  radius: 20.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shrijan Regmi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Color(0xff3D4A5A),
                      ),
                    ),
                    Text(
                      '30th Aug, 2020',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Icon(
          Icons.more_vert,
          color: Color(0xff3D4A5A),
        )
      ],
    );
  }

  Widget _actionButtonBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  color: Colors.transparent,
                  child: SvgPicture.asset(
                    'assets/images/svgs/heart_blank.svg',
                    width: 27.0,
                    height: 27.0,
                    color: Color(0xff3D4A5A),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  color: Colors.transparent,
                  child: SvgPicture.asset(
                    'assets/images/svgs/comment.svg',
                    width: 27.0,
                    height: 27.0,
                    color: Color(0xff3D4A5A),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              color: Colors.transparent,
              child: SvgPicture.asset(
                'assets/images/svgs/bookmark_blank.svg',
                width: 24.0,
                height: 24.0,
                color: Color(0xff3D4A5A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionBuilder() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          // fontWeight: FontWeight.bold,
          fontFamily: 'Nunito',
          fontSize: 12.0,
          color: Colors.black45,
        ),
        children: [
          TextSpan(
            text: 'Shrijan Regmi ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff3D4A5A),
            ),
          ),
          TextSpan(
            text:
                'The world is taking action on COVID-19. With Greta Thunberg, these young people are calling for urgent climate action too.',
          ),
        ],
      ),
    );
  }
}
