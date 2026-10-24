import 'dart:async';
import 'package:flutter/foundation.dart';

class CallSignalingPlatform {
  static void init(String userId) {}
  static void callUser(String targetUserId, Map<String, dynamic> callerData) {}
  static void answerCall(String targetUserId) {}
  static void endCall(String targetUserId) {}
  static void registerCallbacks({
    required Function(Map<String, dynamic> caller) onIncomingCall,
    required VoidCallback onCallAnswered,
    required VoidCallback onCallEnded,
  }) {}
}
