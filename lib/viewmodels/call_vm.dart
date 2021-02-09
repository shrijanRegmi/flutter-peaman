import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:peaman/helpers/chat_helper.dart';
import 'package:peaman/models/app_models/call_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/call_provider.dart';
import 'package:peaman/utils/agora_settings.dart';

class CallVm extends ChangeNotifier {
  final BuildContext context;
  CallVm(this.context);

  bool _isMuted = false;
  bool _isCameraOff = false;
  Timer _durationTimer;
  int _counter = 0;
  bool _isBtnsHidden = false;
  Call _thisCall;

  bool get isCameraOff => _isCameraOff;
  bool get isMuted => _isMuted;
  Timer get durationTimer => _durationTimer;
  int get counter => _counter;
  bool get isBtnsHidden => _isBtnsHidden;
  Call get thisCall => _thisCall;

  // init function
  onInit(final AppUser appUser, final AppUser friend, final String channelName,
      final ClientRole role) {
    _initializeAgora(role, channelName, appUser.uid.hashCode);
    _callFriend(appUser, friend);
    _durationTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (_durationTimer.isActive) {
        _updateCounter(timer.tick);
      }
    });
  }

  // dispose function
  onDis(final AppUser appUser, final AppUser friend) async {
    _durationTimer?.cancel();
    _destroyAgora();
    await CallProvider(appUser: appUser, friend: friend, call: _thisCall)
        .endCall();
  }

  // call friend
  _callFriend(final AppUser appUser, final AppUser friend) async {
    final _call = Call(
      id: ChatHelper().getChatId(myId: appUser.uid, friendId: friend.uid),
      caller: appUser,
      receiver: friend,
      hasExpired: false,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await CallProvider(appUser: appUser, friend: friend, call: _call)
        .callFriend();

    _thisCall = _call;
    notifyListeners();
  }

  // cancel call
  cancelCall() {
    Navigator.pop(context);
  }

  // on press mic
  onPressedMic() {
    AgoraRtcEngine.muteLocalAudioStream(!_isMuted);
    _updateIsMuted(!_isMuted);
  }

  // on press camera
  onPressedCamera() {
    _updateIsCameraOff(!_isCameraOff);
  }

  // initialize agora
  Future<void> _initializeAgora(
      final ClientRole role, final String channelName, final int uid) async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
    await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await AgoraRtcEngine.setClientRole(role);

    _agoraEventsHandler();

    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = Size(1920, 1080);
    await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
    await AgoraRtcEngine.joinChannel(null, channelName, null, uid);
  }

  // agora events handler
  _agoraEventsHandler() {
    AgoraRtcEngine.onError = (dynamic code) {
      print('INFO: The error is ::: $code');
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      print('INFO: $uid joined the channel $channel');
    };

    AgoraRtcEngine.onLeaveChannel = () {
      print('INFO: Channel was left');
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      print('INFO: User $uid joined the channel');
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      print('INFO: User $uid is offline');
    };
  }

  // destroy agora
  _destroyAgora() {
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
  }

  // update value of is muted
  _updateIsMuted(final bool newVal) {
    _isMuted = newVal;
    notifyListeners();
  }

  // update value of is camera off
  _updateIsCameraOff(final bool newVal) {
    _isCameraOff = newVal;
    notifyListeners();
  }

  // update value of counter
  _updateCounter(final int newVal) {
    _counter = newVal;
    notifyListeners();
  }

  // update value of btns hidden
  updateIsBtnsHidden(final bool newVal) {
    _isBtnsHidden = newVal;
    notifyListeners();
  }
}
