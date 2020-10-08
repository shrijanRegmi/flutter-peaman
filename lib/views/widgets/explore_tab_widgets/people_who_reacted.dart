import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed.dart';

class PeopleWhoReacted extends StatelessWidget {
  final Feed feed;
  PeopleWhoReacted(this.feed);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: feed.reactorsPhoto.isNotEmpty && feed.initialReactor != ''
          ? 28.0
          : 0.0,
      child: Row(
        children: [
          if (feed.reactorsPhoto.isNotEmpty)
            Container(
              width: feed.reactorsPhoto.length == 3
                  ? 60.0
                  : feed.reactorsPhoto.length == 2 ? 45.0 : 30.0,
              child: Stack(
                children: _getChildren(),
              ),
            ),
          if (feed.initialReactor != '')
            Expanded(
              child: Text(
                feed.reactionCount == 1 || feed.reactionCount == 0
                    ? '${feed.initialReactor}'
                    : '${feed.initialReactor} and ${feed.reactionCount} others',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _getChildren() {
    List<Widget> _list = [];
    for (int i = 0; i < feed.reactorsPhoto.length; i++) {
      final _pos = i * 14;
      _list.add(
        Positioned(
          left: _pos.toDouble(),
          child: Container(
            width: 27.0,
            height: 27.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xffF3F5F8),
                width: 3.0,
              ),
            ),
            child: Center(
              child: Container(
                width: 27.0,
                height: 27.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      feed.reactorsPhoto[i],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return _list;
  }
}
