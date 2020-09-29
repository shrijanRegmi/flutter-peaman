import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';
import 'package:peaman/views/widgets/common_widgets/single_icon_btn.dart';

class FriendBtns extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MaterialButton(
            color: Color(0xff5C49E0),
            textColor: Colors.white,
            onPressed: () {},
            height: 40.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
            child: Text(
              'Add Friend',
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        SingleIconBtn(
          radius: 40.0,
          icon: 'assets/images/svgs/chat_tab.svg',
          color: Color(0xff5C49E0).withOpacity(0.7),
          onPressed: () {},
        ),
      ],
    );
  }
}
