import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feeds_list.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/moments_list.dart';

class ExploreTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MomentsList(),
            Divider(
              color: Color(0xff3D4A5A).withOpacity(0.2),
            ),
            FeedsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff3D4A5A),
        onPressed: () {},
        child: Icon(Icons.create),
      ),
    );
  }
}
