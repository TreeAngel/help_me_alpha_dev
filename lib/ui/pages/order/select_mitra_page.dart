import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:help_me_client_alpha_ver/utils/logging.dart';
import 'package:midtrans_snap/models.dart';

import '../../../blocs/manage_order/manage_order_bloc.dart';
import '../../../blocs/fetch_offer/fetch_offer_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../models/offer/offer_model.dart';
import '../../../services/api/api_controller.dart';
import '../../../services/location_service.dart';
import '../../../utils/manage_token.dart';
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
  bool paymentDone = false;
  String paymentMessage = 'Belum Bayar!';

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
      context.read<FetchOfferBloc>().continueStream = false;
    } else {
      context.read<FetchOfferBloc>().continueStream = true;
    }
    super.didChangeAppLifecycleState(state);
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
              child: BlocConsumer<ManageOrderBloc, ManageOrderState>(
                listener: (context, state) {
                  if (state is SnapTokenError) {
                    ShowDialog.showAlertDialog(
                      context,
                      'Peringatan!',
                      state.message,
                      null,
                    );
                    context.read<ManageOrderBloc>().add(WaitingPayment());
                  } else if (state is SelectMitraError) {
                    ShowDialog.showAlertDialog(
                      context,
                      'Peringatan!',
                      state.message,
                      null,
                    );
                    if (state.message
                        .trim()
                        .toLowerCase()
                        .contains('sudah dipilih')) {
                      context.read<ManageOrderBloc>().add(WaitingPayment());
                    }
                  } else if (state is SelectMitraSuccess) {
                    context
                        .read<ManageOrderBloc>()
                        .add(RequestSnapToken(orderId: widget.orderId!));
                  }
                  if (state is SnapTokenRequested) {
                    context.read<ManageOrderBloc>().add(WaitingPayment());
                    ManageSnapToken.writeToken(state.code);
                    context.read<ManageOrderBloc>().snapToken = state.code;
                  }
                },
                builder: (context, state) {
                  if (state is ManageOrderLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PaymentPending || state is PaymentDone) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            paymentMessage,
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.lightTextColor,
                            ),
                          ),
                          if (paymentDone == false)
                            ..._notPayedTxt(textTheme)
                          else
                            ..._payedTxt(textTheme),
                          const SizedBox(height: 20),
                          _paymentStatusIcon(),
                          const SizedBox(height: 20),
                          if (paymentDone == false)
                            ..._notPayedBtn(
                              context,
                              textTheme,
                              screenWidth,
                              screenHeight,
                            )
                          else
                            ..._payedBtn(textTheme),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: BlocProvider(
                        create: (context) => FetchOfferBloc(),
                        child: _fetchOfferConsumer(textTheme),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _notPayedTxt(TextTheme textTheme) {
    return [
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Text(
          'Harap selesaikan pembayaran dengan harga yang sudah ditentukan!\nJangan lupa diskusiin harga jasa ama abannya nanti ya',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.lightTextColor,
          ),
        ),
      ),
    ];
  }

  List<Widget> _payedTxt(TextTheme textTheme) {
    return [
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Text(
          'Pembayaran berhasil lanjut ke halaman detail buat\nhubungin abannya dan pantau progres orderan ya!',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.lightTextColor,
          ),
        ),
      ),
    ];
  }

  List<Widget> _payedBtn(TextTheme textTheme) {
    return [
      SizedBox(
        width: 353,
        height: 56,
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              AppColors.primary,
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: Text(
            'Lanjut',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.lightTextColor,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _notPayedBtn(
    BuildContext context,
    TextTheme textTheme,
    double screenWidht,
    double screenHeight,
  ) {
    return [
      SizedBox(
        width: 353,
        height: 56,
        child: ElevatedButton(
          onPressed: () async {
            MidtransResponse? response;
            ManageSnapToken.readToken();
            if (context.read<ManageOrderBloc>().snapToken == null) {
              context
                  .read<ManageOrderBloc>()
                  .add(RequestSnapToken(orderId: widget.orderId!));
              response = await context.pushNamed(
                'payPage',
                queryParameters: {
                  'token': context.read<ManageOrderBloc>().snapToken
                },
              );
            } else {
              response = await context.pushNamed(
                'payPage',
                queryParameters: {
                  'token': context.read<ManageOrderBloc>().snapToken
                },
              );
            }
            if (context.mounted) {
              _midtransResponseHandling(response, context);
            } else {
              printError('Error midtrans response handling has escaped');
            }
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              AppColors.primary,
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: Text(
            'Lanjut Bayar',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.lightTextColor,
            ),
          ),
        ),
      ),
    ];
  }

  void _midtransResponseHandling(
      MidtransResponse? response, BuildContext context) {
    if (response?.transactionStatus.trim().toLowerCase() == 'settlement' &&
        response?.statusCode == 200 &&
        response?.fraudStatus.trim().toLowerCase() == 'accept') {
      paymentDone = true;
      paymentMessage = 'Pembayaran berhasil!';
      context.read<ManageOrderBloc>().add(CompletingPayment());
    } else if (response?.statusCode == 201 &&
        response?.transactionStatus.trim().toLowerCase() == 'pending') {
      paymentDone = false;
      paymentMessage = response!.statusMessage.toString();
    } else if (response?.statusCode == 407) {
      paymentDone = false;
      paymentMessage = 'Transaksi kadaluarsa, coba ulang proses pembayaran';
      ManageSnapToken.deleteToken();
      context.read<ManageOrderBloc>().snapToken = null;
    } else {
      paymentDone = false;
      paymentMessage = response!.statusMessage.toString();
    }
  }

  Icon _paymentStatusIcon() {
    return Icon(
      paymentDone ? Icons.done : Icons.warning_rounded,
      color: paymentDone ? Colors.greenAccent : Colors.orangeAccent,
      size: 145,
    );
  }

  BlocConsumer<FetchOfferBloc, FetchOfferState> _fetchOfferConsumer(
      TextTheme textTheme) {
    return BlocConsumer<FetchOfferBloc, FetchOfferState>(
      listener: (context, state) {
        if (state is FetchOfferError) {
          _stateError(context, state.message);
        } else if (state is FetchOfferLoaded) {
          context.read<FetchOfferBloc>().offerList =
              state.data.data ?? <OfferModel>[];
        }
      },
      builder: (context, state) {
        if (state is FetchOfferInitial) {
          if (widget.orderId != null) {
            context.read<FetchOfferBloc>().add(
                  FetchOffer(orderId: widget.orderId!),
                );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ShowDialog.showAlertDialog(
                context,
                'Peringatan!',
                'Kamu tidak ada order yang aktif saat ini, jika kamu punya order aktif dan tetap mendapat pesan ini coba untuk refresh di home atau close aplikasi dan masuk lagi',
                null,
              );
              context.pop();
              context.canPop() ? context.pop() : context.goNamed('homePage');
            });
          }
        }
        if (state is FetchOfferLoading) {
          return const SizedBox.expand(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return _offerCardBuilder(context, textTheme);
      },
    );
  }

  ListView _offerCardBuilder(BuildContext context, TextTheme textTheme) {
    return ListView.builder(
      itemCount: context.read<FetchOfferBloc>().offerList.length,
      itemBuilder: (BuildContext context, int index) {
        final data = context.read<FetchOfferBloc>().offerList[index];
        final distance = Geolocator.distanceBetween(
          LocationService.lat!,
          LocationService.long!,
          double.parse(data.latitude!),
          double.parse(data.longitude!),
        ).truncateToDouble();
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: GradientCard(
            width: 400,
            height: 200,
            cardColor: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            if (offer != null) {
              _selectMitraConfirmation(offer, textTheme);
            } else {
              ShowDialog.showAlertDialog(
                context,
                'Gagal!',
                'Terdapat kesalahan, silahkan pilih penawaran lain atau coba lagi',
                null,
              );
            }
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
          label: const Text('Panggil Abangnya'),
        )
      ],
    );
  }

  void _selectMitraConfirmation(OfferModel offer, TextTheme textTheme) {
    ShowDialog.showAlertDialog(
      context,
      'Konfirmasi',
      'Panggil abang yang ini?',
      OutlinedButton(
        onPressed: () {
          context.pop();
          context.read<FetchOfferBloc>().continueStream = false;
          context.read<ManageOrderBloc>().add(
                SelectMitraSubmitted(
                  offerId: offer.offerId!,
                ),
              );
        },
        style: const ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(
              color: AppColors.lightTextColor,
            ),
          ),
        ),
        child: Text(
          'Yakin',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.lightTextColor,
          ),
        ),
      ),
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
      child: BlocBuilder<FetchOfferBloc, FetchOfferState>(
        builder: (context, state) {
          List<OfferModel> offerList =
              context.watch<FetchOfferBloc>().offerList;
          return Column(
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
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 16,
                ),
                child: LimitedBox(
                  maxHeight: 36,
                  child: _avatarBuilder(offerList),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ListView _avatarBuilder(List<OfferModel> offerList) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: offerList.length,
      itemBuilder: (BuildContext context, int index) {
        final offer = offerList[index];
        return CircleAvatar(
          radius: 21,
          backgroundColor: AppColors.surface,
          child: CircleAvatar(
            radius: 17,
            backgroundImage: CachedNetworkImageProvider(
              '${ApiController.baseUrl}/${offer.mitraProfile}',
              maxWidth: 36,
              maxHeight: 36,
            ),
          ),
        );
      },
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
