import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:melodify/app.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MelodifyApp()),
    );
    // Pump one frame for the splash to render
    await tester.pump();

    // Verify the app name is displayed on splash
    expect(find.text('Melodify'), findsOneWidget);
    expect(find.text('Feel Every Beat.'), findsOneWidget);

    // Pump past the splash timer to avoid pending timer error
    await tester.pump(const Duration(seconds: 4));
    await tester.pump();
  });
}
