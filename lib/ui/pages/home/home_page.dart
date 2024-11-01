import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/menu_items_data.dart';
import '../../widgets/gradient_card.dart';
import 'selected_popup.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../models/misc/menu_item_model.dart';
import '../../../utils/logging.dart';
import '../../widgets/custom_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showInfo = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    // final colorScheme = appTheme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String username = 'Mitra';

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
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
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: RefreshIndicator(
                  onRefresh: () async {},
                  child: CustomScrollView(
                    slivers: <Widget>[
                      _homeHeader(
                        context,
                        textTheme,
                        username,
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      _saldoCard(textTheme, username),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      _orderanTextHeader(textTheme),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      _orderanContainer(context, textTheme),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      _riwayatTextHeader(textTheme),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      _riwayatContainer(textTheme),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _riwayatContainer(TextTheme textTheme) {
    return SliverToBoxAdapter(
      child: Container(
        width: 360,
        height: 161,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Center(
          child: Text(''),
        ),
      ),
    );
  }

  SliverToBoxAdapter _riwayatTextHeader(TextTheme textTheme) {
    return SliverToBoxAdapter(
      child: Text(
        "Riwayat",
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.lightTextColor,
        ),
      ),
    );
  }

  SliverToBoxAdapter _orderanContainer(
    BuildContext context,
    TextTheme textTheme,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        width: 360,
        height: 161,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            const Center(
              child: Text('To Soon list order'),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectedPop(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _orderanTextHeader(TextTheme textTheme) {
    return SliverToBoxAdapter(
      child: Text(
        "Orderan",
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.lightTextColor,
        ),
      ),
    );
  }

  SliverToBoxAdapter _saldoCard(TextTheme textTheme, String username) {
    return SliverToBoxAdapter(
      child: GradientCard(
        width: 360,
        height: 220,
        cardColor: AppColors.boxGreen,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 5),
              blurRadius: 10,
            ),
          ],
          gradient: LinearGradient(
            colors: [
              const Color(0xFFDAFF79).withOpacity(0.8),
              const Color(0xFF758D38).withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saldo',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.darkTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      showInfo = !showInfo;
                    }),
                    icon: Icon(
                      showInfo ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              Text(
                username,
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
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "08x-xxx-xxx-xxx",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22.15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Container(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _homeHeader(
    BuildContext context,
    TextTheme textTheme,
    String username,
  ) {
    return SliverAppBar(
      centerTitle: false,
      toolbarHeight: 75,
      title: RichText(
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
      actions: [
        PopupMenuButton<MenuItemModel>(
          icon: const CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/girl1.png',
            ), // TODO: Ganti ke NetwordkImage buat ambil profile image dari api
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
        ),
      ],
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
        CustomDialog.showAlertDialog(
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
