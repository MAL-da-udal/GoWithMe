import 'package:go_router/go_router.dart';
import 'package:go_with_me/ui/pages/auth_page.dart';
import 'package:go_with_me/ui/pages/home_page.dart';
import 'package:go_with_me/ui/pages/splash_page.dart';
import 'package:go_with_me/ui/pages/user_profile_page.dart';

final router = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/profile/:token',
      builder: (context, state) =>
          UserProfilePage(token: state.pathParameters['token']!),
    ),
  ],
);
