import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed.dart';
import 'package:peaman/views/screens/friends_feed_viewer_screen.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/posts_list_item.dart';

class PostsList extends StatelessWidget {
  final List<Feed> feeds;
  PostsList(this.feeds);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _postsTextBuilder(),
        SizedBox(
          height: 10.0,
        ),
        _postsGridBuilder(),
      ],
    );
  }

  Widget _postsTextBuilder() {
    return Row(
      children: [
        Text(
          'Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Color(0xff3D4A5A),
          ),
        ),
      ],
    );
  }

  Widget _postsGridBuilder() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FriendsFeedViewerScreen(feeds),
                ),
              );
            },
            child: PhotosItem(feeds[index].photos[0]));
      },
    );
  }
}
