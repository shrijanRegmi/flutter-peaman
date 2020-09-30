import 'package:flutter/material.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';

class PeopleWhoReacted extends StatelessWidget {
  final int users;
  PeopleWhoReacted(this.users);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.0,
      child: Row(
        children: [
          Container(
            width: 60.0,
            child: Stack(
              children: _getChildren(),
            ),
          ),
          Expanded(
            child: Text(
              'Ram Bahadur and 24 others',
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
    for (int i = 0; i < users; i++) {
      final _pos = i * 14;
      _list.add(
        Positioned(
          left: _pos.toDouble(),
          child: AvatarBuilder(
            imgUrl: '',
            radius: 12.0,
          ),
        ),
      );
    }
    return _list;
  }
}
