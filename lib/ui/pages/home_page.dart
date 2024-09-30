import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../services/api/api_controller.dart';
import '../../data/cards_color.dart';
import '../../models/order_history_model.dart';
import '../../utils/manage_auth_token.dart';
import '../../blocs/home_bloc/home_cubit.dart';
import '../../configs/app_colors.dart';
import '../../data/menu_items_data.dart';
import '../../models/category_model.dart';
import '../../models/menu_item_model.dart';
import '../../ui/widgets/gradient_card.dart';
import '../../utils/logging.dart';
import '../../utils/show_dialog.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/auth_bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final colorScheme = appTheme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String username = 'Kamu!';
    List<CategoryModel> categories = [];
    List<OrderHistoryModel> orderHistory = [];

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
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    _onSignOutError(context, state);
                  }
                  if (state is SignOutLoaded) {
                    ManageAuthToken.deleteToken();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.goNamed('signInPage');
                    });
                  }
                },
                child: RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: () async {
                    context.read<HomeCubit>().fetchProfile();
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
                      _categoryBlocBuilder(textTheme, categories),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      _orderHistoryTextHeader(textTheme),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      _lastHistoryBlocBuilder(textTheme, orderHistory),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
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

  BlocBuilder<HomeCubit, HomeState> _lastHistoryBlocBuilder(
    TextTheme textTheme,
    List<OrderHistoryModel> orderHistory,
  ) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        OrderHistoryModel? lastHistory;
        if (state is OrderHistoryLoaded) {
          orderHistory.addAll(state.history);
          lastHistory = orderHistory.last;
          context.read<HomeCubit>().fetchCategories();
          return _orderHistoryCard(lastHistory, textTheme);
        } else if (state is OrderHistoryError) {
          _onOrderHistoryError(context, state);
        }
        if (orderHistory.isNotEmpty) {
          lastHistory = orderHistory.last;
        }
        return _orderHistoryCard(lastHistory, textTheme);
      },
    );
  }

  void _onOrderHistoryError(BuildContext context, OrderHistoryError state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowDialog.showAlertDialog(
        context,
        'Error fetching order history',
        state.errorMessage,
        state.errorMessage.toString().toLowerCase().contains('unauthorized')
            ? OutlinedButton.icon(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ManageAuthToken.deleteToken();
                    context.read<AuthBloc>().add(RetryAuthState());
                    context.goNamed('signInPage');
                  });
                },
                label: const Text('Sign In ulang'),
                icon: const Icon(Icons.arrow_forward_ios),
                iconAlignment: IconAlignment.end,
              )
            : IconButton.outlined(
                onPressed: () {
                  context.pop();
                  context.read<HomeCubit>().fetchHistory('');
                },
                icon: const Icon(Icons.refresh_outlined),
              ),
      );
    });
  }

  void _onSignOutError(BuildContext context, AuthError state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowDialog.showAlertDialog(
        context,
        'Error Sing Out',
        state.errorMessage.toString(),
        state.errorMessage.toString().toLowerCase().contains('unauthorized')
            ? OutlinedButton.icon(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ManageAuthToken.deleteToken();
                    context.read<AuthBloc>().add(RetryAuthState());
                    context.goNamed('signInPage');
                    context.pop();
                  });
                },
                label: const Text('Sign In ulang'),
                icon: const Icon(Icons.arrow_forward_ios),
                iconAlignment: IconAlignment.end,
              )
            : null,
      );
      context.read<AuthBloc>().add(ResetAuthState());
    });
  }

  BlocBuilder<HomeCubit, HomeState> _appBarBlocBuilder(
    String username,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeInitial) {
          context.read<HomeCubit>().fetchProfile();
          // context.read<HomeCubit>().add(FetchCategories());
          // context.read<HomeCubit>().add(const FetchHistory(''));
        } else if (state is ProfileLoaded) {
          username = state.user.user.username.toString();
          // context.read<HomeCubit>().add(FetchCategories());
          context.read<HomeCubit>().fetchHistory('');
          return _homeAppBar(
            context,
            textTheme,
            colorScheme,
            username,
          );
        } else if (state is ProfileError) {
          _onProfileError(context, state);
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

  void _onProfileError(BuildContext context, ProfileError state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowDialog.showAlertDialog(
        context,
        'Error fetching profile',
        state.errorMessage,
        state.errorMessage.toString().toLowerCase().contains('unauthorized')
            ? OutlinedButton.icon(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ManageAuthToken.deleteToken();
                    context.read<AuthBloc>().add(RetryAuthState());
                    context.goNamed('signInPage');
                  });
                },
                label: const Text('Sign In ulang'),
                icon: const Icon(Icons.arrow_forward_ios),
                iconAlignment: IconAlignment.end,
              )
            : IconButton.outlined(
                onPressed: () {
                  context.pop();
                  context.read<HomeCubit>().fetchProfile();
                },
                icon: const Icon(Icons.refresh_outlined),
              ),
      );
    });
  }

  BlocBuilder<HomeCubit, HomeState> _categoryBlocBuilder(
    TextTheme textTheme,
    List<CategoryModel> categories,
  ) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is CategoryLoaded) {
          categories.addAll(state.categories.take(4).toList());
          // context.read<HomeCubit>().add(const FetchHistory(''));
          return _categoriesGrid(categories, textTheme);
        } else if (state is CategoryError) {
          _onCategoryError(context, state);
        }
        return _categoriesGrid(categories, textTheme);
      },
    );
  }

  void _onCategoryError(BuildContext context, CategoryError state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowDialog.showAlertDialog(
        context,
        'Error fetching categories',
        state.errorMessage,
        state.errorMessage.toString().toLowerCase().contains('unauthorized')
            ? OutlinedButton.icon(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ManageAuthToken.deleteToken();
                    context.goNamed('signInPage');
                  });
                },
                label: const Text('Sign In ulang'),
                icon: const Icon(Icons.arrow_forward_ios),
                iconAlignment: IconAlignment.end,
              )
            : IconButton.outlined(
                onPressed: () {
                  context.pop();
                  context.read<HomeCubit>().fetchProfile();
                },
                icon: const Icon(Icons.refresh_outlined),
              ),
      );
    });
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

  SliverToBoxAdapter _orderHistoryCard(
    OrderHistoryModel? history,
    TextTheme textTheme,
  ) {
    return SliverToBoxAdapter(
      child: GradientCard(
        width: 400,
        height: 240,
        cardColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _orderCardHistoryInfoSection(history, textTheme),
              _orderCardHistoryImageSection(history),
            ],
          ),
        ),
      ),
    );
  }

  Stack _orderCardHistoryImageSection(OrderHistoryModel? history) {
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
          child: CircleAvatar(
            child: history != null
                ? CachedNetworkImage(
                    imageUrl:
                        '${ApiController.temporaryUrl}/${history.userProfile}',
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                    ),
                  )
                : Image.asset('assets/images/girl1.png'),
          ),
        ),
      ],
    );
  }

  Column _orderCardHistoryInfoSection(
    OrderHistoryModel? history,
    TextTheme textTheme,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LimitedBox(
          maxWidth: 310,
          child: Text(
            history != null
                ? 'Category'
                : 'Kamu belum minta bantuan sama sekali', // TODO: Get problem Category from API
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        LimitedBox(
            maxWidth: 310,
            child: Text(
              history != null
                  ? '${history.description}'
                  : 'Jangan lupa cari bantuan di HelpMe!',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.aquamarine,
              ),
            )),
        Text(
          history != null ? 'Rp5.000' : 'N/A',
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
