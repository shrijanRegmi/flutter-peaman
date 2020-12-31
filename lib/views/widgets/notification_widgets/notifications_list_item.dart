import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/friend_provider.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';

class NotificationsListItem extends StatelessWidget {
  final Notifications notification;
  NotificationsListItem(this.notification);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<NotificationItemVm>(
      vm: NotificationItemVm(),
      onInit: (vm) {
        if (notification.isAccepted) {
          vm.updateBtnText('Follow back');
        }
      },
      builder: (context, vm, appVm, appUser) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: _followNotifBuilder(vm, appUser),
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
              radius: 25.0,
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
