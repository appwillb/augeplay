import 'package:flutter_test/flutter_test.dart';
import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/features/videos/data/call_signaling_service.dart';

void main() {
  group('CallSignalingService Tests', () {
    late CallSignalingService service;

    setUp(() {
      service = CallSignalingService();
      service.init('user_pedro_santos');
    });

    test('starts call and updates signaling without crashing', () {
      service.startCall(
        callerUser: MockData.joaoSilva,
        targetProfile: MockData.profiles[1],
        cacheAmount: 650.0,
      );

      // In VM stub, startCall invokes the stub platform without error
      expect(service.hasIncomingCall, false);
    });

    test('accept and reject incoming call reset incoming call data safely', () {
      service.acceptIncomingCall();
      expect(service.hasIncomingCall, false);

      service.rejectIncomingCall();
      expect(service.hasIncomingCall, false);

      service.endCall('user_joao_silva');
      expect(service.hasIncomingCall, false);
    });
  });
}
