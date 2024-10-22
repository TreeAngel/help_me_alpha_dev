import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timelines/timelines.dart';

import '../../../configs/app_colors.dart';
import '../../../cubits/detail_order/detail_order_cubit.dart';
import '../../../models/order/detail_order_model.dart';
import '../../../utils/show_dialog.dart';
import '../../widgets/gradient_card.dart';

class DetailOrderPage extends StatefulWidget {
  final int? orderId;
  final double? distanceInKm;
  const DetailOrderPage({
    super.key,
    required this.orderId,
    this.distanceInKm,
  });

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  DetailOrderModel? detailOrder;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidht = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _appBar(context, textTheme),
        body: BlocConsumer<DetailOrderCubit, DetailOrderState>(
          listener: (context, state) {
            if (state is DetailOrderLoading) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              null;
            }
            if (state is DetailOrderLoaded) {
              detailOrder = state.data;
            }
            if (state is DetailOrderError) {
              ShowDialog.showAlertDialog(
                context,
                'Peringatan!',
                state.message,
                null,
              );
            }
            if (state is ListeningOrderStatusError) {
              ShowDialog.showAlertDialog(
                context,
                'Terjadi Kesalahan!',
                state.message,
                null,
              );
            }
            if (state is OpenWhatsAppError) {
              ShowDialog.showAlertDialog(
                context,
                'Gagal Membuka WhatsApp!',
                state.message,
                null,
              );
            }
            if (state is CreateChatRoomSuccess) {
              context.read<DetailOrderCubit>().isIdle();
              context.pushNamed(
                'chatPage',
                queryParameters: {
                  'chatId': context.read<DetailOrderCubit>().chatId.toString(),
                  'name': detailOrder?.mitra.toString(),
                  'img': detailOrder?.mitraProfile.toString(),
                },
              );
            }
          },
          builder: (context, state) {
            if (detailOrder == null) {
              context
                  .read<DetailOrderCubit>()
                  .fetchDetailOrder(orderId: widget.orderId!);
            }
            return RefreshIndicator(
              onRefresh: () async => context
                  .read<DetailOrderCubit>()
                  .fetchDetailOrder(orderId: widget.orderId!),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: GradientCard(
                  width: screenWidht,
                  height: screenHeight - (screenHeight / 8),
                  cardColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _infoSection(textTheme),
                            _imageSection(),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Status Bantuan',
                          style: textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: FixedTimeline.tileBuilder(
                            theme: TimelineThemeData(
                              color: AppColors.limeGreen,
                            ),
                            builder: TimelineTileBuilder.connectedFromStyle(
                              itemCount: 5,
                              contentsAlign: ContentsAlign.reverse,
                              oppositeContentsBuilder: (context, index) =>
                                  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Order status\nTime',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: AppColors.darkTextColor,
                                  ),
                                ),
                              ),
                              firstConnectorStyle: ConnectorStyle.transparent,
                              lastConnectorStyle: ConnectorStyle.transparent,
                              connectorStyleBuilder: (context, index) =>
                                  ConnectorStyle.solidLine,
                              indicatorStyleBuilder: (context, index) =>
                                  IndicatorStyle.dot,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _callBtn(context, textTheme),
                              const SizedBox(width: 10),
                              _chatBtn(context, textTheme),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Expanded _callBtn(BuildContext context, TextTheme textTheme) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => context.read<DetailOrderCubit>().openWhatsApp(
              detailOrder?.phoneNumberMitra ?? '',
            ),
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(
            AppColors.primary,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(42),
            ),
          ),
        ),
        child: Text(
          'Call',
          style: textTheme.bodyLarge?.copyWith(color: AppColors.lightTextColor),
        ),
      ),
    );
  }

  Expanded _chatBtn(BuildContext context, TextTheme textTheme) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (context.read<DetailOrderCubit>().chatId == null) {
            context
                .read<DetailOrderCubit>()
                .createChatRoom(orderId: detailOrder!.orderId!);
          } else {
            context.pushNamed(
              'chatPage',
              queryParameters: {
                'chatId': context.read<DetailOrderCubit>().chatId.toString(),
                'name': detailOrder?.mitra.toString(),
                'img': detailOrder?.mitraProfile.toString(),
              },
            );
          }
        },
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(
            AppColors.darkTextColor,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(42),
            ),
          ),
        ),
        child: Text(
          'Chat',
          style: textTheme.bodyLarge?.copyWith(color: AppColors.lightTextColor),
        ),
      ),
    );
  }

  Container _imageSection() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 40),
      child: CircleAvatar(
        radius: 21,
        backgroundColor: AppColors.surface,
        child: CircleAvatar(
          radius: 16,
          backgroundImage: detailOrder?.mitraProfile != null
              ? CachedNetworkImageProvider(
                  detailOrder?.mitraProfile ??
                      'https://st2.depositphotos.com/1561359/12101/v/950/depositphotos_121012076-stock-illustration-blank-photo-icon.jpg',
                )
              : const AssetImage('assets/images/girl1.png'),
        ),
      ),
    );
  }

  Column _infoSection(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LimitedBox(
          maxWidth: 310,
          child: Text(
            detailOrder?.mitra != null
                ? detailOrder?.mitra.toString() ?? 'N/A'
                : 'Gagal memproses data, refresh untuk lanjut',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        LimitedBox(
            maxWidth: 310,
            child: Text(
              widget.distanceInKm != null
                  ? '${widget.distanceInKm}km'
                  : detailOrder?.orderTime.toString() ?? 'N/A',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.aquamarine,
              ),
            )),
        const SizedBox(height: 10),
        Text(
          detailOrder?.price != null ? 'Rp${detailOrder?.price}' : 'N/A',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
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
