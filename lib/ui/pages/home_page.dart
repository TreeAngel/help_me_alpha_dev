import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_me_mitra_alpha_ver/blocs/fetch_order/fetch_order_bloc.dart';
import 'package:help_me_mitra_alpha_ver/blocs/fetch_order/fetch_order_event.dart';
import 'package:help_me_mitra_alpha_ver/blocs/fetch_order/fetch_order_state.dart';
import 'package:help_me_mitra_alpha_ver/blocs/home_blocs/home_bloc.dart';
import 'package:help_me_mitra_alpha_ver/data/menu_items_data.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/form_data_mitra.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/order_screen.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/selected_popup.dart';

import '../../blocs/auth_blocs/auth_bloc.dart';
import '../../configs/app_colors.dart';
import '../../models/menu_item_model.dart';
import '../../utils/logging.dart';
import '../../utils/show_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final colorScheme = appTheme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String username = 'Mitra';

    return Scaffold(
      body: Stack(
        children: [
          _homeHeaderBlocBuilder(screenWidth, screenHeight, username),
          _pageWhiteContainer(screenHeight, screenWidth),
          _orderanTextHeader(screenHeight),
          _orderanContainer(screenWidth, screenHeight, context),
          _riwayatTextHeader(screenHeight),
          _riwayatContainer(screenWidth, screenHeight),
          _saldoCard(screenWidth, screenHeight, username,)
        ],
      ),
    );
  }

  Container _saldoCard(double screenWidth, double screenHeight, String username,) {
    return Container(
      margin: const EdgeInsets.only(
          top: 100, left: 20.0, right: 20.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 35),
            width: screenWidth,
            height: screenHeight / 3.8,
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
                Positioned(
                  left: 20,
                  top: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Saldo",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22.15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        "$username",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22.15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "Rp0",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22.15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 28),
                      Text(
                        "08x-xxx-xxx-xxx",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22.15,
                          fontWeight: FontWeight.normal,
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
                  ),
                ),
                Positioned(
                  right: 15,
                  bottom: 15,
                  child: ClipPath(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Icon(
                        Icons.east,
                        color: AppColors.leavesGreen,
                        size: 20,
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
          top: 365, left: 25, right: 25),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 300),
            width: screenWidth,
            height: screenHeight / 5.4,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.mitraGreen,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(25),
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
        margin: EdgeInsets.only(top: screenHeight / 1.41, left: 25),
        child: Text(
          "Riwayat",
          style: GoogleFonts.poppins(
            fontSize: 22.15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        )
    );
  }

  Container _orderanContainer(double screenWidth, double screenHeight, context) {
    return Container(
      margin: const EdgeInsets.only(
          top: 130, left: 25, right: 25),
      child: Column(
        children: [
          // Menggunakan BlocBuilder untuk mendapatkan data orders dari API
          BlocBuilder<FetchOrderBloc, FetchOrderState>(
            builder: (context, state) {
              if (state is FetchOrderLoadingState) {
                // Jika loading, tampilkan loading indicator
                return Center(child: CircularProgressIndicator());
              } else if (state is FetchOrderLoadedState) {
                // Jika data berhasil di-load, tampilkan dalam list
                return Column(
                  children: state.orders.map((order) {
                    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: screenWidth,
                      height: screenHeight / 5.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.mitraGreen,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ListTile(
                        title: Text(order.problem ?? 'Problem', style: GoogleFonts.poppins(fontSize: 15)),
                        subtitle: Text(order.latitude ?? 'latitude', style: GoogleFonts.poppins(fontSize: 12)),
                        onTap: () {
                          // Arahkan ke halaman detail order
                          context.read<FetchOrderBloc>().add(FetchOrderDetailEvent(order.orderId ?? 44));
                          Navigator.pushNamed(context, '/order_page', arguments: order.orderId);
                        },
                      ),
                    );
                  }).toList(),
                );
              } else if (state is FetchOrderErrorState) {
                // Jika ada error, tampilkan pesan error
                return Center(child: Text('Error: ${state.error}', style: GoogleFonts.poppins(fontSize: 15)));
              } else {
                // Jika tidak ada data, tampilkan pesan kosong
                return Center(
                  child: Text(
                    'Tunggu orderan ya!',
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                );
              }
            },
          ),
          
          // ICON BUTTON UNTUK JALAN PINTAS KE ORDERAN (dev mode)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                iconSize: 30,
                color: Colors.red,
                onPressed: () {
                  // Navigator ke OrderScreen atau halaman lain (dev mode)
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                iconSize: 30,
                color: Colors.black,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SelectedPop()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _orderanTextHeader(double screenHeight) {
    return Container(
        margin: EdgeInsets.only(top: screenHeight / 2.23, left: 25),
        child: Text(
          "Orderan",
          style: GoogleFonts.poppins(
            fontSize: 22.15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        )
    );
  }

  Container _pageWhiteContainer(double screenHeight, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 3.32),
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
      height: screenHeight / 2.5, 
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      padding: const EdgeInsets.only(
           left: 30, right: 25, bottom: 170),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: "Hi,\n",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22.15,
                fontWeight: FontWeight.normal,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "$username!",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 35.62,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<MenuItemModel>(
            icon: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/girl1.png'), // TODO: Ganti ke NetwordkImage buat ambil profile image dari api
              radius: 22,
            ),
            tooltip: 'Menu',
            position: PopupMenuPosition.under,
            onSelected: (item) => _appBarMenuFunction(context, item),
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

    void _appBarMenuFunction(BuildContext context, MenuItemModel item) {
    switch (item) {
      case MenuItems.itemProfile:
        context.pushNamed('profilePage');
        break;
      case MenuItems.itemSignOut:
        ShowDialog.showAlertDialog(
          context,
          'Sign Out',
          'Are you sure want to sign out?',
          OutlinedButton(
            onPressed: () {
              context.pop();
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
