import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasm_poc_workspace/features/landing/presentations/landing_page.dart';
import 'package:kasm_poc_workspace/generated/strings.g.dart';

void main() {
  testWidgets('LandingPage counter increments test', (WidgetTester tester) async {
    await tester.pumpWidget(TranslationProvider(child: const MaterialApp(home: LandingPage())));

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
