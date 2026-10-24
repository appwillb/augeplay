import 'dart:convert';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';

class CallSignalingPlatform {
  static void init(String userId) {
    try {
      js.context['playaugeCallService']?.callMethod('init', [userId]);
    } catch (_) {}
  }

  static void callUser(String targetUserId, Map<String, dynamic> callerData) {
    try {
      js.context['playaugeCallService']?.callMethod('callUser', [
        targetUserId,
        jsonEncode(callerData),
      ]);
    } catch (_) {}
  }

  static void answerCall(String targetUserId) {
    try {
      js.context['playaugeCallService']?.callMethod('answerCall', [targetUserId]);
    } catch (_) {}
  }

  static void endCall(String targetUserId) {
    try {
      js.context['playaugeCallService']?.callMethod('endCall', [targetUserId]);
    } catch (_) {}
  }

  static void registerCallbacks({
    required Function(Map<String, dynamic> caller) onIncomingCall,
    required VoidCallback onCallAnswered,
    required VoidCallback onCallEnded,
  }) {
    js.context['onPlayaugeIncomingCall'] = (dynamic callerData) {
      try {
        if (callerData is String) {
          final data = jsonDecode(callerData) as Map<String, dynamic>;
          onIncomingCall(data);
        } else if (callerData != null) {
          final jsonStr = js.context['JSON']?.callMethod('stringify', [callerData]) as String?;
          if (jsonStr != null) {
            final data = jsonDecode(jsonStr) as Map<String, dynamic>;
            onIncomingCall(data);
          }
        }
      } catch (_) {}
    };

    js.context['onPlayaugeCallAnswered'] = () {
      onCallAnswered();
    };

    js.context['onPlayaugeCallEnded'] = () {
      onCallEnded();
    };
  }
}
