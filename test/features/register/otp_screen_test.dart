import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:req_res_flutter/app/router.dart';
import 'package:req_res_flutter/features/register/create_password/create_password_screen.dart';
import 'package:req_res_flutter/features/register/otp/otp_screen.dart';
import 'package:req_res_flutter/l10n/app_localizations.dart';

void main() {
  Widget createSubject() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/otp',
          name: AppRoutes.otp,
          builder: (_, state) =>
              OTPScreen(email: state.uri.queryParameters['email']!),
        ),
        GoRoute(
          path: '/create-password',
          name: AppRoutes.createPassword,
          builder: (_, state) =>
              CreatePasswordScreen(email: state.uri.queryParameters['email']!),
        ),
      ],
      initialLocation: '/otp?email=test@email.com',
    );

    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  testWidgets('renders otp screen elements', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pump();

    expect(find.text('OTP'), findsOneWidget);
    expect(
      find.text(
        'Please check your email or message inbox for the OTP. If you don\'t see it, check your spam or junk folder.',
      ),
      findsOneWidget,
    );
    expect(find.byType(Pinput), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    expect(
      find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          final plainText = widget.text.toPlainText();
          return plainText.contains('Code is expiring in');
        }
        return false;
      }),
      findsOneWidget,
    );
  });

  testWidgets('navigates to create password on full pin entry', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pump();

    await tester.enterText(find.byType(Pinput), '123456');
    await tester.pump();

    final nextButton = find.widgetWithText(ElevatedButton, 'Next');
    final buttonWidget = tester.widget<ElevatedButton>(nextButton);
    expect(buttonWidget.onPressed, isNotNull);

    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    expect(find.byType(CreatePasswordScreen), findsOneWidget);
  });

  testWidgets('timer countdown updates', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pump();

    expect(
      find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          final plainText = widget.text.toPlainText();
          return plainText.contains('300 seconds');
        }
        return false;
      }),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 1));

    expect(
      find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          final plainText = widget.text.toPlainText();
          return plainText.contains('299 seconds');
        }
        return false;
      }),
      findsOneWidget,
    );
  });
}
