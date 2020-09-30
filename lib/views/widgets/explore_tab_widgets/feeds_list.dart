import 'package:flutter/material.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feeds_list_item.dart';

class FeedsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return FeedsListItem();
      },
    );
  }
}
