import 'package:flutter/material.dart';

class PhotosItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage('assets/images/sample.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
