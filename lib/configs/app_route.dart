import 'package:go_router/go_router.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/forgot_password_page.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/order_popup.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/selected_popup.dart';

import '../services/api/api_controller.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/sign_in_page.dart';
import '../ui/pages/sign_up_page.dart';
import '../ui/pages/order_popup.dart';

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
      // GoRoute(
      //   path: '/forgotPassword',
      //   name: 'forgotPasswordPage',
      //   builder: (context, state) => const ForgotPasswordPage(),
      // ),
      GoRoute(
        path: '/getpostorder',
        name: 'orderPop',
        builder: (context, state) => const OrderPop(),
      ),
      GoRoute(
        path: '/getselectedorder',
        name: 'selectedPop',
        builder: (context, state) => const SelectedPop(),
      ),
    ],
    redirect: (context, state) {
      final isAuthenticated = ApiController.token != null ? true : false;
      // TODO: Add other guarded route later
      if (isAuthenticated == false && state.matchedLocation == '/home') {
        return '/signIn';
      } else if (isAuthenticated == true &&
          state.matchedLocation == '/signIn' &&
          state.matchedLocation == '/signUp') {
        return '/home';
      } else {
        return state.fullPath;
      }
    },
  );
}

// routes: {
//         '/': (context) => const LoginPageView(),
//         '/register': (context) => const RegisterPageView(),
//         '/home': (context) => const HomePageView(),
//         '/orderan': (context) => const OrderPop(),
//         // '/chat': ChatPage(),
//         // '/activity': ActivityPage(),
//       }