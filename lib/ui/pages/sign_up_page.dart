import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/api/api_exception.dart';
import '../../configs/app_colors.dart';
import '../../blocs/auth_blocs/auth_bloc.dart';
import '../../blocs/auth_blocs/auth_state.dart';
import '../../utils/show_dialog.dart';

enum TextInputEvent {
  fcmToken,
  fullname,
  username,
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;

    bool isPassword = true;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: <Widget>[
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            _sliverAPpBSliverAppBar(context, textTheme),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(),
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daftar akun',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FCM Token',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _textInputField(
                                context,
                                textTheme,
                                'Masukkan fcm token',
                                TextInputEvent.fcmToken),
                            const SizedBox(height: 10),
                            Text(
                              'Nama lengkap',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _textInputField(
                                context,
                                textTheme,
                                'Masukkan nama lengkap',
                                TextInputEvent.fullname),
                            const SizedBox(height: 10),
                            Text(
                              'Nomor handphone',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _phoneNumInputField(context, textTheme),
                            const SizedBox(height: 10),
                            Text(
                              'Username',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _textInputField(context, textTheme,
                                'Masukan username', TextInputEvent.username),
                            const SizedBox(height: 10),
                            Text(
                              'Kata sandi',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _passwordInputField(state, context, textTheme,
                                'Masukan kata sandi', isPassword),
                            const SizedBox(height: 10),
                            Text(
                              'Konfirmasi kata sandi',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _passwordInputField(state, context, textTheme,
                                'Konfirmasi kata sandi', !isPassword),
                            const SizedBox(height: 40),
                            if (state is SignUpLoaded) ...[
                              _stateLoaded(context),
                            ],
                            if (state is AuthError) ...[
                              _stateError(context, state),
                            ],
                            if (state is AuthLoading) ...[
                              const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.mitraGreen,
                                ),
                              ),
                            ] else ...[
                              _signUpButton(textTheme, context, state),
                            ],
                            const SizedBox(height: 10),
                            _haveAccountSection(textTheme, context),
                            const SizedBox(height: 50),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center _haveAccountSection(TextTheme textTheme, BuildContext context) {
    return Center(
      child: Text.rich(
        style: textTheme.bodyLarge?.copyWith(
            color: AppColors.darkTextColor, fontWeight: FontWeight.normal),
        TextSpan(
          text: 'Sudah memiliki akun? ',
          children: [
            TextSpan(
              text: 'Masuk',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.mitraGreen,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.goNamed('signInPage'),
            )
          ],
        ),
      ),
    );
  }

  _stateError(BuildContext context, AuthError state) {
    final errorMessage = ApiException.errorMessageBuilder(state.errorMessage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowDialog.showAlertDialog(
        context,
        'Error',
        errorMessage,
        null,
      );
    });
    return const SizedBox.shrink();
  }

  _stateLoaded(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowDialog.showAlertDialog(
        context,
        'Berhasil Sign Up!',
        null,
        TextButton.icon(
          onPressed: () {
            context.goNamed('formDataMitraPage');
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            elevation: WidgetStateProperty.all(0),
            iconColor: WidgetStateProperty.all(AppColors.lightTextColor),
          ),
          label: const Text(
            'Lanjut daftar usaha kamu!',
            style: TextStyle(color: AppColors.lightTextColor),
          ),
          icon: const Icon(Icons.arrow_forward_ios_rounded),
          iconAlignment: IconAlignment.end,
        ),
      );
    });
    return const SizedBox.shrink();
  }

  SizedBox _signUpButton(
      TextTheme textTheme, BuildContext context, AuthState state) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            AppColors.mitraGreen,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          'Daftar',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          context.read<AuthBloc>().add(SignUpSubmitted());
        },
      ),
    );
  }

  TextFormField _passwordInputField(AuthState state, BuildContext context,
      TextTheme textTheme, String hintText, bool passwordC) {
    return TextFormField(
      obscureText: !state.isPasswordVisible,
      onChanged: (password) => context.read<AuthBloc>().add(passwordC
          ? PasswordChanged(password)
          : ConfirmPasswordChanged(password)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle:
            textTheme.bodyLarge?.copyWith(color: AppColors.greyinput),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIconColor: Colors.black,
        suffixIcon: IconButton(
          icon: Icon(
            state.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            context.read<AuthBloc>().add(TogglePasswordVisibility());
          },
        ),
      ),
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  TextFormField _phoneNumInputField(BuildContext context, TextTheme textTheme) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      cursorColor: Colors.black,
      onChanged: (phoneNumber) =>
          context.read<AuthBloc>().add(PhoneNumberChanged(phoneNumber)),
      decoration: InputDecoration(
        prefixText: '+62 | ',
        prefixStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.normal,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: Colors.white,
        hintText: 'Masukan nomor handphone',
        hintStyle:
            textTheme.bodyLarge?.copyWith(color: AppColors.greyinput),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  TextFormField _textInputField(BuildContext context, TextTheme textTheme,
      String hintText, TextInputEvent event) {
    return TextFormField(
      cursorColor: Colors.black,
      onChanged: (textInput) => context.read<AuthBloc>().add(switch (event) {
            TextInputEvent.fcmToken => FcmTokenChanged(textInput),
            TextInputEvent.fullname => FullNameChanged(textInput),
            TextInputEvent.username => UsernameChanged(textInput),
            
          }),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle:
            textTheme.bodyLarge?.copyWith(color: AppColors.greyinput),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  SliverAppBar _sliverAPpBSliverAppBar(
      BuildContext context, TextTheme textTheme) {
    return SliverAppBar(
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
