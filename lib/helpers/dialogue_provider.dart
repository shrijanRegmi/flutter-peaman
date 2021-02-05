import 'package:flutter/material.dart';

class DialogProvider {
  final BuildContext context;
  DialogProvider(this.context);

  // show this when user taps on add moment button if they already have a story posted
  showLimitedMomentDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20.0,
            ),
            _addMomentBuilder(),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Oops! You can only post one moment until previous has expired.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Got it!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget _addMomentBuilder() {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
      ),
    );
  }
}
