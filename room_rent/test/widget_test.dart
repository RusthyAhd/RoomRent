// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:room_rent/main.dart';

void main() {
  testWidgets('App launches and shows launch page', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app shows the village guest house title
    expect(find.text('Village Guest House'), findsOneWidget);

    // Verify that there's a get started button or similar element
    expect(find.text('Get Started'), findsOneWidget);
  });
}
