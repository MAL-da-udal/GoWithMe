import 'package:go_router/go_router.dart';
import 'package:go_with_me/ui/pages/auth_page.dart';
import 'package:go_with_me/ui/pages/chat_page.dart';
import 'package:go_with_me/ui/pages/home_page.dart';
import 'package:go_with_me/ui/pages/user_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

final router = GoRouter(
  initialLocation: '/',
   redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return '/auth';
    return null;
  },

  routes: [
    GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/chat/:id', builder: (context, state) => const ChatPage()),
    GoRoute(path: '/profile/:id', builder: (context, state) => const UserProfilePage()),
  ],
);
