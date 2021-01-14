import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaman/enums/notification_type.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/friend_provider.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:peaman/views/widgets/common_widgets/multi_avatar_builder.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsListItem extends StatelessWidget {
  final Notifications notification;
  NotificationsListItem(this.notification);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<NotificationItemVm>(
      vm: NotificationItemVm(),
      onInit: (vm) {
        // if (notification.isAccepted) {
        //   vm.updateBtnText('Follow back');
        // }
      },
      builder: (context, vm, appVm, appUser) {
        Widget _widget;
        switch (notification.type) {
          case NotificationType.followRequest:
            _widget = _followNotifBuilder(vm, appUser);
            break;
          case NotificationType.reaction:
            _widget = _reactNotifBuilder(vm, appUser);
            break;
          case NotificationType.comment:
            _widget = _commentNotifBuilder(vm, appUser);
            break;
          default:
            _widget = Container();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: _widget,
        );
      },
    );
  }

  Widget _followNotifBuilder(
      final NotificationItemVm vm, final AppUser appUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: <Widget>[
            // user image
            AvatarBuilder(
              imgUrl: notification.sender.photoUrl,
              radius: 22.0,
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Follow request",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Color(0xff3D4A5A),
                  ),
                ),
                Text(
                  "${notification.sender.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () => vm.onClickPositiveBtn(
                  appUser, notification.sender.uid, notification),
              height: 30.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
              child: Text(
                '${vm.btnText}',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            if (vm.btnText != 'Follow back' && !notification.isAccepted)
              Container(
                width: 30.0,
                height: 30.0,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () => vm.ignoreRequest(
                      appUser, notification, notification.sender.uid),
                  child: Icon(
                    Icons.close,
                    size: 15.0,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _reactNotifBuilder(
      final NotificationItemVm vm, final AppUser appUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: <Widget>[
              // user image
              MultiAvatarBuilder(
                users: notification.reactedBy,
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontFamily: 'Nunito',
                        ),
                        children: [
                          TextSpan(
                            text: notification.reactedBy.length >= 2
                                ? '${notification.reactedBy[0].name} and ${notification.reactedBy.length - 1} others '
                                : '${notification.reactedBy[0].name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' recently reacted to your post.',
                          ),
                        ],
                      ),
                    ),
                    Text(
                      timeago.format(DateTime.fromMillisecondsSinceEpoch(
                          notification.updatedAt)),
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Container(
          height: 50.0,
          width: 50.0,
          constraints: BoxConstraints(
            maxWidth: 50.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                notification.feed.photos[0],
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _commentNotifBuilder(
      final NotificationItemVm vm, final AppUser appUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: <Widget>[
              // user image
              MultiAvatarBuilder(
                users: notification.commentedBy,
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontFamily: 'Nunito',
                        ),
                        children: [
                          TextSpan(
                            text: notification.commentedBy.length >= 2
                                ? '${notification.commentedBy[0].name} and ${notification.commentedBy.length - 1} others '
                                : '${notification.commentedBy[0].name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' recently commented on your post.',
                          ),
                        ],
                      ),
                    ),
                    Text(
                      timeago.format(DateTime.fromMillisecondsSinceEpoch(
                          notification.updatedAt)),
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Container(
          height: 50.0,
          width: 50.0,
          constraints: BoxConstraints(
            maxWidth: 50.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                notification.feed.photos[0],
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationItemVm extends ChangeNotifier {
  String _btnText = 'Accept';

  String get btnText => _btnText;

  // on click positive btn
  onClickPositiveBtn(final AppUser appUser, final String userId,
      final Notifications notification) {
    if (_btnText == 'Accept') {
      _acceptFollow(appUser, userId, notification);
    } else if (_btnText == 'Follow back') {
      _followBack(appUser, userId, notification);
    }
  }

  // accept follow
  _acceptFollow(final AppUser appUser, final String userId,
      final Notifications notification) {
    updateBtnText('Follow back');

    final _user = AppUser(
      uid: userId,
      appUserRef: AppUser().getUserRef(userId),
    );
    FriendProvider(appUser: appUser, user: _user, notification: notification)
        .acceptFollow();
  }

  // follow back user
  _followBack(final AppUser appUser, final String userId,
      final Notifications notification) {
    updateBtnText('Following');

    final _user = AppUser(
      uid: userId,
      appUserRef: AppUser().getUserRef(userId),
    );
    FriendProvider(appUser: appUser, user: _user, notification: notification)
        .followBack();
  }

  // ignore request
  ignoreRequest(final AppUser appUser, final Notifications notification,
      final String userId) {
    final _user = AppUser(
      uid: userId,
      appUserRef: AppUser().getUserRef(userId),
    );
    FriendProvider(appUser: appUser, notification: notification, user: _user)
        .cancleFollow();
  }

  // update value of btn text
  updateBtnText(final String newBtnText) {
    _btnText = newBtnText;

    notifyListeners();
  }
}
