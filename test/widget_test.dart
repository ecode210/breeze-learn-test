import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:x_social/main.dart';
import 'package:x_social/views/widgets/app_button.dart';

void main() {
  testWidgets("X Social Auth Test", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(test: true));

    await tester.idle();
    await tester.pumpAndSettle();

    expect(find.text("Login"), findsExactly(2));
    expect(find.byType(AppButton), findsExactly(1));

    await tester.enterText(find.byKey(const ValueKey("email")), "olawoleaeo@gmail.com");
    await tester.enterText(find.byKey(const ValueKey("password")), "123xyz.");
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.byType(SnackBar), findsExactly(1));
    ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).removeCurrentSnackBar();
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);

    await tester.tap(find.byKey(const ValueKey("register")));
    await tester.pumpAndSettle();

    expect(find.text("Register"), findsExactly(2));

    await tester.enterText(find.byKey(const ValueKey("name")), "Olawole Oyedele");
    await tester.enterText(find.byKey(const ValueKey("email")), "olawoleaeo@gmail.com");
    await tester.enterText(find.byKey(const ValueKey("password")), "123xyz.");
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsExactly(1));
    ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).removeCurrentSnackBar();
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
  });
}
