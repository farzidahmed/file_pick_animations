import 'package:file_pick_animation/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test loads Drop & Shoot screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Drop & Shoot Upload'), findsOneWidget);
    expect(find.text('Drop files here'), findsOneWidget);
  });
}
