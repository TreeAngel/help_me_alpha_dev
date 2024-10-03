import 'package:go_router/go_router.dart';

import '../services/api/api_controller.dart';
import '../ui/pages/auth/change_password_page.dart';
import '../ui/pages/auth/forget_password_page.dart';
import '../ui/pages/home/edit_profile_page.dart';
import '../ui/pages/misc/image_zoom_page.dart';
import '../ui/pages/misc/launch_page.dart';
import '../ui/pages/order/add_task_page.dart';
import '../ui/pages/home/home_page.dart';
import '../ui/pages/home/profile_page.dart';
import '../ui/pages/auth/sign_in_page.dart';
import '../ui/pages/auth/sign_up_page.dart';
import '../ui/pages/order/detail_page.dart';
import '../ui/pages/auth/verify_phone_number_page.dart';

class AppRoute {
  static final GoRouter appRoute = GoRouter(
    initialLocation: '/',
    routes: _routes,
    redirect: (context, state) {
      final isAuthenticated = ApiController.token != null ? true : false;
      // TODO: Add other guarded route later
      if (isAuthenticated == false && state.matchedLocation == '/home') {
        return '/signIn';
      } else if (isAuthenticated == false &&
          state.matchedLocation == '/profile') {
        return '/signIn';
      } else if (isAuthenticated == false &&
          state.matchedLocation == '/editProfile') {
        return '/signIn';
      } else if (isAuthenticated == false &&
          state.matchedLocation == '/detail') {
        return '/signIn';
      } else if (isAuthenticated == false &&
          state.matchedLocation == '/addTask') {
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
        path: '/forgetPassword',
        name: 'forgetPasswordPage',
        builder: (context, state) => const ForgetPasswordPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'homePage',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profilePage',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/editProfile',
        name: 'editProfilePage',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/changePassword',
        name: 'changePasswordPage',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/verifyPhoneNumber',
        name: 'verifyPhoneNumberPage',
        builder: (context, state) => const VerifyPhoneNumberPage(),
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
