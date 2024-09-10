import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_me_client_alpha_ver/configs/app_colors.dart';
import 'package:help_me_client_alpha_ver/blocs/sign_in_blocs/sign_in_bloc.dart';
import 'package:help_me_client_alpha_ver/blocs/sign_in_blocs/sign_in_event.dart';
import 'package:help_me_client_alpha_ver/blocs/sign_in_blocs/sign_in_state.dart';
import 'package:help_me_client_alpha_ver/services/api_helper.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text('Help Me!'),
        actions: [SvgPicture.asset('assets/icons/option.svg')],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Masuk',
              style: textTheme.titleLarge?.copyWith(
                  color: AppColors.darkTextColor, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            BlocBuilder<SignInBloc, SignInState>(
              builder: (context, state) {
                return Column(
                  children: [
                    TextFormField(
                      onChanged: (username) => context
                          .read<SignInBloc>()
                          .add(UsernameChanged(username)),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: !state.isPasswordVisible,
                      onChanged: (password) => context
                          .read<SignInBloc>()
                          .add(PasswordChanged(password)),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            context
                                .read<SignInBloc>()
                                .add(TogglePasswordVisibility());
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<SignInBloc>().add(SignInSubmitted());
                      },
                      child: const Text('Sign In'),
                    ),
                    if (state is SignInLoaded) ...[
                      const SizedBox(height: 20),
                      AlertDialog(
                        title: const Text('Berhasil!'),
                        content: const Text('Anda berhasil masuk'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Lanjut ke halaman utama'),
                          ),
                        ],
                      )
                    ],
                    if (state is SignInError) ...[
                      const SizedBox(height: 20),
                      const AlertDialog(
                        title: Text('Gagal!'),
                        content: Text('Username atau password salah'),
                      )
                    ],
                    if (state is SignInLoading) ...[
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
