import 'package:flutter/material.dart';

class AvatarBuilder extends StatelessWidget {
  final String imgUrl;
  final double radius;
  final bool isOnline;
  AvatarBuilder({
    @required this.imgUrl,
    this.radius = 20.0,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        CircleAvatar(
          maxRadius: radius,
          backgroundImage: AssetImage('assets/images/man.png'),
        ),
        if (isOnline)
          Positioned(
            left: -6.0,
            top: 0.0,
            bottom: 0.0,
            child: _activeStatusBuilder(),
          ),
      ],
    );
  }

  Widget _activeStatusBuilder() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            maxRadius: 6.0,
            backgroundColor: Color(0xffF3F5F8),
          ),
          Positioned.fill(
            child: Center(
              child: CircleAvatar(
                maxRadius: 4.0,
                backgroundColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
