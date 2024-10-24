import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log(
    '${message.data.keys}: ${message.data.values} || android: ${message.notification?.android}',
    name: 'Background notification from firebase',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );
  await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final imagePicker = ImagePickerUtil();
    ManageAuthToken.readToken();

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FirebaseMessaging.onMessage.listen((event) {
              RemoteNotification? notification = event.notification;
              AndroidNotification? android = notification?.android;
              if (notification != null && android != null) {
                _flutterLocalNotificationsPlugin.show(
                  notification.hashCode,
                  notification.title,
                  notification.body,
                  const NotificationDetails(
                    android: AndroidNotificationDetails(
                      'your_channel_id',
                      'your_channel_name',
                      importance: Importance.defaultImportance,
                      priority: Priority.defaultPriority,
                    ),
                  ),
                );
              }
            }));

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
