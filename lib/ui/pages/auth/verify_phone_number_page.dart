import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/app_colors.dart';
import '../../../cubits/home/home_cubit.dart';
import '../../../cubits/profile/profile_cubit.dart';
import '../../../services/api/api_controller.dart';
import '../../widgets/custom_dialog.dart';

enum StatusOTP {
  waiting,
  requested,
  done,
}

class VerifyPhoneNumberPage extends StatelessWidget {
  const VerifyPhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    StatusOTP currentStatus = context.watch<ProfileCubit>().statusOTP;
    String message = 'Message that will showed after every button pressed';
    bool canPop = true;
    bool verified = false;

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        didPop ? context.pop(result = verified) : null;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: _appBar(context, textTheme),
          body: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (context.read<ProfileCubit>().userProfile == null &&
                  ApiController.token != null) {
                context.read<ProfileCubit>().fetchProfile();
              }
              if (state is ProfileLoaded) {
                context.read<ProfileCubit>().userProfile =
                    state.userProfile.user;
                context.read<ProfileCubit>().profileIsIdle();
              }
              if (state is OTPRequested) {
                context.read<ProfileCubit>().statusOTP = StatusOTP.requested;
                message = state.message;
                CustomDialog.showAlertDialog(
                  context,
                  'Berhasil!',
                  message,
                  null,
                );
              } else if (state is OTPError) {
                message = state.errorMessage;
                verified = false;
                CustomDialog.showAlertDialog(
                  context,
                  'Verifikasi Gagal!',
                  message,
                  null,
                );
              } else if (state is OTPVerified) {
                message = state.message;
                if (!message.toLowerCase().trim().contains('salah')) {
                  context.read<ProfileCubit>().statusOTP = StatusOTP.done;
                  verified = true;
                  context.pop(verified);
                } else {
                  context.read<ProfileCubit>().statusOTP = StatusOTP.requested;
                }
                CustomDialog.showAlertDialog(
                  context,
                  'Verifikasi Terkirim!',
                  message,
                  null,
                );
                ApiController.token != null
                    ? {
                        context.read<ProfileCubit>().fetchProfile(),
                        context.read<HomeCubit>().fetchHistory(),
                      }
                    : null;
              }
              if (state is ProfileLoading) {
                canPop = false;
              } else {
                canPop = true;
              }
            },
            builder: (context, state) {
              return ListView(
                padding: const EdgeInsetsDirectional.all(20),
                children: [
                  Center(
                    child: Text(
                      'Verifikasi nomor telpon',
                      style: textTheme.titleLarge
                          ?.copyWith(color: AppColors.darkTextColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Nomor telpon',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.darkTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _phoneNumberInput(
                    currentStatus,
                    context.read<ProfileCubit>().userProfile?.phoneNumber ??
                        context.read<ProfileCubit>().phoneNumber,
                    context,
                    textTheme,
                  ),
                  if (currentStatus != StatusOTP.waiting) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Kode OTP',
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.darkTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _codeOTPInput(
                      currentStatus,
                      context,
                      textTheme,
                    ),
                  ],
                  const SizedBox(height: 20),
                  if (state is OTPLoading || state is ProfileLoading) ...[
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ] else ...[
                    _confirmBtn(
                      currentStatus,
                      context,
                      textTheme,
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  SizedBox _confirmBtn(
    StatusOTP currentStatus,
    BuildContext context,
    TextTheme textTheme,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            switch (currentStatus) {
              StatusOTP.requested || StatusOTP.waiting => AppColors.primary,
              StatusOTP.done => AppColors.gray
            },
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: () {
          switch (currentStatus) {
            case StatusOTP.waiting:
              context.read<ProfileCubit>().requestOTP();
              break;
            case StatusOTP.requested:
              context.read<ProfileCubit>().verifyOTP();
              break;
            default:
          }
        },
        child: Text(
          'Konfirmasi',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.lightTextColor,
            fontStyle: currentStatus == StatusOTP.done
                ? FontStyle.italic
                : FontStyle.normal,
          ),
        ),
      ),
    );
  }

  TextFormField _codeOTPInput(
    StatusOTP currentStatus,
    BuildContext context,
    TextTheme textTheme,
  ) {
    return TextFormField(
      enabled: currentStatus == StatusOTP.requested,
      onChanged: (value) => context.read<ProfileCubit>().codeOTP = value,
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Masukan kode OTP',
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.hintTextColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
      ),
    );
  }

  TextFormField _phoneNumberInput(
    StatusOTP currentStatus,
    String? userPhoneNumber,
    BuildContext context,
    TextTheme textTheme,
  ) {
    return TextFormField(
      enabled: currentStatus == StatusOTP.waiting,
      initialValue: currentStatus == StatusOTP.waiting ? userPhoneNumber : null,
      onChanged: (value) => context.read<ProfileCubit>().phoneNumber = value,
      cursorColor: Colors.black,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Masukan nomor telpon',
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.hintTextColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
      ),
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: AppColors.darkTextColor,
      title: Text(
        'HelpMe!',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
