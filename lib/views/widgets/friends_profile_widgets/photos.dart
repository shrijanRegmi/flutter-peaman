import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed.dart';
import 'package:peaman/views/screens/friends_feed_viewer_screen.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/photos_item.dart';

class Photos extends StatelessWidget {
  final List<Feed> feeds;
  Photos(this.feeds);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _photosTextBuilder(),
        SizedBox(
          height: 10.0,
        ),
        _photosGridBuilder(),
      ],
    );
  }

  Widget _photosTextBuilder() {
    return Row(
      children: [
        Text(
          'Photos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Color(0xff3D4A5A),
          ),
        ),
      ],
    );
  }

  Widget _photosGridBuilder() {
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
