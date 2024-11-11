import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../cubits/home/home_cubit.dart';
import '../../../cubits/profile/profile_cubit.dart';
import '../../../models/auth/user_mitra_model.dart';
import '../../../models/category_problem/category_model.dart';
import '../../../utils/manage_token.dart';
import '../../widgets/custom_dialog.dart';

class EditMitraProfilePage extends StatefulWidget {
  const EditMitraProfilePage({super.key});

  @override
  State<EditMitraProfilePage> createState() => _EditMitraProfilePageState();
}

class _EditMitraProfilePageState extends State<EditMitraProfilePage> {
  UserMitraModel? profile;
  final MapController _showedMapController = MapController(
    initPosition: GeoPoint(
      latitude: -6.917421657525377,
      longitude: 107.61912406584922,
    ),
  );
  GeoPoint? pickedLocation;
  List<CategoryModel> helpers = [];

  final _mitraNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    profile = context.read<ProfileCubit>().userMitra;
    pickedLocation = GeoPoint(
      latitude: profile?.latitude ?? 0,
      longitude: profile?.longitude ?? 0,
    );
    helpers = profile?.helpers ?? [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pickedLocation != null) {
        _moveMap();
      }
    });
    _mitraNameController.text = profile!.name.toString();
  }

  Future<Null> _moveMap() {
    return Future.delayed(Durations.long2, () {
      _showedMapController.moveTo(
        GeoPoint(
          latitude: pickedLocation?.latitude ?? 0,
          longitude: pickedLocation?.longitude ?? 0,
        ),
        animate: true,
      );
      _showedMapController.setZoom(stepZoom: 9);
      _showedMapController.addMarker(
        GeoPoint(
          latitude: pickedLocation?.latitude ?? 0,
          longitude: pickedLocation?.longitude ?? 0,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: _appBar(context, textTheme),
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              width: screenWidth,
              height: screenHeight / 1.32,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(500, 250),
                    topRight: Radius.elliptical(500, 250),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: BlocConsumer<ProfileCubit, ProfileState>(
                listener: (context, state) {
                  if (state is EditProfileError) {
                    _onStateError(context, state.message);
                  }
                  if (state is MitraProfileEdited) {
                    _onProfileEdited(context, state);
                  }
                  if (state is EditPasswordError) {
                    _onStateError(context, state.errorMessage);
                  }
                  if (state is MitraLocationUpdated) {
                    pickedLocation = state.newLocation;
                    context.read<ProfileCubit>().profileIsIdle();
                    _moveMap();
                  }
                  if (state is HelpersChanged) {
                    context.read<ProfileCubit>().profileIsIdle();
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: (screenHeight / 30),
                      left: 20,
                      right: 20,
                    ),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Center(
                            child: _profileImage(),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        SliverToBoxAdapter(child: _mitraNameText(textTheme)),
                        const SliverToBoxAdapter(child: SizedBox(height: 10)),
                        SliverToBoxAdapter(
                          child: _mitraNameInputField(context, textTheme),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 15)),
                        SliverToBoxAdapter(child: _locationText(textTheme)),
                        const SliverToBoxAdapter(child: SizedBox(height: 10)),
                        SliverToBoxAdapter(
                          child: _locationMapInputField(
                              screenWidth, context, textTheme),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 15)),
                        SliverToBoxAdapter(child: _helpersText(textTheme)),
                        const SliverToBoxAdapter(child: SizedBox(height: 10)),
                        SliverToBoxAdapter(
                          child: BlocConsumer<HomeCubit, HomeState>(
                            listener: (context, state) {
                              if (state is HelperLoaded) {
                                context.read<HomeCubit>().helpers =
                                    state.helpers;
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
                                  context
                                      .read<HomeCubit>()
                                      .helpers
                                      .isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(
                                      'Spesialisasi anda pada kategori yang dipilih, ambil yang menurut anda paling sesuai!',
                                      style: textTheme.labelSmall?.copyWith(
                                        color: AppColors.lightTextColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _helperMultiSelect(context),
                                  ],
                                );
                              } else {
                                context.read<HomeCubit>().fetchHelpers(
                                      profile?.category ?? '',
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
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        if (state is ProfileLoading) ...{
                          const SliverToBoxAdapter(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        } else ...{
                          SliverToBoxAdapter(child: _editProfileBtn(textTheme)),
                        },
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Center _helperMultiSelect(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 5,
        children: context.read<HomeCubit>().helpers.map((helper) {
          return FilterChip(
            label: Text(helper.name),
            selected: helpers.contains(helper),
            onSelected: (selected) {
              if (selected) {
                context.read<ProfileCubit>().helperAdded(helper);
              } else {
                context.read<ProfileCubit>().helperRemoved(helper);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Column _locationMapInputField(
      double screenWidth, BuildContext context, TextTheme textTheme) {
    return Column(
      children: [
        _showedMap(screenWidth),
        const SizedBox(height: 15),
        _pickLocationBtn(context, textTheme),
      ],
    );
  }

  SizedBox _pickLocationBtn(BuildContext context, TextTheme textTheme) {
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
          'Ubah lokasi',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.lightTextColor,
          ),
        ),
      ),
    );
  }

  LimitedBox _showedMap(double screenWidth) {
    return LimitedBox(
      maxWidth: screenWidth,
      maxHeight: 250,
      child: OSMFlutter(
        controller: _showedMapController,
        mapIsLoading: const Center(
          child: CircularProgressIndicator(),
        ),
        osmOption: OSMOption(
          zoomOption: ZoomOption(
            initZoom: pickedLocation?.latitude != null ? 19 : 10,
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
        latitude: pickedLocation?.latitude ?? 0,
        longitude: pickedLocation?.longitude ?? 0,
      ),
    );
    if (pickedLocation != null) {
      if (!context.mounted) return;
      context.read<ProfileCubit>().mitraLocationUpdated(pickedLocation!);
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

  TextFormField _mitraNameInputField(
      BuildContext context, TextTheme textTheme) {
    return TextFormField(
      controller: _mitraNameController,
      onChanged: (value) {
        _mitraNameController.text = value;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Masukkan nama usaha',
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

  SizedBox _editProfileBtn(TextTheme textTheme) {
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
          'Simpan',
          style: textTheme.titleSmall?.copyWith(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          context.read<ProfileCubit>().mitraName = _mitraNameController.text;
          context.read<ProfileCubit>().mitraLocation = pickedLocation;
          context.read<ProfileCubit>().helpers = helpers;
          context.read<ProfileCubit>().editMitraProfile();
        },
      ),
    );
  }

  Text _helpersText(TextTheme textTheme) {
    return Text(
      'Spesialisasi Usaha',
      style: textTheme.titleLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Text _locationText(TextTheme textTheme) {
    return Text(
      'Lokasi Usaha',
      style: textTheme.titleLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Text _mitraNameText(TextTheme textTheme) {
    return Text(
      'Nama Usaha',
      style: textTheme.titleLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _onProfileEdited(BuildContext context, MitraProfileEdited state) {
    CustomDialog.showAlertDialog(
      context,
      'Berhasil!',
      state.message,
      null,
    );
    profile = state.data;
    context.read<ProfileCubit>().fetchProfile();
  }

  void _onStateError(BuildContext context, String message) {
    CustomDialog.showAlertDialog(
      context,
      'Gagal!',
      message,
      message.toString().toLowerCase().contains('unauthorized')
          ? OutlinedButton.icon(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ManageAuthToken.deleteToken();
                  context.read<AuthBloc>().add(AuthIsIdle());
                  context.goNamed('signInPage');
                });
              },
              label: const Text('Sign In ulang'),
              icon: const Icon(Icons.arrow_forward_ios),
              iconAlignment: IconAlignment.end,
            )
          : null,
    );
    context.read<ProfileCubit>().profileIsIdle();
  }

  CircleAvatar _profileImage() {
    return CircleAvatar(
      radius: 83,
      backgroundColor: AppColors.surface,
      child: CircleAvatar(
        radius: 80,
        backgroundImage:
            context.read<ProfileCubit>().userProfile?.imageProfile != null
                ? CachedNetworkImageProvider(
                    context.read<ProfileCubit>().userProfile?.imageProfile ??
                        'https://st2.depositphotos.com/1561359/12101/v/950/depositphotos_121012076-stock-illustration-blank-photo-icon.jpg',
                    maxWidth: 150,
                    maxHeight: 150,
                  )
                : const AssetImage('assets/images/man1.png'),
      ),
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.lightTextColor,
      title: Text(
        'Edit Mitra Profile',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
