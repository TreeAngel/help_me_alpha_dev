import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/profile_bloc/profile_bloc.dart';
import '../../configs/app_colors.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String message = 'Masukan nomor telpon anda';

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _appBar(context, textTheme),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is OTPRequested) {
              context.read<ProfileBloc>().statusOTP = StatusOTP.requested;
              message = state.message;
            } else if (state is OTPError) {
              context.read<ProfileBloc>().statusOTP = StatusOTP.waiting;
              message = state.errorMessage;
            } else if (state is OTPVerified) {
              context.read<ProfileBloc>().statusOTP = StatusOTP.done;
              message = state.message;
            }
          },
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsetsDirectional.all(20),
              children: [
                Text(
                  message,
                  style: textTheme.titleLarge
                      ?.copyWith(color: AppColors.darkTextColor),
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
                  context.watch<ProfileBloc>().statusOTP,
                  context.read<ProfileBloc>().phoneNumber,
                  context,
                  textTheme,
                ),
                if (state is OTPRequested) ...[
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
                    context.watch<ProfileBloc>().statusOTP,
                    context,
                    textTheme,
                  ),
                ],
                if (state is OTPLoading) ...[
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ] else ...[
                  const SizedBox(height: 20),
                  _confirmBtn(
                    context.watch<ProfileBloc>().statusOTP,
                    context,
                    textTheme,
                  ),
                ],
              ],
            );
          },
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
              StatusOTP.done => AppColors.grey
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
              context.read<ProfileBloc>().add(RequestOTP());
              break;
            case StatusOTP.requested:
              context.read<ProfileBloc>().add(VerifyOTP());
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
      onChanged: (value) => context.read<ProfileBloc>().add(
            OTPCodeChanged(code: value),
          ),
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
      onChanged: (value) => context.read<ProfileBloc>().add(
            NewPhoneNumberChanged(phoneNumber: value),
          ),
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
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
        'Konfirmasi nomor telpon',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
