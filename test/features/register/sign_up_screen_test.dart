import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:req_res_flutter/app/router.dart';
import 'package:req_res_flutter/features/register/otp/otp_screen.dart';
import 'package:req_res_flutter/features/register/sign_up/sign_up_screen.dart';
import 'package:req_res_flutter/l10n/app_localizations.dart';

void main() {
  Widget createSubject() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/sign-up',
          name: AppRoutes.signUp,
          builder: (_, _) => const SignUpScreen(),
        ),
        GoRoute(
          path: '/otp',
          name: AppRoutes.otp,
          builder: (_, state) =>
              OTPScreen(email: state.uri.queryParameters['email']!),
        ),
      ],
      initialLocation: '/sign-up',
    );

    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  testWidgets('renders sign up screen elements', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.text('Sign up'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Mobile number or Email'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Already have an account? '), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('validates invalid email format', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    final nextButton = find.widgetWithText(ElevatedButton, 'Next');

    await tester.enterText(find.byType(TextField), 'invalid-email');
    await tester.pump();

    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    expect(
      find.text('Ensure that you\'re entering the correct email'),
      findsOneWidget,
    );
  });

  testWidgets('validates empty field', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    final buttonFinder = find.widgetWithText(ElevatedButton, 'Next');
    final buttonWidget = tester.widget<ElevatedButton>(buttonFinder);
    expect(buttonWidget.onPressed, isNull);
  });

  testWidgets('navigates to OTP screen on valid input', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'valid@email.com');
    await tester.pump();

    final nextButton = find.widgetWithText(ElevatedButton, 'Next');

    final buttonWidget = tester.widget<ElevatedButton>(nextButton);
    expect(buttonWidget.onPressed, isNotNull);

    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    expect(find.byType(OTPScreen), findsOneWidget);
    expect(find.text('OTP'), findsOneWidget);
  });
}
