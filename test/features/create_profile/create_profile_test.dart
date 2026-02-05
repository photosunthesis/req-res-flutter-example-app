import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:req_res_flutter/app/router.dart';
import 'package:req_res_flutter/core/image_picker_provider.dart';
import 'package:req_res_flutter/core/shared_preferences_provider.dart';
import 'package:req_res_flutter/features/create_profile/set_display_name/set_display_name_screen.dart';
import 'package:req_res_flutter/features/create_profile/set_profile_photo/set_profile_photo_screen.dart';
import 'package:req_res_flutter/features/create_profile/set_username/set_username_screen.dart';
import 'package:req_res_flutter/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  late MockImagePicker mockImagePicker;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    mockImagePicker = MockImagePicker();
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  Widget createSubject(String path) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/create-profile',
          name: AppRoutes.createProfileSetNames,
          builder: (_, _) => const Scaffold(body: SetDisplayNameScreen()),
          routes: [
            GoRoute(
              path: 'set-username',
              name: AppRoutes.createProfileSetUsername,
              builder: (_, _) => const Scaffold(body: SetUsernameScreen()),
            ),
            GoRoute(
              path: 'set-profile-photo',
              name: AppRoutes.createProfileSetPhoto,
              builder: (_, _) => const Scaffold(body: SetProfilePhotoScreen()),
            ),
          ],
        ),
        GoRoute(
          path: '/',
          name: AppRoutes.home,
          builder: (_, _) => const Scaffold(body: Text('Home Screen')),
        ),
      ],
      initialLocation: path,
    );

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        imagePickerProvider.overrideWithValue(mockImagePicker),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  group('SetDisplayNameScreen', () {
    testWidgets('renders elements and navigates on valid input', (
      tester,
    ) async {
      await tester.pumpWidget(createSubject('/create-profile'));
      await tester.pumpAndSettle();

      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'Eve');
      await tester.enterText(find.byType(TextField).at(1), 'Holt');
      await tester.pump();

      final nextButton = find.widgetWithText(ElevatedButton, 'Next');
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      expect(find.byType(SetUsernameScreen), findsOneWidget);
      expect(sharedPreferences.getString('first_name'), 'Eve');
      expect(sharedPreferences.getString('last_name'), 'Holt');
    });
  });

  group('SetUsernameScreen', () {
    testWidgets('renders elements and navigates on valid input', (
      tester,
    ) async {
      await tester.pumpWidget(createSubject('/create-profile/set-username'));
      await tester.pumpAndSettle();

      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Minimum length: 8 characters'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Valid.user123');
      await tester.pump();

      expect(find.byIcon(Icons.check), findsWidgets);

      final nextButton = find.widgetWithText(ElevatedButton, 'Next');
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Verify business logic (store username) happened on valid submit
      expect(sharedPreferences.getString('username'), 'Valid.user123');
    });
  });

  group('SetProfilePhotoScreen', () {
    testWidgets('renders elements and handles skipping', (tester) async {
      await tester.pumpWidget(
        createSubject('/create-profile/set-profile-photo'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Profile Picture'), findsOneWidget);
      expect(find.text('Take a photo'), findsOneWidget);
      expect(find.text('Upload a photo'), findsOneWidget);

      final nextButton = find.widgetWithText(ElevatedButton, 'Next');
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      expect(find.text('Home Screen'), findsOneWidget);
    });
  });
}
