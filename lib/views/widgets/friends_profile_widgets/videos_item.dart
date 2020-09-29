import 'package:flutter/material.dart';

class VideoItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage('assets/images/sample.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
