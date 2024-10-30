import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_me_mitra_alpha_ver/blocs/fetch_order/fetch_order_bloc.dart';
import 'package:help_me_mitra_alpha_ver/services/firebase/firebase_api.dart';
import 'package:help_me_mitra_alpha_ver/services/firebase/firebase_messaging_service.dart';

import 'blocs/home_blocs/home_bloc.dart';
import 'blocs/auth_blocs/auth_bloc.dart';
import 'configs/app_theme.dart';
import 'services/api/api_controller.dart';
import 'utils/manage_auth_token.dart';
import 'configs/app_route.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ini akan menangani pesan background
  print('Handling a background message: ${message.messageId}');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  
  // Setup background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Setup notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Buat instance FetchOrderBloc
  final fetchOrderBloc = FetchOrderBloc();

  // Inisialisasi FirebaseMessagingService dengan FetchOrderBloc
  FirebaseMessagingService(fetchOrderBloc: fetchOrderBloc);

  runApp(const MainApp());
}



class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiController apiController = ApiController();
    ManageAuthToken.readToken();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(apiController: apiController),
        ),
        BlocProvider(
          create: (context) => AuthBloc(apiController: apiController),
        ),
        BlocProvider.value(value: FetchOrderBloc()),
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

// class MainPage extends StatefulWidget {
//   @override
//   _MainPageState createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int _selectedIndex = 0; // Menyimpan index halaman yang dipilih

//   // Daftar halaman yang akan ditampilkan
//   final List<Widget> _pages = [
//     // LoginPageView(),
//     OrderPop(),
//     // HomeViewPage(),
//     // ChatPage(),
//     // ActivityPage(),
//   ];

//   void _onDestinationSelected(int index) {
//     setState(() {
//       _selectedIndex = index; // Update selectedIndex saat menu di klik
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex], // Menampilkan halaman berdasarkan selectedIndex
//       bottomNavigationBar: ClipRRect(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//         child: NavigationBar(
//           height: 70,
//           backgroundColor: Colors.black,
//           indicatorColor: AppColors.leavesGreen,
//           selectedIndex: _selectedIndex,
//           onDestinationSelected: _onDestinationSelected, // Fungsi saat menu di klik
//           labelBehavior: NavigationDestinationLabelBehavior.alwaysHide, // Sembunyikan label
//           destinations: [
//             NavigationDestination(
//               icon: Icon(
//                 Icons.grid_view,
//                 color: _selectedIndex == 0 ? Colors.white : Colors.white, // Kondisi warna berdasarkan selectedIndex
//               ),
//               label: '',
//             ),
//             NavigationDestination(
//               icon: Icon(
//                 Icons.chat,
//                 color: _selectedIndex == 1 ? Colors.white : Colors.white, // Kondisi warna berdasarkan selectedIndex
//               ),
//               label: '',
//             ),
//             NavigationDestination(
//               icon: Icon(
//                 Icons.assignment,
//                 color: _selectedIndex == 2 ? Colors.white : Colors.white, // Kondisi warna berdasarkan selectedIndex
//               ),
//               label: '',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
