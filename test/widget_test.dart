import 'package:flutter_test/flutter_test.dart';
import 'package:playauge/main.dart';
import 'package:playauge/features/home/presentation/screens/main_navigation_screen.dart';

void main() {
  testWidgets('PlayAugeApp renders and displays MainNavigationScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const PlayAugeApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MainNavigationScreen), findsOneWidget);
    expect(find.text('GPSMusic'), findsWidgets);
    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Descobrir'), findsOneWidget);
  });
}
