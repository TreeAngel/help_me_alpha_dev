import 'package:go_router/go_router.dart';

import '../services/api/api_controller.dart';
import '../ui/pages/home_page_copy.dart';
import '../ui/pages/image_zoom_page.dart';
import '../ui/pages/launch_page.dart';
import '../ui/pages/add_task_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/sign_in_page.dart';
import '../ui/pages/sign_up_page.dart';
import '../ui/pages/detail_page.dart';

class AppRoute {
  static final GoRouter appRoute = GoRouter(
    initialLocation: '/',
    routes: _routes,
    redirect: (context, state) {
      final isAuthenticated = ApiController.token != null ? true : false;
      // TODO: Add other guarded route later
      if (isAuthenticated == false && state.matchedLocation == '/home') {
        return '/signIn';
      } else if (isAuthenticated == true &&
          state.matchedLocation == '/signIn') {
        return '/home';
      } else if (isAuthenticated == true &&
          state.matchedLocation == '/signUp') {
        return '/home';
      } else {
        return null;
      }
    },
    // errorBuilder: (context, state) => const Placeholder(),
  );

  static List<RouteBase> get _routes {
    return [
      GoRoute(
        path: '/',
        name: 'init',
        builder: (context, state) => const LaunchPage(),
      ),
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
      GoRoute(
        path: '/detail',
        name: 'detailPage',
        builder: (context, state) {
          final id = state.uri.queryParameters['categoryId'].toString();
          final category = state.uri.queryParameters['category'];
          return DetailPage(
            categoryId: int.parse(id),
            category: category.toString(),
          );
        },
      ),
      GoRoute(
        path: '/addTask',
        name: 'addTaskPage',
        builder: (context, state) {
          String id = state.uri.queryParameters['problemId'].toString();
          final problem = state.uri.queryParameters['problem'];
          return AddTaskPage(
            problemId: id.isNotEmpty ? int.parse(id) : null,
            problem: problem.toString(),
          );
        },
      ),
      GoRoute(
        path: '/imageZoom',
        name: 'imageZoomPage',
        builder: (context, state) {
          final path = state.uri.queryParameters['imagePath'].toString();
          final name = state.uri.queryParameters['imageName'].toString();
          return ImageZoomPage(
            imagePath: path,
            imageName: name,
          );
        },
      ),
    ];
  }
}
