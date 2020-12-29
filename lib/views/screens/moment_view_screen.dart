import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaman/models/moment_model.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:timeago/timeago.dart' as timeago;

class MomentViewScreen extends StatefulWidget {
  final List<Moment> moments;
  final int initIndex;
  MomentViewScreen(this.moments, this.initIndex);

  @override
  _MomentViewScreenState createState() => _MomentViewScreenState();
}

class _MomentViewScreenState extends State<MomentViewScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animation;
  ScrollController _scrollController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _handleAnimation();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: widget.moments.length,
                  itemBuilder: (context, index) {
                    return _momentsSliderItemBuilder(widget.moments[index]);
                  },
                  onPageChanged: (val) {
                    setState(() {
                      _index = val;
                    });
                    _restartAnimation();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _momentsSliderItemBuilder(final Moment moment) {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: moment.photo,
          ),
        ),
        _headerSectionBuilder(moment),
      ],
    );
  }

  Widget _headerSectionBuilder(final Moment moment) {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        _indicator(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AvatarBuilder(
                radius: 15.0,
                imgUrl: moment.owner.photoUrl,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                moment.owner.name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                timeago.format(
                  DateTime.fromMillisecondsSinceEpoch(
                    moment.updatedAt,
                  ),
                ),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _indicator() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return LinearProgressIndicator(
          minHeight: 1.5,
          value: _animation.value,
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        );
      },
    );
  }

  // handle animation when screen is initialized
  _handleAnimation() {
    _animation = AnimationController(
        duration: Duration(milliseconds: 5000), vsync: this);
    _scrollController = PageController(
      initialPage: widget.initIndex,
    );

    _animation.forward();
    _animation.addListener(() {
      setState(() {});
      if (_animation.isCompleted) {
        _changePage();
      }
    });
  }

  // restart animation on page change
  _restartAnimation() {
    _animation.reset();
    Future.delayed(Duration(milliseconds: 1000), () {
      _animation.forward();
    });
  }

  // change page when animation is completed
  _changePage() {
    _scrollController.animateTo(
      MediaQuery.of(context).size.width * (_index + 1 + widget.initIndex),
      duration: Duration(milliseconds: 1000),
      curve: Curves.ease,
    );

    if (_index >= (widget.moments.length - 1) ||
        widget.initIndex >= (widget.moments.length - 1)) {
      Navigator.pop(context);
    }
  }
}
