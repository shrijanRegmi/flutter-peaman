import 'package:flutter/material.dart';
import 'package:peaman/views/widgets/friends_profile_widgets/photos_item.dart';

class Photos extends StatelessWidget {
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
      itemCount: 6,
      itemBuilder: (context, index) {
        return PhotosItem();
      },
    );
  }
}
