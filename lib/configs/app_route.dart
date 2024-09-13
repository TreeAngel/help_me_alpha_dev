import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/api/api_helper.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/sign_in_page.dart';
import '../ui/pages/sign_up_page.dart';
// import '../utils/router_util.dart';

class AppRoute {
  static final GoRouter appRoute = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        name: 'homePage',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/signIn',
        name: 'signInPage',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/signUp',
        name: 'signUpPage',
        builder: (context, state) => const SignUpPage(),
      ),
    ],
    redirect: (context, state) {
      final isAuthenticated = ApiHelper.token != null ? true : false;
      if (!isAuthenticated) {
        return '/signIn';
      } else {
        return null;
      }
    },
    errorBuilder: (context, state) => const Placeholder(),
  );
}
