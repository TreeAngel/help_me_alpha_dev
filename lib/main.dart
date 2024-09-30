import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/home_bloc/home_cubit.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/order_bloc/order_bloc.dart';
import 'configs/app_theme.dart';
import 'services/api/api_controller.dart';
import 'utils/image_picker_util.dart';
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
    final ApiController apiHelper = ApiController();
    ManageAuthToken.readToken();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(apiController: apiHelper),
        ),
        BlocProvider(
          create: (context) => AuthBloc(apiController: apiHelper),
        ),
        BlocProvider(
          create: (context) => OrderBloc(
              apiController: apiHelper, imagePickerUtil: ImagePickerUtil()),
        ),
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
