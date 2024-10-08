import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/fetch_offer/fetch_offer_bloc.dart';
import 'blocs/manage_order/manage_order_bloc.dart';
import 'cubits/home_cubit/home_cubit.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/send_order/send_order_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'configs/app_theme.dart';
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
    final imagePicker = ImagePickerUtil();
    ManageAuthToken.readToken();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(imagePickerUtil: imagePicker),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => SendOrderBloc(imagePickerUtil: imagePicker),
        ),
        BlocProvider(
          create: (context) => ManageOrderBloc(),
        ),
        BlocProvider(
          create: (context) => FetchOfferBloc(),
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
