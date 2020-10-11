import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feeds_list.dart';

class FriendsFeedViewerScreen extends StatelessWidget {
  final List<Feed> feeds;
  FriendsFeedViewerScreen(this.feeds);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F5F8),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: CommonAppbar(
          title: Text(
            'PostsList',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color(0xff3D4A5A),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(child: FeedsList(feeds)),
      ),
    );
  }
}
