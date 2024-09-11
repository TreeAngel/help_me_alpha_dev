import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_me_client_alpha_ver/configs/app_colors.dart';
import 'package:help_me_client_alpha_ver/blocs/sign_in_blocs/sign_in_bloc.dart';
import 'package:help_me_client_alpha_ver/blocs/sign_in_blocs/sign_in_event.dart';
import 'package:help_me_client_alpha_ver/blocs/sign_in_blocs/sign_in_state.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;

    return SafeArea(
      child: Scaffold(
        appBar: _signInAppBar(textTheme),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
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
              BlocBuilder<SignInBloc, SignInState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _inputFieldHeader('Username', textTheme),
                      const SizedBox(height: 10),
                      _usernameInputField(context, textTheme),
                      const SizedBox(height: 10),
                      _inputFieldHeader('Password', textTheme),
                      const SizedBox(height: 10),
                      _passwordInputField(state, context, textTheme),
                      const SizedBox(height: 20),
                      if (state is SignInLoading) ...[
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ] else ...[
                        _signInButton(textTheme, context, state),
                      ],
                      if (state is SignInLoaded) ...[
                        Center(
                          child: _alertDialog(
                            context,
                            'Berhasil!',
                            'Berhasil sign in',
                            TextButton(
                              onPressed: () {
                                context
                                    .read<SignInBloc>()
                                    .add(ResetSignInState());
                                // Navigator.pop(context);
                              },
                              child: const Text('Ke halaman utama'),
                            ),
                          ),
                        ),
                      ],
                      if (state is SignInError) ...[
                        Center(
                          child: _alertDialog(
                            context,
                            'Gagal!',
                            state.errorMessage,
                            TextButton(
                              onPressed: () {
                                context
                                    .read<SignInBloc>()
                                    .add(ResetSignInState());
                                // Navigator.pop(context);
                              },
                              child: const Text('Coba lagi'),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _signInButton(
      TextTheme textTheme, BuildContext context, SignInState state) {
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
          context.read<SignInBloc>().add(SignInSubmitted());
        },
      ),
    );
  }

  AlertDialog _alertDialog(
      BuildContext context, String title, String content, Widget? action) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        action ?? const SizedBox.shrink(),
      ],
    );
  }

  Text _inputFieldHeader(String text, TextTheme textTheme) {
    return Text(
      text,
      style: textTheme.titleMedium?.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextFormField _passwordInputField(
      SignInState state, BuildContext context, TextTheme textTheme) {
    return TextFormField(
      obscureText: !state.isPasswordVisible,
      onChanged: (password) =>
          context.read<SignInBloc>().add(PasswordChanged(password)),
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
            context.read<SignInBloc>().add(TogglePasswordVisibility());
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
          context.read<SignInBloc>().add(UsernameChanged(username)),
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

  AppBar _signInAppBar(TextTheme textTheme) {
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SvgPicture.asset('assets/icons/option.svg'),
        ),
      ],
    );
  }
}
