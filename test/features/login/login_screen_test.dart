import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:req_res_flutter/app/router.dart';
import 'package:req_res_flutter/core/api_client_provider.dart';
import 'package:req_res_flutter/core/shared_preferences_provider.dart';
import 'package:req_res_flutter/features/login/login_screen.dart';
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
          path: '/login',
          name: AppRoutes.login,
          builder: (_, _) => const LoginScreen(),
        ),
        GoRoute(
          path: '/',
          name: AppRoutes.home,
          builder: (_, _) => const Scaffold(body: Text('Home Screen')),
        ),
      ],
      initialLocation: '/login',
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

  testWidgets('renders login screen elements', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Forgot password?'), findsOneWidget);
  });

  testWidgets('validates empty form', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(
      find.text('Please enter your email or mobile number'),
      findsOneWidget,
    );
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('successful login navigates to home', (tester) async {
    when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/login'),
        statusCode: 200,
        data: {'token': 'fake-token'},
      ),
    );

    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'eve.holt@reqres.in');
    await tester.enterText(find.byType(TextField).at(1), 'pistol');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    await tester.pumpAndSettle();

    expect(find.text('Home Screen'), findsOneWidget);

    verify(
      () => mockDio.post(
        '/login',
        data: {'email': 'eve.holt@reqres.in', 'password': 'pistol'},
      ),
    ).called(1);
  });

  testWidgets('failed login shows error snackbar', (tester) async {
    when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/login'),
          statusCode: 400,
          data: {'error': 'user not found'},
        ),
        type: DioExceptionType.badResponse,
      ),
    );

    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'fail@test.com');
    await tester.enterText(find.byType(TextField).at(1), 'failpass');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('user not found'), findsOneWidget);
    expect(find.text('Home Screen'), findsNothing);
  });
}
