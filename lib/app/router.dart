import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:req_res_flutter/core/is_signed_in_provider.dart';
import 'package:req_res_flutter/features/create_profile/create_profile_shell.dart';
import 'package:req_res_flutter/features/create_profile/set_display_name/set_display_name_screen.dart';
import 'package:req_res_flutter/features/home/home_screen.dart';
import 'package:req_res_flutter/features/login/login_screen.dart';
import 'package:req_res_flutter/features/register/create_password/create_password_screen.dart';
import 'package:req_res_flutter/features/register/otp/otp_screen.dart';
import 'package:req_res_flutter/features/register/sign_up/sign_up_screen.dart';
import 'package:req_res_flutter/features/create_profile/set_username/set_username_screen.dart';
import 'package:req_res_flutter/features/create_profile/set_profile_photo/set_profile_photo_screen.dart';
import 'package:req_res_flutter/features/account/account_screen.dart';
import 'package:req_res_flutter/ui_components/home_layout.dart';

abstract class AppRoutes {
  static const home = 'home';
  static const account = 'account';
  static const login = 'login';
  static const signUp = 'sign-up';
  static const otp = 'otp';
  static const createPassword = 'create-password';
  static const createProfileSetNames = 'create-profile-set-names';
  static const createProfileSetUsername = 'create-profile-set-username';
  static const createProfileSetPhoto = 'create-profile-set-photo';

  static const _authenticatedRoutes = ['/', '/account', '/create-profile/*'];
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) => HomeLayout(child: child),
        routes: [
          GoRoute(
            name: AppRoutes.home,
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            name: AppRoutes.account,
            path: '/account',
            builder: (context, state) => const AccountScreen(),
          ),
        ],
      ),
      GoRoute(
        name: AppRoutes.login,
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: AppRoutes.signUp,
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        name: AppRoutes.otp,
        path: '/otp',
        builder: (context, state) =>
            OTPScreen(email: state.uri.queryParameters['email']!),
      ),
      GoRoute(
        name: AppRoutes.createPassword,
        path: '/create-password',
        builder: (context, state) =>
            CreatePasswordScreen(email: state.uri.queryParameters['email']!),
      ),
      ShellRoute(
        builder: (context, state, child) => CreateProfileShell(child: child),
        routes: [
          GoRoute(
            name: AppRoutes.createProfileSetNames,
            path: '/create-profile',
            builder: (context, state) => const SetDisplayNameScreen(),
            routes: [
              GoRoute(
                name: AppRoutes.createProfileSetUsername,
                path: 'set-username',
                builder: (context, state) => const SetUsernameScreen(),
              ),
              GoRoute(
                name: AppRoutes.createProfileSetPhoto,
                path: 'set-profile-photo',
                builder: (context, state) => const SetProfilePhotoScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isSignedIn = ref.read(isSignedInProvider);

      final isRouteAuthenticated = AppRoutes._authenticatedRoutes.any((route) {
        if (route.endsWith('*')) {
          final prefix = route.substring(0, route.length - 1);
          return state.uri.path.startsWith(prefix);
        }

        return state.uri.path == route;
      });

      if (isSignedIn) {
        if (isRouteAuthenticated) return null;
        return '/';
      }

      if (isRouteAuthenticated) return '/login';

      return null;
    },
  );
});
