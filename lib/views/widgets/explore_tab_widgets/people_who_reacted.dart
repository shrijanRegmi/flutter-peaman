import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/feed.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';

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
          child: AvatarBuilder(
            imgUrl: feed.reactorsPhoto[i],
            radius: 12.0,
          ),
        ),
      );
    }
    return _list;
  }
}
