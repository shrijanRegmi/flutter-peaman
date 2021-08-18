import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/models/moment_model.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/viewmodels/moment_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:peaman/services/database_services/feed_provider.dart';

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
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    _img = CachedNetworkImageProvider(
      widget.moment.photo.contains('firebase') ? widget.moment.photo : '',
    );
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
    final _appUser = Provider.of<AppUser>(context);
    final _appVm = Provider.of<AppVm>(context);
    return ViewmodelProvider<MomentVm>(
      vm: MomentVm(),
      onInit: (vm) => vm.onInit(_appUser, _appVm, widget.moment),
      builder: (context, vm, appVm, appUser) {
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
            if (_isBottomSheetOpen) {
              Navigator.pop(context);
            }

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
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image(
                    image: widget.moment.photo.contains('.com')
                        ? _img
                        : FileImage(File(widget.moment.photo)),
                  ),
                ),
                _headerSectionBuilder(),
                if (widget.moment.ownerId == appUser.uid)
                  _viewsBuilder(appUser),
              ],
            ),
          ),
        );
      },
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

  Widget _viewsBuilder(final AppUser appUser) {
    return Positioned(
      bottom: 20.0,
      left: 20.0,
      child: widget.moment.id == null
          ? Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Icon(Icons.visibility, color: Colors.white),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '${0}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )
          : StreamBuilder<List<AppUser>>(
              stream: FeedProvider(moment: widget.moment).momentViewers,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final _seenUsers = snapshot.data ?? [];

                  return GestureDetector(
                    onTap: _seenUsers.isEmpty
                        ? () {}
                        : () async {
                            setState(() {
                              _isBottomSheetOpen = true;
                            });
                            _animation.stop();

                            final _controller = showBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.visibility,
                                              color: Colors.black,
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              '${_seenUsers.length}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.separated(
                                          itemBuilder: (context, index) {
                                            final _seenUser = _seenUsers[index];
                                            return ListTile(
                                              leading: AvatarBuilder(
                                                imgUrl: _seenUser.photoUrl,
                                              ),
                                              title: Text(
                                                '${_seenUser.name}',
                                              ),
                                            );
                                          },
                                          itemCount: _seenUsers.length,
                                          separatorBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Divider(),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            final _val = await _controller.closed;
                            if (_val == null) {
                              _animation.forward();
                            }
                          },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Icon(Icons.visibility, color: Colors.white),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '${_seenUsers.length}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                );
              },
            ),
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
    if (widget.moment.photo.contains('.com')) {
      _img.resolve(new ImageConfiguration()).addListener(
        ImageStreamListener((info, call) {
          _animation.forward();
        }),
      );
    } else {
      _animation.forward();
    }
    //

    _animation.addListener(() {
      setState(() {});
      if (_animation.isCompleted) {
        widget.changePage(true);
      }
    });
  }
}
