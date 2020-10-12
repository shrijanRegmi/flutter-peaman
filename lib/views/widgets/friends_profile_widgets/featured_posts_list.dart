import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/featured_posts_list_item.dart';

class FeaturedPostList extends StatelessWidget {
  final List<Feed> feeds;
  FeaturedPostList(this.feeds);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _featuredPostTextBuilder(),
        SizedBox(
          height: 10.0,
        ),
        _featuredPostListBuilder(),
      ],
    );
  }

  Widget _featuredPostTextBuilder() {
    return Row(
      children: [
        Text(
          'Featured Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Color(0xff3D4A5A),
          ),
        ),
      ],
    );
  }

  Widget _featuredPostListBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        return VideoItem(feeds[index].photos[0], feeds[index].photos.length);
      },
    );
  }
}
