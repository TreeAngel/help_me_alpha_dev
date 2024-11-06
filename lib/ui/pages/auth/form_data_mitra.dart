import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../cubits/check_bank_account/check_bank_account_cubit.dart';
import '../../../cubits/home/home_cubit.dart';
import '../../../data/bank_code.dart';
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
                      style: textTheme.headlineMedium?.copyWith(
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
                        if (context.read<HomeCubit>().categories.isEmpty) {
                          context.read<HomeCubit>().fetchCategories();
                        }
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
                            _inputBankAccount(textTheme, context),
                            const SizedBox(height: 10),
                            _bankAccountCheckerWidget(textTheme),
                            const SizedBox(height: 10),
                            Text(
                              'Kategori mitra',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _kategoriMitraDropdownMenu(textTheme, context),
                            const SizedBox(height: 20),
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

  DecoratedBox _kategoriMitraDropdownMenu(
      TextTheme textTheme, BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownMenu<int>(
        expandedInsets: const EdgeInsets.all(0),
        hintText: 'Pilh kategori mitra',
        textStyle: textTheme.labelLarge?.copyWith(
          color: AppColors.lightTextColor,
        ),
        menuStyle: const MenuStyle(
          backgroundColor: WidgetStatePropertyAll(
            AppColors.surface,
          ),
          shadowColor: WidgetStatePropertyAll(
            Colors.transparent,
          ),
          side: WidgetStatePropertyAll(
            BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        onSelected: (value) {
          context.read<AuthBloc>().add(CategoryIdChanged(
                categoryId: value ?? 0,
              ));
        },
        dropdownMenuEntries: context
            .read<HomeCubit>()
            .categories
            .map<DropdownMenuEntry<int>>((value) {
          return DropdownMenuEntry<int>(
            value: value.id,
            label: value.name,
          );
        }).toList(),
      ),
    );
  }

  BlocBuilder<CheckBankAccountCubit, CheckBankAccountState>
      _bankAccountCheckerWidget(TextTheme textTheme) {
    return BlocBuilder<CheckBankAccountCubit, CheckBankAccountState>(
      builder: (context, state) {
        if (state is CheckError) {
          return Center(
            child: Text(
              state.message,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.darkTextColor,
              ),
            ),
          );
        } else if (state is AccountNumberExist) {
          return _bankAccountExist(state, textTheme);
        } else if (state is AccountNumberNotExist) {
          return Center(
            child: Text(
              state.message,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.darkTextColor,
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Row _inputBankAccount(TextTheme textTheme, BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: _bankDropdownMenu(textTheme, context),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 10,
          child: _accountNumberInputField(
            context,
            textTheme,
            'Nomor rekening',
          ),
        ),
      ],
    );
  }

  Center _bankAccountExist(AccountNumberExist state, TextTheme textTheme) {
    return Center(
      child: Column(
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                state.bank.bankName,
                textAlign: TextAlign.start,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.darkTextColor,
                ),
              ),
              const SizedBox(width: 10),
              Text.rich(
                textAlign: TextAlign.end,
                TextSpan(
                  text: '${state.bank.accountNumber}\n',
                  children: [
                    TextSpan(
                      text: state.bank.accountName,
                    ),
                  ],
                ),
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.darkTextColor,
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  DecoratedBox _bankDropdownMenu(TextTheme textTheme, BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownMenu<String>(
        hintText: 'Pilh bank',
        textStyle: textTheme.labelLarge?.copyWith(
          color: AppColors.lightTextColor,
        ),
        menuStyle: const MenuStyle(
          backgroundColor: WidgetStatePropertyAll(
            AppColors.surface,
          ),
          shadowColor: WidgetStatePropertyAll(
            Colors.transparent,
          ),
          side: WidgetStatePropertyAll(
            BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        onSelected: (value) {
          context.read<CheckBankAccountCubit>().bankCode = value ?? '';
        },
        dropdownMenuEntries:
            BankCode.data.keys.map<DropdownMenuEntry<String>>((String value) {
          return DropdownMenuEntry(
            value: BankCode.data[value],
            label: value,
          );
        }).toList(),
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
          context.read<AuthBloc>().add(SignUpMitraSubmitted(
              bankAccountState: context.read<CheckBankAccountCubit>().state));
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
      onChanged: (value) {
        context
            .read<AuthBloc>()
            .add(AccountNumberChanged(accountNumber: value));
        context.read<CheckBankAccountCubit>().accountNumber = value;
        if (value.length >= 10) {
          context.read<CheckBankAccountCubit>().checkBankAccount();
        }
      },
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
