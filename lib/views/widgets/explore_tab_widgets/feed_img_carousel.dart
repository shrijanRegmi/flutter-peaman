import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FeedImageCarousel extends StatefulWidget {
  @override
  _FeedImageCarouselState createState() => _FeedImageCarouselState();

  final List<String> photos;
  FeedImageCarousel(this.photos);
}

class _FeedImageCarouselState extends State<FeedImageCarousel> {
  ScrollController _pageViewController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(
      initialPage: widget.photos.length ~/ 3,
      viewportFraction: widget.photos.length != 1 ? 0.8 : 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      child: PageView.builder(
        controller: _pageViewController,
        itemCount: widget.photos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xff3D4A5A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.photos[index]),
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
            '$count/${widget.photos.length}',
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
