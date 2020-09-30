import 'package:flutter/material.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';

class MomentsListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                maxRadius: 31.0,
                backgroundColor: Colors.pink,
              ),
              Positioned.fill(
                child: Center(
                  child: AvatarBuilder(
                    imgUrl: '',
                    radius: 28.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Shrijan Regmi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
              color: Color(0xff3D4A5A),
            ),
          ),
        ],
      ),
    );
  }
}
