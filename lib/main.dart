import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_me_client_alpha_ver/blocs/category_blocs/category_bloc.dart';
import 'package:help_me_client_alpha_ver/configs/app_theme.dart';
import 'package:help_me_client_alpha_ver/services/api_helper.dart';
import 'package:help_me_client_alpha_ver/ui/pages/home_page.dart';

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
        // TODO: Add other blocs here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: const HomePage(),
      ),
    );
  }
}
