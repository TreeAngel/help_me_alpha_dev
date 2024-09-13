import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:help_me_client_alpha_ver/utils/manage_auth_token.dart';

import '../../blocs/category_blocs/category_bloc.dart';
import '../../configs/app_colors.dart';
import '../../data/menu_items_data.dart';
import '../../models/category_model.dart';
import '../../models/menu_item_model.dart';
import '../../ui/widgets/gradient_card.dart';
import '../../utils/logging.dart';
import '../../utils/show_alert_dialog.dart';
import '../../blocs/auth_blocs/auth_bloc.dart';
import '../../blocs/auth_blocs/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final colorScheme = appTheme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: _homeAppBar(context, textTheme, colorScheme),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              width: screenWidth,
              child: Container(
                height: 440,
                color: Colors.black,
              ),
            ),
            Positioned.fill(
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                color: AppColors.primary,
                onRefresh: () async {
                  context.read<CategoryBloc>().add(
                      FetchCategories()); // TODO: Implement other future fetching from api
                },
                child: CustomScrollView(
                  slivers: <Widget>[
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    _searchTextField(),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    _categoryTextHeader(textTheme),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    _categoriesGrid(textTheme),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    _orderHistoryTextHeader(textTheme),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    _lastOrderHistory(textTheme),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is SignOutLoaded) {
                          ShowAlertDialog.showAlertDialog(
                            context,
                            'Berhasil',
                            'Anda berhasil sign out',
                            null,
                          );
                          ManageAuthToken.deleteToken();
                          // context.goNamed('signInPage');
                        }
                      },
                      child: const SliverToBoxAdapter(child: SizedBox.shrink()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _lastOrderHistory(TextTheme textTheme) {
    return SliverToBoxAdapter(
      child: GradientCard(
        width: 400,
        height: 220,
        cardColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _orderCardHistoryInfoSection(textTheme),
              _orderCardHistoryImageSection(),
            ],
          ),
        ),
      ),
    );
  }

  Stack _orderCardHistoryImageSection() {
    return Stack(
      children: [
        Container(
          height: 162,
          width: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Image.asset(
            'assets/images/girl1.png',
            width: 40,
            isAntiAlias: true,
          ),
        ),
      ],
    );
  }

  Column _orderCardHistoryInfoSection(TextTheme textTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                    'Kunci Hilang\n', // TODO: Get problem subCategory from API
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                  text:
                      'Masalah Kendaraan', // TODO: Get problem category from API
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.aquamarine,
                  ))
            ],
          ),
        ),
        Text(
          'Rp5.000',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            printInfo('You tap on detail order');
          },
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(
              AppColors.primary,
            ),
            textStyle: WidgetStatePropertyAll(
              textTheme.bodyMedium?.copyWith(
                color: AppColors.lightTextColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          icon: const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.lightTextColor,
            size: 20,
          ),
          iconAlignment: IconAlignment.end,
          label: const Text('Lihat Riwayat'), // TODO: Implement detail order
        )
      ],
    );
  }

  SliverToBoxAdapter _orderHistoryTextHeader(TextTheme textTheme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Riwayat Masalah',
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.lightTextColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            GestureDetector(
              onTap: () {
                printInfo('You tap on all order history');
              }, // TODO: Implement all order history page
              child: Text(
                'Lihat Semua',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.lightTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _categoriesGrid(TextTheme textTheme) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryInitial) {
          context.read<CategoryBloc>().add(FetchCategories());
          return const SliverFillRemaining(
            child: Center(
              child: SizedBox.shrink(),
            ),
          );
        } else if (state is CategoryLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        } else if (state is CategoryLoaded) {
          final categories = state.categories.take(4).toList();
          final colorOption = Options(
            format: Format.hex,
            luminosity: Luminosity.light,
            count: categories.length,
          );
          final randomColors = RandomColor.getColor(colorOption);
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              childCount: categories.length,
              (context, index) {
                final category = categories[index];
                final randomColor = randomColors[index];
                final color = randomColor.toString().substring(1);
                final cardColor = Color(int.parse('0xFF$color'));
                return GestureDetector(
                  onTap: () {
                    printInfo('You tap on ${category.name}');
                  },
                  child: _categoryGridItem(category, textTheme, cardColor),
                );
              },
            ),
          );
        } else if (state is CategoryError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ShowAlertDialog.showAlertDialog(
              context,
              'Error',
              state.errorMessage,
              null,
            );
            context.read<CategoryBloc>().add(FetchCategories());
          });
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  GradientCard _categoryGridItem(
      CategoryModel category, TextTheme textTheme, Color cardColor) {
    return GradientCard(
      width: 175,
      height: 210,
      cardColor: cardColor,
      child: Center(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Bantuan\n',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: category.name.replaceFirst(
                  category.name[0],
                  category.name[0].toUpperCase(),
                ),
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _categoryTextHeader(TextTheme textTheme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kategori',
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.darkTextColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            GestureDetector(
              onTap: () {
                printInfo('You tap on all categories');
              }, // TODO: Implement all categories page
              child: SvgPicture.asset('assets/icons/option.svg'),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _searchTextField() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          width: 360,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Icon(
                Icons.search,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Ceritakan masalahmu disini!',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _homeAppBar(
      BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.black,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: PopupMenuButton<MenuItemModel>(
            icon: SvgPicture.asset('assets/icons/menu.svg'),
            tooltip: 'Menu',
            position: PopupMenuPosition.under,
            onSelected: (item) => _appBarMenuFunction(context, item),
            itemBuilder: (context) => [
              ...MenuItems.firstItems.map(_buildItem),
              const PopupMenuDivider(),
              ...MenuItems.secondItems.map(_buildItem),
            ],
          ),
        ),
      ],
      title: Text.rich(
        TextSpan(
          text: 'Hi, ',
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.darkTextColor,
          ),
          children: [
            TextSpan(
              text: 'John Doe', // TODO: Get client username from API
              style: textTheme.displaySmall?.copyWith(
                color: AppColors.darkTextColor,
              ),
            )
          ],
        ),
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
      case MenuItems.itemHome:
        printInfo('You tap on home');
        break;
      case MenuItems.itemProfile:
        printInfo('You tap on profile');
        break;
      case MenuItems.itemOrderHistory:
        printInfo('You tap on order history');
        break;
      case MenuItems.itemCategories:
        printInfo('You tap on categories');
        break;
      case MenuItems.itemSignIn:
        context.goNamed('signInPage');
        break;
      case MenuItems.itemSignOut:
        ShowAlertDialog.showAlertDialog(
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
