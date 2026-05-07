import 'package:flutter_test/flutter_test.dart';
import 'package:carevo_app_2026/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CarevoApp());

    // Basic check to ensure app starts (might need more setup for Supabase/Riverpod in real tests)
    expect(find.byType(CarevoApp), findsOneWidget);
  });
}
