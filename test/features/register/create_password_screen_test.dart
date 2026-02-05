import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:req_res_flutter/app/router.dart';
import 'package:req_res_flutter/core/api_client_provider.dart';
import 'package:req_res_flutter/core/shared_preferences_provider.dart';
import 'package:req_res_flutter/features/register/create_password/create_password_screen.dart';
import 'package:req_res_flutter/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    mockDio = MockDio();
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  Widget createSubject() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/create-password',
          name: AppRoutes.createPassword,
          builder: (_, state) =>
              CreatePasswordScreen(email: state.uri.queryParameters['email']!),
        ),
        GoRoute(
          path: '/create-profile',
          name: AppRoutes.createProfileSetNames,
          builder: (_, _) =>
              const Scaffold(body: Text('Set Display Name Screen')),
        ),
      ],
      initialLocation: '/create-password?email=test@email.com',
    );

    return ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(mockDio),
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  testWidgets('renders create password screen elements', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.text('Create Password'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    expect(find.text('Minimum length: 8 characters'), findsOneWidget);
    expect(find.text('1 uppercase letter'), findsOneWidget);
    expect(find.text('Alphanumeric'), findsOneWidget);
    expect(
      find.text('Accepted special characters: ! @ # \$ & -'),
      findsOneWidget,
    );

    expect(find.text('Sign up'), findsOneWidget);
  });

  testWidgets('validates password complexity', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    final input = find.byType(TextField);

    await tester.enterText(input, 'short');
    await tester.pump();
    expect(find.byIcon(Icons.check_rounded), findsWidgets);

    await tester.enterText(input, 'ValidPass1!');
    await tester.pump();
  });

  testWidgets('successful registration navigates to create profile', (
    tester,
  ) async {
    when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/register'),
        statusCode: 200,
        data: {'id': 1, 'token': 'fake-token'},
      ),
    );

    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'StrongP@ss1');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    final signUpButton = find.widgetWithText(ElevatedButton, 'Sign up');
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    verify(
      () => mockDio.post(
        '/register',
        data: {'email': 'eve.holt@reqres.in', 'password': 'pistol'},
      ),
    ).called(1);

    expect(find.text('Set Display Name Screen'), findsOneWidget);
  });
}
