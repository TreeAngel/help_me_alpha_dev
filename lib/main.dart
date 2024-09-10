import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_me_client_alpha_ver/blocs/category_blocs/category_bloc.dart';
import 'package:help_me_client_alpha_ver/blocs/sign_in_blocs/sign_in_bloc.dart';
import 'package:help_me_client_alpha_ver/configs/app_route.dart';
import 'package:help_me_client_alpha_ver/configs/app_theme.dart';
import 'package:help_me_client_alpha_ver/services/api_helper.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoryBloc(apiHelper: ApiHelper()),
        ),
        BlocProvider(
          create: (context) => SignInBloc(apiHelper: ApiHelper()),
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
