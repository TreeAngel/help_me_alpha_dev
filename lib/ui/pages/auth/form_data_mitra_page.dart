import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_me_mitra_alpha_ver/cubits/profile/profile_cubit.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../cubits/check_bank_account/check_bank_account_cubit.dart';
import '../../../cubits/home/home_cubit.dart';
import '../../../data/bank_code.dart';
import '../../../services/location_service.dart';
import '../../widgets/custom_dialog.dart';

class FormDataMitraPage extends StatefulWidget {
  const FormDataMitraPage({super.key});

  @override
  State<FormDataMitraPage> createState() => _FormDataMitraPageState();
}

class _FormDataMitraPageState extends State<FormDataMitraPage> {
  final MapController _showedMapController = MapController(
    initPosition: GeoPoint(
      latitude: -6.917421657525377,
      longitude: 107.61912406584922,
    ),
  );
  GeoPoint? pickedLocation;

  @override
  void dispose() {
    _showedMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
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
                      'Daftarkan informasi usaha anda',
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.darkTextColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Nama usaha',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _nameInputField(
                      context,
                      textTheme,
                      'Masukkan nama usaha',
                    ),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is SignUpMitraLoaded) {
                          _stateLoaded(context);
                        }
                        if (state is SignUpMitraError) {
                          _stateError(context, state.message);
                        }
                        if (state is HelperIdChanged) {
                          context.read<AuthBloc>().add(AuthIsIdle());
                        }
                      },
                      builder: (context, state) {
                        if (context.read<HomeCubit>().categories.isEmpty) {
                          context.read<HomeCubit>().fetchCategories();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              'Kategori Usaha',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _kategoriMitraDropdownMenu(textTheme, context),
                            const SizedBox(height: 10),
                            Text(
                              'Spesialisasi Usaha',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _helperConsumer(textTheme),
                            const SizedBox(height: 10),
                            Text(
                              'Lokasi usaha',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _showedMap(screenWidth),
                            const SizedBox(height: 15),
                            _pickLoactionBtn(context, textTheme),
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

  SizedBox _pickLoactionBtn(BuildContext context, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: ElevatedButton(
        onPressed: () => _pickLocation(
          context,
          textTheme,
        ),
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          'Cari lokasi',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.lightTextColor,
          ),
        ),
      ),
    );
  }

  LimitedBox _showedMap(double screenWidht) {
    return LimitedBox(
      maxWidth: screenWidht,
      maxHeight: 250,
      child: OSMFlutter(
        controller: _showedMapController,
        mapIsLoading: const Center(
          child: CircularProgressIndicator(),
        ),
        osmOption: const OSMOption(
          zoomOption: ZoomOption(
            initZoom: 10,
            stepZoom: 2,
            minZoomLevel: 2,
            maxZoomLevel: 19,
          ),
          showZoomController: true,
          showContributorBadgeForOSM: true,
          enableRotationByGesture: true,
        ),
      ),
    );
  }

  void _pickLocation(BuildContext context, TextTheme textTheme) async {
    await LocationService.fetchLocation(context);
    if (!context.mounted) return;
    pickedLocation = await showSimplePickerLocation(
      context: context,
      titleWidget: Text(
        'Lokasi Usaha',
        textAlign: TextAlign.center,
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
        ),
      ),
      textCancelPicker: 'Batal',
      textConfirmPicker: 'Pilih',
      radius: 10,
      contentPadding: const EdgeInsets.all(8),
      zoomOption: const ZoomOption(
        initZoom: 19,
        stepZoom: 2,
        minZoomLevel: 2,
        maxZoomLevel: 19,
      ),
      initPosition: GeoPoint(
        latitude: LocationService.lat ?? 0,
        longitude: LocationService.long ?? 0,
      ),
    );
    if (pickedLocation != null) {
      if (!context.mounted) return;
      context.read<AuthBloc>().add(MitraLocationPicked(
            location: pickedLocation!,
          ));
      Future.delayed(Durations.long2, () {
        if (!context.mounted) return;
        _showedMapController.removeMarker(pickedLocation!);
        if (!context.mounted) return;
        _showedMapController.moveTo(
          pickedLocation!,
          animate: true,
        );
        if (!context.mounted) return;
        _showedMapController.addMarker(
          pickedLocation!,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on_sharp,
              color: AppColors.vividRed,
            ),
          ),
        );
        if (!context.mounted) return;
        _showedMapController.setZoom(
          zoomLevel: 19,
        );
      });
    }
  }

  BlocConsumer<HomeCubit, HomeState> _helperConsumer(TextTheme textTheme) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HelperLoaded) {
          context.read<HomeCubit>().helpers = state.helpers;
        }
        if (state is HelperError) {
          CustomDialog.showAlertDialog(
            context,
            'Gagal mengambil helper!',
            state.message,
            null,
          );
          context.read<HomeCubit>().homeIdle();
        }
      },
      builder: (context, state) {
        if (state is HelperLoaded &&
            context.read<HomeCubit>().helpers.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(
                'Spesialisasi anda pada kategori yang dipilih, ambil yang menurut anda paling sesuai!',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.darkTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              _helperMultiSelect(context),
            ],
          );
        }
        if (state is! HelperLoaded ||
            context.read<HomeCubit>().helpers.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Pilih kategori terlebih dahulu',
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.darkTextColor,
                ),
              )
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Center _helperMultiSelect(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 5,
        children: context.read<HomeCubit>().helpers.map((helper) {
          return FilterChip(
            label: Text(helper.name),
            selected: context.read<AuthBloc>().helpersId.contains(helper),
            onSelected: (selected) {
              if (selected) {
                context.read<AuthBloc>().add(HelperIdAdded(
                      helper: helper,
                    ));
              } else {
                context.read<AuthBloc>().add(HelperIdRemoved(
                      helper: helper,
                    ));
              }
            },
          );
        }).toList(),
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
          context.read<HomeCubit>().fetchHelpers(context
              .read<HomeCubit>()
              .categories
              .firstWhere((category) => category.id == value)
              .name);
        },
        dropdownMenuEntries: context
            .read<HomeCubit>()
            .categories
            .sublist(0, 2)
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

  _stateError(BuildContext context, String message) {
    CustomDialog.showAlertDialog(
      context,
      'Peringatan!',
      message,
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
          context.read<ProfileCubit>().fetchProfile();
          context.read<HomeCubit>().fetchHistory();
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
      backgroundColor: Colors.black,
      foregroundColor: AppColors.darkTextColor,
      title: Text(
        'HelpMe!\nMitra',
        textAlign: TextAlign.center,
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
