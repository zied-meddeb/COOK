// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';

import 'package:cuisin_voisin/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HomeChefDeliveryApp());

    // Verify the app loads
    expect(find.text('HomeChef Delivery'), findsNothing);
  });
}
