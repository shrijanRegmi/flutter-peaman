import 'package:flutter/material.dart';

class FeedImageCarousel extends StatefulWidget {
  @override
  _FeedImageCarouselState createState() => _FeedImageCarouselState();
}

class _FeedImageCarouselState extends State<FeedImageCarousel> {
  ScrollController _pageViewController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(
      initialPage: 1,
      viewportFraction: 0.8,
    );
  }

  final _images = [
    'sample.jpg',
    'sample2.jpg',
    'sample3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      child: PageView.builder(
        controller: _pageViewController,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: AssetImage('assets/images/${_images[index]}'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: _itemCount(index + 1),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _itemCount(final int count) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 50.0,
        height: 30.0,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            '$count/3',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
