import 'package:go_router/go_router.dart';
import 'package:help_me_client_alpha_ver/ui/pages/home_page.dart';
import 'package:help_me_client_alpha_ver/ui/pages/sign_in_page.dart';

class AppRoute {
  static GoRouter get appRoute {
    return GoRouter(
      initialLocation: '/sign-in', // Default should be home, if else then it was change for development purpose
      routes: [
        GoRoute(
          path: '/home',
          name: 'homePage',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/sign-in',
          name: 'signInPage',
          builder: (context, state) => const SignInPage(),
        ),
      ],
    );
  }
}
