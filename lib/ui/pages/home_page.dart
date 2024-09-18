import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_me_mitra_alpha_ver/blocs/home_blocs/home_bloc.dart';
import 'package:help_me_mitra_alpha_ver/data/menu_items_data.dart';

import '../../blocs/auth_blocs/auth_bloc.dart';
import '../../configs/app_colors.dart';
import '../../models/menu_item_model.dart';
import '../../utils/logging.dart';
import '../../utils/show_dialog.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    // final appTheme = Theme.of(context);
    // final textTheme = appTheme.textTheme;
    // final colorScheme = appTheme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String username = 'Unknown mitra';

    return Scaffold(
      body: Stack(
        children: [
          _homeHeaderBlocBuilder(screenWidth, screenHeight, username),
          _pageWhiteContainer(screenHeight, screenWidth),
          _orderanTextHeader(screenHeight),
          _orderanContainer(screenWidth, screenHeight),
          _riwayatTextHeader(screenHeight),
          _riwayatContainer(screenWidth, screenHeight),
          _saldoCard(screenWidth, screenHeight),
        ],
      ),
    );
  }

  Container _saldoCard(double screenWidth, double screenHeight) {
    return Container(
      margin: const EdgeInsets.only(
          top: 120, left: 20.0, right: 20.0), // Menambah margin top
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 24),
            width: screenWidth,
            height: screenHeight / 4.2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFDAFF79).withOpacity(0.8),
                  const Color(0xFF758D38).withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                const Positioned(
                  left: 20,
                  top: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Saldo",
                        style: TextStyle(
                            fontSize: 22.15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Abang",
                        style: TextStyle(
                          fontSize: 22.15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Rp0",
                        style: TextStyle(
                            fontSize: 22.15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 28),
                      Text(
                        "08x-xxx-xxx-xxx",
                        style: TextStyle(
                          fontSize: 22.15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    right: 0,
                    bottom: 138,
                    child: Container(
                      width: 60,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.0),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(19),
                        ),
                      ),
                    )),
                Positioned(
                    right: 30,
                    bottom: 165,
                    child: Container(
                      width: 65,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.0),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(19),
                        ),
                      ),
                    )),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: ClipPath(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.mitraGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _riwayatContainer(double screenWidth, double screenHeight) {
    return Container(
      margin: const EdgeInsets.only(
          top: 330, left: 25, right: 25), // Menambah margin top
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 300),
            width: screenWidth,
            height: screenHeight / 5.2,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.boxGreen,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(''),
            ),
          )
        ],
      ),
    );
  }

  Container _riwayatTextHeader(double screenHeight) {
    return Container(
        margin: EdgeInsets.only(top: screenHeight / 1.50, left: 25),
        child: const Text(
          "Riwayat",
          style: TextStyle(
            fontSize: 22.15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ));
  }

  Container _orderanContainer(double screenWidth, double screenHeight) {
    return Container(
      margin: const EdgeInsets.only(
          top: 107, left: 25, right: 25), // Menambah margin top
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 300),
            width: screenWidth,
            height: screenHeight / 5.2,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.boxGreen,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text('Tunggu orderan ya!'),
            ),
          )
        ],
      ),
    );
  }

  Container _orderanTextHeader(double screenHeight) {
    return Container(
        margin: EdgeInsets.only(top: screenHeight / 2.4, left: 25),
        child: const Text(
          "Orderan",
          style: TextStyle(
            fontSize: 22.15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ));
  }

  Container _pageWhiteContainer(double screenHeight, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 3.5),
      height: screenHeight,
      width: screenWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
    );
  }

  BlocBuilder _homeHeaderBlocBuilder(
    double screenWidth,
    double screenHeight,
    String username,
  ) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeInitial) {
          context.read<HomeBloc>().add(FetchProfile());
        } else if (state is ProfileLoaded) {
          username = state.user.user.username.toString();
          return _homeHeader(
            context,
            screenWidth,
            screenHeight,
            username,
          );
        } else if (state is ProfileError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ShowDialog.showAlertDialog(
              context,
              'Error fetching profile',
              state.errorMessage,
              IconButton.outlined(
                onPressed: () {
                  context.pop();
                  context.read<HomeBloc>().add(FetchProfile());
                },
                icon: const Icon(Icons.refresh_outlined),
              ),
            );
          });
        }
        return _homeHeader(
          context,
          screenWidth,
          screenHeight,
          username,
        );
      },
    );
  }

  Container _homeHeader(BuildContext context,
      double screenWidth, double screenHeight, String username,) {
    return Container(
      width: screenWidth,
      height: screenHeight / 2.7, // Sedikit lebih pendek
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      padding: const EdgeInsets.only(
          top: 50, left: 30, bottom: 0), // Memberikan padding untuk teks
      // alignment: Alignment.bottomLeft, // Posisi teks di bawah
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: "Hi, \n",
              style: const TextStyle(
                fontSize: 22.15,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "$username!",
                  style: const TextStyle(
                    fontSize: 35.62,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<MenuItemModel>(
            icon: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/girl1.png'), // TODO: Ganti ke NetwordkImage buat ambil profile image dari api
              radius: 100,
            ),
            tooltip: 'Menu',
            position: PopupMenuPosition.under,
            onSelected: (item) => _menuFunction(context, item),
            itemBuilder: (context) => [
              ...MenuItems.firstItems.map(_buildItem),
              const PopupMenuDivider(),
              ...MenuItems.secondItems.map(_buildItem),
            ],
          )
        ],
      ),
    );
  }

  PopupMenuItem<MenuItemModel> _buildItem(MenuItemModel item) =>
      PopupMenuItem<MenuItemModel>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon),
            const SizedBox(width: 10),
            Text(item.title),
          ],
        ),
      );

  void _menuFunction(BuildContext context, MenuItemModel item) {
    switch (item) {
      case MenuItems.itemHome:
        printInfo('You tap on home');
        break;
      case MenuItems.itemProfile:
        printInfo('You tap on profile');
        break;
      case MenuItems.itemOrderHistory:
        printInfo('You tap on order history');
        break;
      case MenuItems.itemSignIn:
        context.goNamed('signInPage');
        break;
      case MenuItems.itemSignOut:
        ShowDialog.showAlertDialog(
          context,
          'Sign Out',
          'Are you sure want to sign out?',
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(SignOutSubmitted());
            },
            child: const Text('Sign out'),
          ),
        );
        break;
      default:
        printError('What are you tapping? $item');
        break;
    }
  }
}
