import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../cubits/home/home_cubit.dart';
import '../../../cubits/order/order_cubit.dart';
import '../../../cubits/profile/profile_cubit.dart';
import '../../../data/menu_items_data.dart';
import '../../../models/misc/menu_item_model.dart';
import '../../../models/order/order_recieved.dart';
import '../../../services/api/api_controller.dart';
import '../../../services/firebase/firebase_api.dart';
import '../../../services/location_service.dart';
import '../../../utils/logging.dart';
import '../../../utils/manage_token.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/gradient_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool showInfo = false;
  String username = 'Kamu!';
  String orderContainerText = 'Kamu belum nyelesain orderan!';

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = notification?.android;
      if (notification != null && android != null) {
        if (notification.title!.trim().toLowerCase().contains('new order')) {
          final data = message.data;
          if (data.isNotEmpty && context.mounted) {
            context.read<OrderCubit>().receivingOrder(
                  OrderReceived.fromMap(data),
                );
            log(
              context.read<OrderCubit>().incomingOrder.toString(),
              name: 'Order masuk',
            );
          }
        }
      }
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop == true) {
          context.read<HomeCubit>().disposeHome();
          context.read<ProfileCubit>().profileDisposed();
        }
      },
      child: SafeArea(
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
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      _signOutError(context, state);
                    }
                    if (state is SignOutLoaded) {
                      if (state.message.isNotEmpty) {
                        CustomDialog.showAlertDialog(
                          context,
                          'Sign Out',
                          state.message,
                          TextButton(
                            onPressed: () {
                              context.read<HomeCubit>().disposeHome();
                              context.read<ProfileCubit>().profileDisposed();
                              context.goNamed('signInPage');
                            },
                            child: const Text('Lanjut'),
                          ),
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<ProfileCubit>().fetchProfile();
                          context.read<HomeCubit>().fetchCategories();
                        },
                        child: CustomScrollView(
                          slivers: <Widget>[
                            _homeHeaderConsumer(username, textTheme),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 20),
                            ),
                            _balanceCardBuilder(textTheme, username),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 10),
                            ),
                            _orderanTextHeader(textTheme),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 10),
                            ),
                            _orderanContainer(context, textTheme),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 10),
                            ),
                            _riwayatTextHeader(textTheme),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 10),
                            ),
                            _riwayatContainer(textTheme),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 10),
                            ),
                            SliverToBoxAdapter(
                              child: ElevatedButton(
                                onPressed: () => context.pushNamed(
                                  'sendOfferPage',
                                  queryParameters: {
                                    'orderId': '1',
                                    'distance': '4.2',
                                    'problem': 'debug',
                                    'category': 'debug',
                                    'attachments':
                                        'http://103.49.239.32/storage/images/orders/14/cb298b3a-59f6-406e-ada8-8088114c560c.jpg, http://103.49.239.32/storage/images/orders/14/30a8f396-9a7f-4769-931f-4a57705425b1.jpg',
                                  },
                                ),
                                child: const Text('Cek send offer page'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<ProfileCubit, ProfileState> _balanceCardBuilder(
      TextTheme textTheme, String username) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        String saldo = '';
        String phoneNumber = '08xxxxxxxxxx';
        if (state is ProfileLoaded) {
          saldo = state.userProfile.user.balance.toString();
          phoneNumber = state.userProfile.user.phoneNumber ?? phoneNumber;
        }
        return _saldoCard(
          textTheme,
          username,
          saldo,
          phoneNumber,
        );
      },
    );
  }

  BlocConsumer _homeHeaderConsumer(String username, TextTheme textTheme) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          context.read<ProfileCubit>().userProfile = state.userProfile.user;
          context.read<ProfileCubit>().fetchMitra();
          if (state.userProfile.user.username != null) {
            username = state.userProfile.user.username.toString();
          }
        }
        if (state is MitraLoaded) {
          final data = state.mitra;
          context.read<ProfileCubit>().userMitra = data;
          context.read<ProfileCubit>().mitraName = data.name;
          context.read<ProfileCubit>().mitraLocation = GeoPoint(
            latitude: data.latitude ?? 0,
            longitude: data.longitude ?? 0,
          );
          context.read<ProfileCubit>().helpers = data.helpers ?? [];
          if (state.mitra.isVerified == 0) {
            CustomDialog.showAlertDialog(
              context,
              'Peringatan!',
              'Anda belum terverifikasi sebagai mitra kami, harap tunggu maksimal 3 hari sampai kami memverifikasi semua data anda. Selama anda belum terverifikasi, anda tidak akan menerima order dari client. Jika sudah melebihi 3 hari silahkan hubungi pihak CS kami untuk penanganan lebih lanjut',
              null,
            );
          }
        }
        if (state is ProfileError) {
          if (state.errorMessage
              .toLowerCase()
              .trim()
              .contains('number is not verified')) {
            CustomDialog.showAlertDialog(
              context,
              'Verifikasi nomor!',
              'Verifikasi nomor telpon anda di page profile sebelum lanjut',
              null,
            );
          } else if (state.errorMessage
              .trim()
              .toLowerCase()
              .contains('mitra not found')) {
            CustomDialog.showAlertDialog(
              context,
              'Peringatan!',
              'Anda belum mengisi data mitra, tolong isi informasi mitra anda di page profile segera!',
              null,
            );
          } else {
            _onProfileError(context, state);
          }
        }
      },
      builder: (context, state) {
        if (state is ProfileDisposed && ApiController.token != null) {
          context.read<ProfileCubit>().profileInit();
        }
        if (state is ProfileInitial) {
          context.read<ProfileCubit>().fetchProfile();
          context.read<HomeCubit>().fetchCategories();
          _requestPermission(context);
        }
        return _homeHeader(
          context,
          textTheme,
          username,
        );
      },
    );
  }

  void _requestPermission(BuildContext context) {
    return WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locationPermission = await LocationService.setPermission();
      if (locationPermission is String && locationPermission.isNotEmpty) {
        context.mounted
            ? CustomDialog.showAlertDialog(
                context,
                'Peringatan!',
                locationPermission,
                null,
              )
            : null;
      }
      final notificationPermission = await FirebaseMessagingApi.setPermission();
      if (notificationPermission is String &&
          notificationPermission.isNotEmpty) {
        context.mounted
            ? CustomDialog.showAlertDialog(
                context,
                'Peringatan!',
                notificationPermission,
                null,
              )
            : null;
      }
    });
  }

  void _onProfileError(BuildContext context, ProfileError state) {
    CustomDialog.showAlertDialog(
      context,
      'Error fetching profile',
      state.errorMessage,
      state.errorMessage.toString().toLowerCase().contains('unauthorized')
          ? OutlinedButton.icon(
              onPressed: () {
                ManageAuthToken.deleteToken();
                context.read<AuthBloc>().add(AuthIsIdle());
                context.pop();
                context.goNamed('signInPage');
              },
              label: const Text('Sign In ulang'),
              icon: const Icon(Icons.arrow_forward_ios),
              iconAlignment: IconAlignment.end,
            )
          : IconButton.outlined(
              onPressed: () {
                context.pop();
                context.read<ProfileCubit>().fetchProfile();
              },
              icon: const Icon(Icons.refresh_outlined),
            ),
    );
  }

  void _signOutError(BuildContext context, AuthError state) {
    CustomDialog.showAlertDialog(
      context,
      'Error Sing Out',
      state.message.toString(),
      state.message.toString().toLowerCase().contains('unauthorized')
          ? OutlinedButton.icon(
              onPressed: () {
                ManageAuthToken.deleteToken();
                context.read<AuthBloc>().add(AuthIsIdle());
                context.pop();
                context.goNamed('signInPage');
              },
              label: const Text('Sign In ulang'),
              icon: const Icon(Icons.arrow_forward_ios),
              iconAlignment: IconAlignment.end,
            )
          : null,
    );
    context.read<AuthBloc>().add(ResetAuthState());
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
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is CategoryLoaded) {
              context.read<HomeCubit>().categories = state.categories;
              context.read<HomeCubit>().fetchHistory(status: 'complete');
            }
            if (state is OrderHistoryLoaded) {
              context.read<HomeCubit>().orderHistory = state.histories;
              if (state.histories.isEmpty) {
                orderContainerText = 'Kamu belum nyelesain orderan!';
              }
              context.read<HomeCubit>().homeIdle();
            }
            if (state is OrderHistoryError) {
               if (state.message
                  .toLowerCase()
                  .trim()
                  .contains('number is not verified')) {
                CustomDialog.showAlertDialog(
                  context,
                  'Verifikasi nomor!',
                  'Verifikasi nomor telpon anda di page profile sebelum lanjut',
                  null,
                );
              }
              orderContainerText = state.message;
              context.read<HomeCubit>().homeIdle();
            }
          },
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is HomeDispose && ApiController.token != null) {
              context.read<HomeCubit>().homeInit();
            }
            if (context.read<HomeCubit>().orderHistory.isNotEmpty) {
              return ListView.builder(
                itemCount: context.read<HomeCubit>().orderHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = context.read<HomeCubit>().orderHistory[index];
                  return _orderListTile(
                    textTheme: textTheme,
                    description: order.description!,
                    image: order.userProfile ?? 'assets/images/man1.png',
                    orderTime: order.orderTime,
                  );
                },
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    orderContainerText,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.lightTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  ListTile _orderListTile({
    required TextTheme textTheme,
    String? image,
    required String description,
    String? orderTime,
    String? orderDistance,
  }) {
    return ListTile(
      style: ListTileStyle.list,
      leading: CircleAvatar(
        backgroundImage: image != null
            ? CachedNetworkImageProvider(image)
            : const AssetImage('assets/images/man1.png'),
      ),
      title: Text(
        description.toString(),
        style: textTheme.bodyLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        orderTime ?? orderDistance!,
        style: textTheme.bodyMedium?.copyWith(
          color: AppColors.lightTextColor,
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
        child: BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state is ReceivingOrder) {
              context.read<OrderCubit>().orderIsIdle();
            }
            if (state is AvailableOrderLoaded) {
              context.read<OrderCubit>().incomingOrder = state.orders;
              context.read<OrderCubit>().orderIsIdle();
            }
          },
          builder: (context, state) {
            if (LocationService.lat == null && LocationService.long == null) {
              LocationService.fetchLocation(context);
            }
            if (context.read<OrderCubit>().incomingOrder.isEmpty) {
              context.read<OrderCubit>().getAvailableOrder();
            }
            if (state is! AvailableOrderError) {
              return ListView.builder(
                itemCount: context.read<OrderCubit>().incomingOrder.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = context.read<OrderCubit>().incomingOrder[index];
                  return _orderListTile(
                    textTheme: textTheme,
                    description: order.description!,
                    image: order.attachments?.first ?? 'assets/images/man1.png',
                    orderDistance:
                        '${(Geolocator.distanceBetween(LocationService.lat!, LocationService.long!, order.latitude!, order.longitude!) / 1000).toStringAsFixed(2)}Km',
                  );
                },
              );
            } else if (state is NoAvailableOrder) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    state.message,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.lightTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    state.message,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.lightTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
          },
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

  SliverToBoxAdapter _saldoCard(
    TextTheme textTheme,
    String username,
    String saldo,
    String phoneNumber,
  ) {
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
                showInfo
                    ? 'Rp${context.read<ProfileCubit>().userProfile?.balance}'
                    : 'Rp****',
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
                    showInfo
                        ? context
                                .read<ProfileCubit>()
                                .userProfile
                                ?.phoneNumber ??
                            phoneNumber
                        : "08x-xxx-xxx-xxx",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22.15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.east,
                      color: AppColors.leavesGreen,
                      size: 20,
                    ),
                    style: const ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(
                        Size(32, 32),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        AppColors.surface,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
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
          children: [
            TextSpan(
              text: context.read<ProfileCubit>().userProfile?.username ??
                  username,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (context.read<ProfileCubit>().userMitra != null &&
                context.read<ProfileCubit>().userMitra!.isVerified == 0) ...[
              const WidgetSpan(
                child: SizedBox(width: 10),
              ),
              const WidgetSpan(
                child: Icon(
                  Icons.block,
                  color: Colors.redAccent,
                ),
              ),
              TextSpan(
                text: 'Belum terverifikasi',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        PopupMenuButton<MenuItemModel>(
          icon: CircleAvatar(
            backgroundImage:
                context.read<ProfileCubit>().userProfile?.imageProfile != null
                    ? CachedNetworkImageProvider(
                        context.read<ProfileCubit>().userProfile!.imageProfile!,
                      )
                    : const AssetImage(
                        'assets/images/man1.png',
                      ),
            radius: 20,
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
