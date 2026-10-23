import 'package:flutter_test/flutter_test.dart';
import 'package:first_project/main.dart';

void main() {
  testWidgets('Restaurant App renders menu smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RestaurantApp());

    // Verify that the title or header appears.
    expect(find.text('Categories'), findsOneWidget);
  });
}
