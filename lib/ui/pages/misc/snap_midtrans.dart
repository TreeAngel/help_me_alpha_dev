import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:midtrans_snap/midtrans_snap.dart';
import 'package:midtrans_snap/models.dart';

class SnapMidtrans extends StatelessWidget {
  final String token;
  const SnapMidtrans({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    MidtransResponse? pageResponse;

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: MidtransSnap(
          mode: MidtransEnvironment.sandbox,
          // kReleaseMode
          //     ? MidtransEnvironment.production
          //     : MidtransEnvironment.sandbox,
          token: token,
          // TODO: Move the client key to safe place somewhere before production
          midtransClientKey: 'SB-Mid-client-Dq1J9Sr45BhVF9WQ',
          onResponse: (result) {
            pageResponse = result;
            context.pop(pageResponse);
          },
        ),
      ),
    );
  }
}
