import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_me_client_alpha_ver/cubits/home/home_cubit.dart';
import 'package:midtrans_snap/midtrans_snap.dart';
import 'package:midtrans_snap/models.dart';

import '../../../blocs/manage_order/manage_order_bloc.dart';
import '../../../utils/manage_token.dart';
import '../../../utils/show_dialog.dart';

class SnapMidtransPage extends StatelessWidget {
  final String token;
  const SnapMidtransPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    String snapToken;
    MidtransResponse? pageResponse;
    bool willPop = false;

    return PopScope(
      canPop: willPop,
      child: SafeArea(
        child: BlocConsumer<ManageOrderBloc, ManageOrderState>(
            listener: (context, state) {
          if (state is SnapTokenRequested) {
            snapToken = state.code;
          }
          if (pageResponse != null) {}
          if (pageResponse?.transactionStatus.trim().toLowerCase() ==
                  'settlement' &&
              pageResponse?.statusCode == 200 &&
              pageResponse?.fraudStatus.trim().toLowerCase() == 'accept') {
            willPop = true;
            context.read<ManageOrderBloc>().add(CompletingPayment());
            context.read<HomeCubit>().fetchHistory();
            context.replaceNamed('detailOrderPage', queryParameters: {
              'orderId': context.read<ManageOrderBloc>().activeOrder!.orderId!
            });
          } else if (pageResponse?.statusCode == 201 &&
              pageResponse?.transactionStatus.trim().toLowerCase() ==
                  'pending') {
            context.read<ManageOrderBloc>().add(WaitingPayment());
            ShowDialog.showAlertDialog(
              context,
              'Pembayaran Pending!',
              pageResponse?.statusMessage ??
                  'Harap selesaikan transaksi sesuai metode yang dipilih sebelum tenggat waktu',
              null,
            );
          } else if (pageResponse?.statusCode == 407) {
            willPop = false;
            ManageSnapToken.deleteToken();
            context.read<ManageOrderBloc>().snapToken = null;
            context.read<ManageOrderBloc>().add(ManageOrderIsIdle());
            ShowDialog.showAlertDialog(
              context,
              'Pembayaran Gagal!',
              pageResponse?.statusMessage ?? 'Transaksi kadaluarsa',
              OutlinedButton(
                onPressed: () => context.read<ManageOrderBloc>().add(
                    RequestSnapToken(
                        orderId: context
                            .read<ManageOrderBloc>()
                            .activeOrder!
                            .orderId!)),
                child: const Text(
                  'Coba lagi',
                ),
              ),
            );
            // context.replaceNamed('selectMitraPage', queryParameters: {
            //   'orderId': activeOrder?.orderId,
            //   'status': activeOrder?.orderStatus,
            // });
          }
        }, builder: (context, state) {
          snapToken = token;
          return MidtransSnap(
            mode: kReleaseMode
                ? MidtransEnvironment.production
                : MidtransEnvironment.sandbox,
            token: snapToken,
            // TODO: Move the client key to safe place somewhere before production
            midtransClientKey: 'SB-Mid-client-Dq1J9Sr45BhVF9WQ',
            onResponse: (result) {
              pageResponse = result;
              willPop = true;
              context.pop(pageResponse);
            },
          );
        }),
      ),
    );
  }
}
