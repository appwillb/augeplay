import 'package:flutter/material.dart';
import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';
import 'call_signaling_stub.dart' if (dart.library.html) 'call_signaling_web.dart';

class CallSignalingService extends ChangeNotifier {
  static final CallSignalingService _instance = CallSignalingService._internal();
  factory CallSignalingService() => _instance;
  CallSignalingService._internal();

  Map<String, dynamic>? _incomingCallData;
  Map<String, dynamic>? get incomingCallData => _incomingCallData;
  bool get hasIncomingCall => _incomingCallData != null;

  void init(String userId) {
    CallSignalingPlatform.init(userId);
    CallSignalingPlatform.registerCallbacks(
      onIncomingCall: (caller) {
        _incomingCallData = caller;
        notifyListeners();
      },
      onCallAnswered: () {
        notifyListeners();
      },
      onCallEnded: () {
        _incomingCallData = null;
        notifyListeners();
      },
    );
  }

  void startCall({
    required UserEntity callerUser,
    required ProfileEntity targetProfile,
    required double cacheAmount,
  }) {
    CallSignalingPlatform.callUser(
      targetProfile.user.id,
      {
        'callerId': callerUser.id,
        'callerName': callerUser.displayName,
        'callerAvatar': callerUser.avatarUrl,
        'callerCity': '${callerUser.city} - ${callerUser.state}',
        'targetId': targetProfile.user.id,
        'cacheAmount': cacheAmount,
      },
    );
  }

  void acceptIncomingCall() {
    if (_incomingCallData != null) {
      final callerId = _incomingCallData!['callerId'] as String? ?? '';
      CallSignalingPlatform.answerCall(callerId);
      _incomingCallData = null;
      notifyListeners();
    }
  }

  void rejectIncomingCall() {
    if (_incomingCallData != null) {
      final callerId = _incomingCallData!['callerId'] as String? ?? '';
      CallSignalingPlatform.endCall(callerId);
      _incomingCallData = null;
      notifyListeners();
    }
  }

  void endCall(String targetUserId) {
    CallSignalingPlatform.endCall(targetUserId);
    _incomingCallData = null;
    notifyListeners();
  }

  void startMediaStream(String targetUserId) {
    CallSignalingPlatform.makeMediaCall(targetUserId);
  }
}
