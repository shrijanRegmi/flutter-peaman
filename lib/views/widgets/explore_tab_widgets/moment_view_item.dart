import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaman/models/moment_model.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:timeago/timeago.dart' as timeago;

class MomentViewItem extends StatefulWidget {
  @override
  _MomentViewItemState createState() => _MomentViewItemState();
  final Function(bool) changePage;
  final Moment moment;

  MomentViewItem({this.changePage, this.moment});
}

class _MomentViewItemState extends State<MomentViewItem>
    with SingleTickerProviderStateMixin {
  AnimationController _animation;
  CachedNetworkImageProvider _img;

  bool _isLongTap = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _img = CachedNetworkImageProvider(widget.moment.photo);
    _handleAnimation();
  }

  @override
  void dispose() {
    if (_animation != null) {
      _animation.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onLongPressStart: (details) {
        setState(() {
          _isLongTap = true;
        });
      },
      onLongPressEnd: (details) {
        _animation.forward();
        setState(() {
          _isLongTap = false;
        });
      },
      onTapDown: (details) {
        _animation.stop();
      },
      onTapUp: (details) {
        _animation.forward();

        final _leftTapPos = 20 / 100 * _width;
        final _rightTapPos = 80 / 100 * _width;

        if (!_isLongTap && !_isDragging) {
          if (details.globalPosition.dx >= _rightTapPos) {
            widget.changePage(true);
          } else if (details.globalPosition.dx <= _leftTapPos) {
            widget.changePage(false);
          }
        }
      },
      onVerticalDragEnd: (details) {
        _animation.forward();
      },
      // onHorizontalDragStart: (details) {
      //   setState(() {
      //     _isDragging = true;
      //   });

      //   _animation.forward();
      // },
      // onHorizontalDragEnd: (details) {
      //   setState(() {
      //     _isDragging = false;
      //   });


      //   if (!_isLongTap) {
      //     if (details.primaryVelocity < 0) {
      //       widget.changePage(true);
      //     } else {
      //       widget.changePage(false);
      //     }
      //   }
      // },
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image(
                image: _img,
              ),
            ),
            _headerSectionBuilder(),
          ],
        ),
      ),
    );
  }

  Widget _headerSectionBuilder() {
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
                imgUrl: widget.moment.owner.photoUrl,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                widget.moment.owner.name,
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
                    widget.moment.updatedAt,
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

    // play animation only when the image is fully loaded
    _img.resolve(new ImageConfiguration()).addListener(
      ImageStreamListener((info, call) {
        _animation.forward();
      }),
    );
    //

    _animation.addListener(() {
      setState(() {});
      if (_animation.isCompleted) {
        widget.changePage(true);
      }
    });
  }
}
