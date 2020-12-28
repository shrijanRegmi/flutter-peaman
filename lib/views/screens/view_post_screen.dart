import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/viewmodels/feed_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/friend_profile_screen.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feed_comments_list.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feed_img_carousel.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/people_who_reacted.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewFeedScreen extends StatelessWidget {
  final String title;
  final Feed feed;
  ViewFeedScreen(this.title, this.feed);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<FeedVm>(
      vm: FeedVm(context: context),
      onInit: (vm) => vm.onInit(feed),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                '$title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                right: 10.0,
                left: 10.0,
                bottom: 40.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerBuilder(context, appUser, vm, appVm),
                  SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                    onDoubleTap: () => vm.reactPost(appUser),
                    child: FeedImageCarousel(feed.photos),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _actionButtonBuilder(context, appUser, vm),
                  SizedBox(
                    height: 15.0,
                  ),
                  PeopleWhoReacted(vm.thisFeed),
                  if (vm.thisFeed.caption != '')
                    SizedBox(
                      height: 10.0,
                    ),
                  if (vm.thisFeed.caption != '') _descriptionBuilder(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _headerBuilder(
      BuildContext context, AppUser appUser, FeedVm vm, AppVm appVm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FriendProfileScreen(feed.owner),
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
        if (feed.ownerId == appUser.uid)
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Color(0xff3D4A5A),
            ),
            itemBuilder: (context) {
              return <PopupMenuItem>[
                PopupMenuItem(
                  value: 0,
                  child: Text('Delete'),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                vm.deleteMyFeed(feed, appVm, appUser);
              }
            },
          )
      ],
    );
  }

  Widget _actionButtonBuilder(
      final BuildContext context, final AppUser appUser, final FeedVm vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => vm.unReactPost(appUser),
                child: Container(
                  color: Colors.transparent,
                  child: SvgPicture.asset(
                    vm.thisFeed.isReacted
                        ? 'assets/images/svgs/heart_filled.svg'
                        : 'assets/images/svgs/heart_blank.svg',
                    width: 27.0,
                    height: 27.0,
                    color:
                        vm.thisFeed.isReacted ? Colors.pink : Color(0xff3D4A5A),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FeedCommentScreen(feed),
                    ),
                  );
                },
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
