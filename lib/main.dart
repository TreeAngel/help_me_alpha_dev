import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/fetch_offer/fetch_offer_bloc.dart';
import 'blocs/manage_order/manage_order_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/send_order/send_order_bloc.dart';
import 'configs/app_route.dart';
import 'configs/app_theme.dart';
import 'cubits/detail_order/detail_order_cubit.dart';
import 'cubits/home/home_cubit.dart';
import 'firebase_options.dart';
import 'utils/image_picker_util.dart';
import 'utils/manage_token.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        BlocProvider(
          create: (context) => DetailOrderCubit(imagePickerUtil: imagePicker),
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
