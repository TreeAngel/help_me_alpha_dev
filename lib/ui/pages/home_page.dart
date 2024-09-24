import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../data/cards_color.dart';
import '../../utils/manage_auth_token.dart';
import '../../blocs/home_blocs/home_bloc.dart';
import '../../configs/app_colors.dart';
import '../../data/menu_items_data.dart';
import '../../models/category_model.dart';
import '../../models/menu_item_model.dart';
import '../../ui/widgets/gradient_card.dart';
import '../../utils/logging.dart';
import '../../utils/show_dialog.dart';
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
    String username = 'Kamu!';

    return SafeArea(
      child: Scaffold(
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
                onRefresh: () async {
                  context.read<HomeBloc>().add(FetchProfile());
                },
                child: CustomScrollView(
                  slivers: <Widget>[
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    _appBarBlocBuilder(username, textTheme, colorScheme),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    _searchTextField(),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    _categoryTextHeader(textTheme),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    _categoryBlocBuilder(textTheme),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    _orderHistoryTextHeader(textTheme),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    _lastOrderHistory(textTheme),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    _logoutBlocBuilder(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BlocBuilder<AuthBloc, AuthState> _logoutBlocBuilder(
      BuildContext contextl) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is SignOutLoaded) {
          ManageAuthToken.deleteToken();
          context.goNamed('signInPage');
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  BlocBuilder<HomeBloc, HomeState> _appBarBlocBuilder(
    String username,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeInitial) {
          context.read<HomeBloc>().add(FetchProfile());
        } else if (state is ProfileLoaded) {
          username = state.user.user.username.toString();
          context.read<HomeBloc>().add(FetchCategories());
          return _homeAppBar(
            context,
            textTheme,
            colorScheme,
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
        return _homeAppBar(
          context,
          textTheme,
          colorScheme,
          username,
        );
      },
    );
  }

  BlocBuilder<HomeBloc, HomeState> _categoryBlocBuilder(TextTheme textTheme) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is CategoryLoaded) {
          final categories = state.categories.take(4).toList();
          return _categoriesGrid(categories, textTheme);
        } else if (state is CategoryError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ShowDialog.showAlertDialog(
              context,
              'Error fetching categories',
              state.errorMessage,
              IconButton.outlined(
                onPressed: () {
                  context.pop();
                  context.read<HomeBloc>().add(FetchCategories());
                },
                icon: const Icon(Icons.refresh_outlined),
              ),
            );
          });
        }
        return const SliverToBoxAdapter(
          child: SizedBox.shrink(),
        );
      },
    );
  }

  SliverGrid _categoriesGrid(
      List<CategoryModel> categories, TextTheme textTheme) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
      ),
      delegate: SliverChildBuilderDelegate(
        childCount: categories.length,
        (context, index) {
          final category = categories[index];
          final cardColor = index == 0 || index == 1
              ? CardsColor.categoryCardsColor[index]
              : AppColors.grey;
          return GestureDetector(
            onTap: () async {
              index == 0 || index == 1
                  ? context.pushNamed('detailPage', queryParameters: {
                      'categoryId': category.id.toString(),
                      'category': category.name,
                    })
                  : ShowDialog.showAlertDialog(
                      context,
                      'Fitur masih dikembangin',
                      'Ditunggu ya kakak! Fiturnya bakal hadir nanti',
                      null,
                    );
            },
            child: _categoryGridItem(
              category,
              textTheme,
              cardColor,
              index == 0 || index == 1
                  ? AppColors.lightTextColor
                  : AppColors.lightTextColor.withOpacity(0.5),
            ),
          );
        },
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
                ),
              )
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

  GradientCard _categoryGridItem(
    CategoryModel category,
    TextTheme textTheme,
    Color cardColor,
    Color textColor,
  ) {
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
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: category.name.replaceFirst(
                  category.name[0],
                  category.name[0].toUpperCase(),
                ),
                style: textTheme.titleLarge?.copyWith(
                  color: textColor,
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

  SliverAppBar _homeAppBar(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    String username,
  ) {
    return SliverAppBar(
      centerTitle: false,
      backgroundColor: Colors.black,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
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
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text.rich(
          TextSpan(
            text: 'Hi, ',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.darkTextColor,
            ),
            children: [
              TextSpan(
                text: username,
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.darkTextColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
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
