import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/models/qb_rtc_session.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';

class VideoCall extends StatefulWidget {
  String qbSession;
  int receiver_id;
  int currentUserId;
  VideoCall(this.qbSession,this.currentUserId,this.receiver_id);

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  RTCVideoViewController _localVideoViewController;
  RTCVideoViewController _remoteVideoViewController;
  StreamSubscription _callSubscription;


  String sessionId = "";
  int userId;
  int opponentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            width: 160.0,
            height: 160.0,
            child: RTCVideoView(
              onVideoViewCreated: _onLocalVideoViewCreated,
            ),
            decoration: new BoxDecoration(color: Colors.black54),
          ),
          Container(
            margin: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            width: 160.0,
            height: 160.0,
            child: RTCVideoView(
              onVideoViewCreated: _onRemoteVideoViewCreated,
            ),
            decoration: new BoxDecoration(color: Colors.black54),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    initWebrtc();
    initSubcription();
    // call(widget.currentUserId,widget.receiver_id);
    sessionId = widget.qbSession;
    userId = widget.currentUserId;
    opponentId = widget.receiver_id;

  }

  @override
  void dispose() {
    _callSubscription.cancel();
    release();
    super.dispose();
  }

  Future<void> initWebrtc() async {
    try {
      await QB.webrtc.init();
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  Future<void> play() async {
    _localVideoViewController.play(sessionId, userId);
    _remoteVideoViewController.play(sessionId, opponentId);
  }

  void _onLocalVideoViewCreated(RTCVideoViewController controller) {
    _localVideoViewController = controller;
  }

  void _onRemoteVideoViewCreated(RTCVideoViewController controller) {
    _remoteVideoViewController = controller;
  }

  Future<void> initSubcription() async {
    try {
      _callSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.CALL, (data) {
        Map<String, Object> payloadMap = new Map<String, Object>.from(data["payload"]);
        Map<String, Object> sessionMap = new Map<String, Object>.from(payloadMap["session"]);

        String sessionId = sessionMap["id"];
        int initiatorId = sessionMap["initiatorId"];
        int callType = sessionMap["type"];

        print('callType  $callType');
      });
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  Future<void> call(currentUserId,receiver_id) async {
    List<int> opponentIds = [currentUserId, receiver_id];
    int sessionType = QBRTCSessionTypes.AUDIO;

    try {
      QBRTCSession session = await QB.webrtc.call(opponentIds, sessionType);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  Future<void> acceptCall() async {
    Map<String, Object> userInfo = new Map();
    String sessionId = "5d4175afa0eb4715cae5b63f";

    try {
      QBRTCSession session = await QB.webrtc.accept(sessionId, userInfo: userInfo);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  Future<void> rejectCall() async {
    Map<String, Object> userInfo = new Map();
    String sessionId = "5d4175afa0eb4715cae5b63f";

    try {
      QBRTCSession session = await QB.webrtc.reject(sessionId, userInfo: userInfo);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  Future<void> endCall() async {
    Map<String, Object> userInfo = new Map();
    String sessionId = "5d4175afa0eb4715cae5b63f";

    try {
      QBRTCSession session = await QB.webrtc.hangUp(sessionId, userInfo: userInfo);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  Future<void> release() async {
    try {
      await QB.webrtc.release();
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

}
