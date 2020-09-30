import 'package:flutter/material.dart';

class FriendStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _itemBuilder(365, 'Photos'),
        _itemBuilder(860, 'Followers'),
        _itemBuilder(748, 'Following'),
      ],
    );
  }

  Widget _itemBuilder(final int _count, final String _title) {
    return Column(
      children: [
        Text(
          '$_count',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Color(0xff3D4A5A),
          ),
        ),
        Text(
          '$_title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
