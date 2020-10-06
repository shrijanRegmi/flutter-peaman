import 'package:flutter/material.dart';

class WriteCaption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _addPhotosTextBuilder(),
          SizedBox(
            height: 10.0,
          ),
          _textAreaBuilder(),
        ],
      ),
    );
  }

  Widget _addPhotosTextBuilder() {
    return Text(
      'Write Caption',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      ),
    );
  }

  Widget _textAreaBuilder() {
    return Container(
      height: 300.0,
      child: TextFormField(
        maxLines: 5,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.1,
            ),
          ),
          hintText: 'Type a caption...',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            )
          )
        ),
      ),
    );
  }
}
