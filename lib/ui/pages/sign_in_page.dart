import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:help_me_client_alpha_ver/services/api/api_exception.dart';

import '../../configs/app_colors.dart';
import '../../blocs/auth_blocs/auth_bloc.dart';
import '../../blocs/auth_blocs/auth_state.dart';
import '../../utils/show_alert_dialog.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _signInAppBar(context, textTheme),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masuk',
                  style: textTheme.headlineLarge?.copyWith(
                      color: AppColors.darkTextColor,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _usernameInputField(context, textTheme),
                        const SizedBox(height: 10),
                        Text(
                          'Password',
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _passwordInputField(state, context, textTheme),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _rememberMeCheckBox(state, context, textTheme),
                            _forgetPassword(context, textTheme)
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (state is SignInLoaded) ...[
                          _stateLoaded(context),
                        ],
                        if (state is AuthError) ...[
                          _stateError(context, state),
                        ],
                        if (state is AuthLoading) ...[
                          const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ] else ...[
                          _signInButton(textTheme, context, state),
                        ],
                        const SizedBox(height: 10),
                        _notHaveAccountSection(textTheme, context),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center _notHaveAccountSection(TextTheme textTheme, BuildContext context) {
    return Center(
      child: Text.rich(
        style: textTheme.bodyLarge?.copyWith(
            color: AppColors.darkTextColor, fontWeight: FontWeight.normal),
        TextSpan(
          text: 'Belum memiliki akun? ',
          children: [
            TextSpan(
              text: 'Daftar',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.goNamed('signUpPage'),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _forgetPassword(BuildContext context, TextTheme textTheme) {
    return GestureDetector(
      onTap: () => ShowAlertDialog.showAlertDialog(context, 'Lupa kata sandi?',
          'Sabar bang, nanti dibuat fiturnya', null),
      child: Text(
        'Lupa kata sandi?',
        style: textTheme.bodyLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Row _rememberMeCheckBox(
      AuthState state, BuildContext context, TextTheme textTheme) {
    return Row(
      children: [
        Checkbox(
          value: state.rememberMe,
          onChanged: (value) {
            context.read<AuthBloc>().add(ToggleRememberMe());
          },
        ),
        Text(
          'Tetap login',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.darkTextColor,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  _stateError(BuildContext context, AuthError state) {
    String errorMessage = ApiException.errorMessageBuilder(state.errorMessage);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowAlertDialog.showAlertDialog(
        context,
        'Error!',
        errorMessage,
        null,
      );
    });
    return const SizedBox.shrink();
  }

  _stateLoaded(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowAlertDialog.showAlertDialog(
        context,
        'Berhasil Sign In!',
        null,
        TextButton.icon(
          onPressed: () {
            context.read<AuthBloc>().add(ResetAuthState());
            context.goNamed('homePage');
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            elevation: WidgetStateProperty.all(0),
            iconColor: WidgetStateProperty.all(AppColors.lightTextColor),
          ),
          label: const Text(
            'Halaman utama',
            style: TextStyle(color: AppColors.lightTextColor),
          ),
          icon: const Icon(Icons.arrow_forward_ios_rounded),
          iconAlignment: IconAlignment.end,
        ),
      );
    });
    return const SizedBox.shrink();
  }

  SizedBox _signInButton(
      TextTheme textTheme, BuildContext context, AuthState state) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
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
          'Sign In',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          context.read<AuthBloc>().add(SignInSubmitted());
        },
      ),
    );
  }

  TextFormField _passwordInputField(
      AuthState state, BuildContext context, TextTheme textTheme) {
    return TextFormField(
      obscureText: !state.isPasswordVisible,
      onChanged: (password) =>
          context.read<AuthBloc>().add(PasswordChanged(password)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Masukan password',
        hintStyle:
            textTheme.bodyLarge?.copyWith(color: AppColors.hintTextColor),
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

  TextFormField _usernameInputField(BuildContext context, TextTheme textTheme) {
    return TextFormField(
      cursorColor: Colors.black,
      onChanged: (username) =>
          context.read<AuthBloc>().add(UsernameChanged(username)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Masukkan username',
        hintStyle:
            textTheme.bodyLarge?.copyWith(color: AppColors.hintTextColor),
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

  AppBar _signInAppBar(BuildContext context, TextTheme textTheme) {
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
      // TODO: DON'T FORGET TO DELETE THIS AFTER COMPLETE IMPLEMENTING AUTH
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () => context.goNamed('homePage'),
            child: SvgPicture.asset('assets/icons/option.svg'),
          ),
        ),
      ],
    );
  }
}