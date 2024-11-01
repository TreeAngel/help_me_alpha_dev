import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/home_/home_bloc.dart';
import 'cubits/profile/profile_cubit.dart';
import 'configs/app_route.dart';
import 'configs/app_theme.dart';
import 'firebase_options.dart';
import 'services/api/api_controller.dart';
import 'utils/manage_token.dart';
import 'utils/image_picker_util.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
    final apiController = ApiController();
    ManageAuthToken.readToken();
    ManageFCMToken.readToken();

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = notification?.android;
      if (notification != null && android != null) {
        localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              android.channelId ?? 'channel id',
              android.channelId ?? 'channel name',
              icon: '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.max,
            ),
          ),
        );
      }
    });

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(apiController: apiController),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(imagePickerUtil: imagePicker),
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
