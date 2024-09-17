import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/api/api_controller.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/sign_in_page.dart';
import '../ui/pages/sign_up_page.dart';

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
    // redirect: (context, state) {
    //   final isAuthenticated = ApiController.token != null ? true : false;
    //   // TODO: Add other guarded route later
    //   if (!isAuthenticated && state.matchedLocation == '/home') {
    //       return '/signIn';
    //   } else {
    //     return null;
    //   }
    // },
    errorBuilder: (context, state) => const Placeholder(),
  );
}
