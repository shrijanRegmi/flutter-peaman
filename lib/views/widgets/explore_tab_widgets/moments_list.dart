import 'package:flutter/material.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/moments_list_item.dart';

class MomentsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        _momentTextBuilder(),
        SizedBox(
          height: 10.0,
        ),
        _momentsListBuilder(),
      ],
    );
  }

  Widget _momentTextBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        'Moments',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Color(0xff3D4A5A),
        ),
      ),
    );
  }

  Widget _momentsListBuilder() {
    return Container(
      height: 100.0,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Row(
                children: [
                  _addMomentBuilder(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: MomentsListItem(),
                  ),
                ],
              );
            }
            return MomentsListItem();
          },
        ),
      ),
    );
  }

  Widget _addMomentBuilder() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        children: [
          Container(
            width: 62.0,
            height: 62.0,
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.pink,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'My moment',
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
