import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../widgets/custom_dialog.dart';

class FormDataMitraPage extends StatefulWidget {
  const FormDataMitraPage({super.key});

  @override
  State<FormDataMitraPage> createState() => _FormDataMitraPageState();
}

class _FormDataMitraPageState extends State<FormDataMitraPage> {
  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: <Widget>[
            _sliverAppBar(context, textTheme),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daftarkan informasi mitra anda',
                      style: textTheme.headlineLarge?.copyWith(
                        color: AppColors.darkTextColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is SignUpMitraLoaded) {
                          _stateLoaded(context);
                        }
                        if (state is AuthError) {
                          _stateError(context, state);
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama mitra',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _nameInputField(
                              context,
                              textTheme,
                              'Masukkan nama mitra',
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Nomor rekening',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _accountNumberInputField(
                              context,
                              textTheme,
                              'Nomor rekening',
                            ),
                            const SizedBox(height: 10),
                            if (state is AuthLoading) ...[
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                              const SizedBox(height: 10),
                            ] else ...[
                              _signUpButton(textTheme, context, state),
                            ],
                            const SizedBox(height: 50),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _stateError(BuildContext context, AuthError state) {
    CustomDialog.showAlertDialog(
      context,
      'Error',
      state.message,
      null,
    );
  }

  _stateLoaded(BuildContext context) {
    CustomDialog.showAlertDialog(
      context,
      'Berhasil Daftar!',
      null,
      TextButton.icon(
        onPressed: () {
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
      ),
    );
  }

  SizedBox _signUpButton(
    TextTheme textTheme,
    BuildContext context,
    AuthState state,
  ) {
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
          'Daftar Mitra',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          context.read<AuthBloc>().add(SignUpMitraSubmitted());
        },
      ),
    );
  }

  TextFormField _nameInputField(
    BuildContext context,
    TextTheme textTheme,
    String hintText,
  ) {
    return TextFormField(
      cursorColor: Colors.black,
      onChanged: (value) =>
          context.read<AuthBloc>().add(MitraNameChanged(mitraName: value)),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.hintTextColor,
        ),
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

  TextFormField _accountNumberInputField(
    BuildContext context,
    TextTheme textTheme,
    String hintText,
  ) {
    return TextFormField(
      cursorColor: Colors.black,
      onChanged: (value) => context
          .read<AuthBloc>()
          .add(AccountNumberChanged(accountNumber: value)),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.hintTextColor,
        ),
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

  SliverAppBar _sliverAppBar(BuildContext context, TextTheme textTheme) {
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
