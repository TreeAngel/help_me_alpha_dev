import 'package:flutter/material.dart';
import 'package:help_me_mitra_alpha_ver/configs/app_colors.dart';
import 'package:help_me_mitra_alpha_ver/configs/app_theme.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/home_page.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/order_popup.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/register_page.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HelpMe | Mitra',
      theme: AppTheme.appTheme,
      home: OrderPop(),
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
