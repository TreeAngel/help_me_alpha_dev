import 'package:go_router/go_router.dart';

import '../ui/pages/auth/forgot_password_page.dart';
import '../ui/pages/auth/form_data_mitra.dart';
import '../ui/pages/auth/verify_phone_number_page.dart';
import '../ui/pages/home/edit_profile_page.dart';
import '../ui/pages/home/profile_page.dart';
import '../ui/pages/home/selected_popup.dart';
import '../ui/pages/misc/launch_page.dart';
// import '../../ui/pages/track_maps_page.dart';
import '../services/api/api_controller.dart';
import '../ui/pages/home/home_page.dart';
import '../ui/pages/auth/sign_in_page.dart';
import '../ui/pages/auth/sign_up_page.dart';
import '../ui/pages/profile/change_password_page.dart';

class AppRoute {
  static final GoRouter appRoute = GoRouter(
    initialLocation: '/',
    routes: _routes,
    redirect: (context, state) {
      final isAuthenticated = ApiController.token != null ? true : false;
      // TODO: Add other guarded route later
      if (isAuthenticated == false && state.matchedLocation == '/home') {
        return '/signIn';
      }
      if (isAuthenticated == false && state.matchedLocation == '/profile') {
        return '/signIn';
      }
      if (isAuthenticated == false && state.matchedLocation == '/editProfile') {
        return '/signIn';
      }
      // if (isAuthenticated == false && state.matchedLocation == '/detail') {
      //   return '/signIn';
      // }
      if (isAuthenticated == true && state.matchedLocation == '/signIn') {
        return '/home';
      }
      if (isAuthenticated == true && state.matchedLocation == '/signUp') {
        return '/home';
      }
      return null;
    },
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
        builder: (context, state) => const FormDataMitraPage(),
      ),
      GoRoute(
        path: '/forgotPassword',
        name: 'forgotPasswordPage',
        builder: (context, state) => const ForgetPasswordPage(),
      ),
      GoRoute(
        path: '/verifyPhoneNumber',
        name: 'verifyPhoneNumberPage',
        builder: (context, state) => const VerifyPhoneNumberPage(),
      ),
      GoRoute(
        path: '/changePassword',
        name: 'changePasswordPage',
        builder: (context, state) => const ChangePasswordPage(),
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
