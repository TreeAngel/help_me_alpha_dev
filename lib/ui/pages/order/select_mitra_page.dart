import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:help_me_client_alpha_ver/blocs/manage_order/manage_order_bloc.dart';

import '../../../configs/app_colors.dart';
import '../../../models/offer/offer_model.dart';
import '../../../services/api/api_controller.dart';
import '../../../services/location_service.dart';
import '../../../utils/logging.dart';
import '../../../utils/show_dialog.dart';
import '../../widgets/gradient_card.dart';

class SelectMitraPage extends StatefulWidget {
  final int? orderId;

  const SelectMitraPage({super.key, required this.orderId});

  @override
  State<SelectMitraPage> createState() => _SelectMitraPageState();
}

class _SelectMitraPageState extends State<SelectMitraPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    LocationService.fetchLocation(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      context.read<ManageOrderBloc>().add(PauseFetching());
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: _appBar(context, textTheme),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              width: screenWidth,
              height: screenHeight / 5,
              child: Container(
                color: Colors.black,
                child: _detailHeadline(textTheme),
              ),
            ),
            Positioned(
              bottom: 0,
              width: screenWidth,
              height: screenHeight / 1.43,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: BlocConsumer<ManageOrderBloc, ManageOrderState>(
                  listener: (context, state) {
                    if (state is OfferFromMitraError) {
                      _stateError(context, state.message);
                    } else if (state is PaymentCodeError) {
                      _stateError(context, state.message);
                    } else if (state is OfferFromMitraLoaded) {
                      context.read<ManageOrderBloc>().offerList =
                          state.data.data ?? <OfferModel>[];
                    } else if (state is PaymentCodeRequested) {
                      context.read<ManageOrderBloc>().paymentCode = state.code;
                    }
                  },
                  builder: (context, state) {
                    if (state is ManageOrderInitial) {
                      context
                          .read<ManageOrderBloc>()
                          .add(FetchOffer(orderId: widget.orderId ?? 0));
                    }
                    if (state is ManageOrderLoading) {
                      return const SizedBox.expand(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        printInfo('refreshing');
                      },
                      child: ListView.builder(
                        itemCount:
                            context.read<ManageOrderBloc>().offerList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data =
                              context.read<ManageOrderBloc>().offerList[index];
                          final distance = Geolocator.distanceBetween(
                                  LocationService.lat!,
                                  LocationService.long!,
                                  double.parse(data.latitude!),
                                  double.parse(data.longitude!))
                              .truncateToDouble();
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: GradientCard(
                              width: 400,
                              height: 200,
                              cardColor: Colors.black,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 20, left: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _orderCardHistoryInfoSection(
                                      data,
                                      distance,
                                      textTheme,
                                    ),
                                    _orderCardHistoryImageSection(data),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _orderCardHistoryImageSection(OfferModel? offer) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 40),
      child: CircleAvatar(
        radius: 21,
        backgroundColor: AppColors.surface,
        child: CircleAvatar(
          radius: 16,
          backgroundImage: offer != null
              ? CachedNetworkImageProvider(
                  '${ApiController.baseUrl}/${offer.mitraProfile}',
                )
              : const AssetImage('assets/images/girl1.png'),
        ),
      ),
    );
  }

  Column _orderCardHistoryInfoSection(
    OfferModel? offer,
    double distance,
    TextTheme textTheme,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LimitedBox(
          maxWidth: 310,
          child: Text(
            offer != null
                ? offer.mitraName.toString()
                : 'Gagal memproses data, refresh untuk lanjut',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        LimitedBox(
            maxWidth: 310,
            child: Text(
              offer != null ? '${distance / 1000}km' : 'N/A',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.aquamarine,
              ),
            )),
        Text(
          offer != null ? 'Rp${offer.price}' : 'N/A',
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
          label: const Text('Panggil Abangnya'), // TODO: Implement select mitra
        )
      ],
    );
  }

  void _stateError(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowDialog.showAlertDialog(
        context,
        'Error!',
        message,
        IconButton.outlined(
          onPressed: () {},
          icon: const Icon(Icons.refresh_outlined),
        ),
      );
    });
  }

  Padding _detailHeadline(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Berikut solusi dari\nHelpMe!',
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.darkTextColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // TODO: Change to show available mitar, REMEMBER
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: LimitedBox(
              maxHeight: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return const CircleAvatar(
                    radius: 39,
                    backgroundColor: AppColors.backgroundColor,
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        '',
                        maxWidth: 36,
                        maxHeight: 36,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: AppColors.darkTextColor,
      title: Text(
        'Help Me!',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
