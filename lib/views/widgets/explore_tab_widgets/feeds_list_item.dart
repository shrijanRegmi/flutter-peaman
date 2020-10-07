import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/feed.dart';
import 'package:peaman/views/screens/friend_profile_screen.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feed_img_carousel.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/people_who_reacted.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedsListItem extends StatelessWidget {
  final Feed feed;
  FeedsListItem(this.feed);

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
          FeedImageCarousel(feed.photos),
          SizedBox(
            height: 15.0,
          ),
          _actionButtonBuilder(),
          SizedBox(
            height: 15.0,
          ),
          PeopleWhoReacted(feed),
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
                  imgUrl: feed.owner.photoUrl,
                  isOnline: feed.owner.onlineStatus == OnlineStatus.active,
                  radius: 20.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feed.owner.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Color(0xff3D4A5A),
                      ),
                    ),
                    Text(
                      timeago.format(
                          DateTime.fromMillisecondsSinceEpoch(feed.updatedAt)),
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
            text: '${feed.owner.name} ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff3D4A5A),
            ),
          ),
          TextSpan(
            text: '${feed.caption}',
          ),
        ],
      ),
    );
  }
}