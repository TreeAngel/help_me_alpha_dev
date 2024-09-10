import 'package:go_router/go_router.dart';
import 'package:help_me_client_alpha_ver/ui/pages/home_page.dart';

class AppRoute {
  static GoRouter get appRoute {
    return GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
            path: '/home',
            name: 'homePage',
            builder: (context, state) => const HomePage()),
      ],
    );
  }
}
