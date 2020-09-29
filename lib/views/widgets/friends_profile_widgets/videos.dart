import 'package:flutter/material.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/photos_item.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/videos_item.dart';

class Videos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _videosTextBuilder(),
        SizedBox(
          height: 10.0,
        ),
        _videosListBuilder(),
      ],
    );
  }

  Widget _videosTextBuilder() {
    return Row(
      children: [
        Text(
          'Videos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Color(0xff3D4A5A),
          ),
        ),
      ],
    );
  }

  Widget _videosListBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return VideoItem();
      },
    );
  }
}
