import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/category_blocs/category_bloc.dart';
import 'blocs/auth_blocs/auth_bloc.dart';
import 'configs/app_theme.dart';
import 'services/api/api_helper.dart';
import 'utils/manage_auth_token.dart';
import 'configs/app_route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiHelper apiHelper = ApiHelper();
    ManageAuthToken.readToken();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoryBloc(apiHelper: apiHelper),
        ),
        BlocProvider(
          create: (context) => AuthBloc(apiHelper: apiHelper),
        )
        // TODO: Add other blocs here
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        routerConfig: AppRoute.appRoute,
      ),
    );
  }
}
