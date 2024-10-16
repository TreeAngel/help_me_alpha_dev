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
  fullname,
  username,
}

class FormDataMitraPage extends StatelessWidget {
  @override
  
 FormDataMitraPage({super.key});

  String? _selectedMitraType;

  final List<DropdownMenuItem<String>> _items = [
    DropdownMenuItem<String>(
      value: '1',
      child: Text('Serabutan'),
    ),
    DropdownMenuItem<String>(
      value: '2',
      child: Text('Kendaraan'),
    ),
    // DropdownMenuItem<String>(
    //   value: '3',
    //   child: Text('Rumah'),
    // ),
    // DropdownMenuItem<String>(
    //   value: '4',
    //   child: Text('Elektronik'),
    // ),
    // DropdownMenuItem<String>(
    //   value: '4',
    //   child: Text('Personal'),
    // ),
  ];

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
                      'Daftar Mitra',
                      style: textTheme.headlineLarge?.copyWith(
                          color: AppColors.darkTextColor,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        // String? _selectedValue = state.selectedValue;
                        // if(state is MitraTypeSeectedState){
                        //   _selectedValue = state.selectedType;
                        // }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Usaha',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _textInputField(
                                context,
                                textTheme,
                                'Masukkan nama usaha',
                                TextInputEvent.fullname),
                            const SizedBox(height: 10),
                            Text(
                              'Nama Usaha',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _textInputField(context, textTheme,
                                'Masukan username', TextInputEvent.username),
                            const SizedBox(height: 10),
                            

                            //TODO MITRA TYPE
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Pilih Kategori Bantuan yang akan dikerjakan',
                                labelStyle: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder()
                              ),
                              value: _selectedMitraType,
                              hint: Text('Pilih Kategori'),
                              items: _items,
                              onChanged: (value){
                                if (value != null) {
                                  print("Mitra Type terpilih: $value");
                                  BlocProvider.of<AuthBloc>(context).add(
                                    MitraTypeChanged(mitraType: value),
                                  );
                                }
                              }
                            ),
                            //TODO PICK LOCATION

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
                                  color: AppColors.primary,
                                ),
                              ),
                            ] else ...[
                              _signUpButton(textTheme, context, state),
                            ],
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
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          context.read<AuthBloc>().add(SignUpSubmitted());
        },
      ),
    );
  }

  DropdownButtonFormField<String> _dropdownInputField(
    BuildContext context, TextTheme textTheme, String hintText, List<String> items, String? selectedItem, Function(String?) onChanged) {
  return DropdownButtonFormField<String>(
    value: selectedItem,
    hint: Text(
      hintText,
      style: textTheme.bodyLarge?.copyWith(color: AppColors.hintTextColor),
    ),
    onChanged: onChanged,
    items: items.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.greyinput),
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
            TextInputEvent.fullname => FullNameChanged(textInput),
            TextInputEvent.username => UsernameChanged(textInput),
          }),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
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
