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

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: <Widget>[
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            _authSliverAppBar(context),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "Masuk",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: textTheme.titleMedium?.copyWith(
                                fontSize: 14,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            _usernameInputField(context, textTheme),
                            const SizedBox(height: 10),
                            Text(
                              'Password',
                              style: textTheme.titleMedium?.copyWith(
                                fontSize: 14,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            _passwordInputField(state, context, textTheme),
                            const SizedBox(height: 0.5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _rememberMeCheckBox(state, context, textTheme),
                                _forgetPassword(context)
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
                                  color: AppColors.mitraGreen,
                                ),
                              ),
                            ] else ...[
                              _signInButton(textTheme, context, state),
                            ],
                            const SizedBox(height: 10),
                            _notHaveAccountSection(textTheme, context),
                            const SizedBox(height: 20),
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
                color: AppColors.mitraGreen,
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

  _stateError(BuildContext context, AuthError state) {
    String errorMessage = ApiException.errorMessageBuilder(state.errorMessage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowDialog.showAlertDialog(
        context,
        'Error!',
        errorMessage,
        null,
      );
      context.read<AuthBloc>().add(ResetAuthState());
    });
    return const SizedBox.shrink();
  }

  _stateLoaded(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.goNamed('homePage');
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
            AppColors.mitraGreen,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          'Masuk',
          style: textTheme.titleMedium?.copyWith(
            fontSize: 16,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
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
        hintText: 'Masukan kata sandi',
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
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
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
            textTheme.bodyLarge?.copyWith(color: AppColors.greyinput),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      ),
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.normal,
      ),
    );  
  }

  GestureDetector _forgetPassword(BuildContext context) {
    return GestureDetector(
      onTap: () => context.goNamed('forgotPasswordPage'),
      child: Text(
        'Lupa kata sandi?',
        style: GoogleFonts.poppins(
          decoration: TextDecoration.underline,
          color: AppColors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
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

  SliverAppBar _authSliverAppBar(BuildContext context) {
    return const SliverAppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: AppColors.white,
      title: Text(
        'HelpMe!',
        style: TextStyle(
          fontFamily: "poppins",
          color: Colors.white,
          fontSize: 25.21,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
