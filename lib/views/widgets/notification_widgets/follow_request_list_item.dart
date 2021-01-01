import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/notification_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/friend_provider.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';

class FollowRequestListItem extends StatelessWidget {
  final Notifications followRequest;
  FollowRequestListItem(this.followRequest);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<FollowRequestItemVm>(
      vm: FollowRequestItemVm(),
      onInit: (vm) {
        if (followRequest.isAccepted) {
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
      final FollowRequestItemVm vm, final AppUser appUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: <Widget>[
            // user image
            AvatarBuilder(
              imgUrl: followRequest.sender.photoUrl,
              radius: 22.0,
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${followRequest.sender.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Color(0xff3D4A5A),
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
                  appUser, followRequest.sender.uid, followRequest),
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
            if (vm.btnText != 'Follow back' && !followRequest.isAccepted)
              Container(
                width: 30.0,
                height: 30.0,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () => vm.ignoreRequest(
                      appUser, followRequest, followRequest.sender.uid),
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

class FollowRequestItemVm extends ChangeNotifier {
  String _btnText = 'Accept';

  String get btnText => _btnText;

  // on click positive btn
  onClickPositiveBtn(final AppUser appUser, final String userId,
      final Notifications followRequest) {
    if (_btnText == 'Accept') {
      _acceptFollow(appUser, userId, followRequest);
    } else if (_btnText == 'Follow back') {
      _followBack(appUser, userId, followRequest);
    }
  }

  // accept follow
  _acceptFollow(final AppUser appUser, final String userId,
      final Notifications followRequest) {
    updateBtnText('Follow back');

    final _user = AppUser(
      uid: userId,
      appUserRef: AppUser().getUserRef(userId),
    );
    FriendProvider(appUser: appUser, user: _user, notification: followRequest)
        .acceptFollow();
  }

  // follow back user
  _followBack(final AppUser appUser, final String userId,
      final Notifications followRequest) {
    updateBtnText('Following');

    final _user = AppUser(
      uid: userId,
      appUserRef: AppUser().getUserRef(userId),
    );
    FriendProvider(appUser: appUser, user: _user, notification: followRequest)
        .followBack();
  }

  // ignore request
  ignoreRequest(final AppUser appUser, final Notifications followRequest,
      final String userId) {
    final _user = AppUser(
      uid: userId,
      appUserRef: AppUser().getUserRef(userId),
    );
    FriendProvider(appUser: appUser, notification: followRequest, user: _user)
        .cancleFollow();
  }

  // update value of btn text
  updateBtnText(final String newBtnText) {
    _btnText = newBtnText;

    notifyListeners();
  }
}
