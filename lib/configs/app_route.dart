import 'package:go_router/go_router.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/forgot_password_page.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/form_data_mitra.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/launch_page.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/order_screen.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/selected_popup.dart';
// import 'package:help_me_mitra_alpha_ver/ui/pages/track_maps_page.dart';

import '../services/api/api_controller.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/sign_in_page.dart';
import '../ui/pages/sign_up_page.dart';

class AppRoute {
  static final GoRouter appRoute = GoRouter(
    initialLocation: '/',
    routes: _routes,
    redirect: (context, state) {
      final isAuthenticated = ApiController.token != null ? true : false;
      // TODO: Add other guarded route later
      if (isAuthenticated == false && state.matchedLocation == '/signIn') {
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

  static List<RouteBase> get _routes{
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
        path: '/formdatamitra',
        name: 'formDataMitraPage',
        builder: (context, state) => FormDataMitraPage(),
      ), 
      GoRoute(
        path: '/forgotPassword',
        name: 'forgotPasswordPage',
        builder: (context, state) => ForgotPasswordPage(),
      ),
      // GoRoute(
      //   path: '/order_page',
      //   name: 'orderPage',
      //   builder: (context, state) =>  OrderScreen(),
      // ),
      GoRoute(
        path: '/getselectedorder',
        name: 'selectedPop',
        builder: (context, state) => const SelectedPop(),
      ),
      // GoRoute(
      //   path: '/trackmaps',
      //   name: 'trackmapsPage',
      //   builder: (context, state) => const TrackMaps(),
      // ),
    ];
  }
}

// routes: {
//         '/': (context) => const LoginPageView(),
//         '/register': (context) => const RegisterPageView(),
//         '/home': (context) => const HomePageView(),
//         '/orderan': (context) => const OrderPop(),
//         // '/chat': ChatPage(),
//         // '/activity': ActivityPage(),
//       }