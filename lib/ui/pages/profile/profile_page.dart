import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../cubits/profile/profile_cubit.dart';
import '../../../configs/app_colors.dart';
import '../../../models/auth/user_mitra_model.dart';
import '../../../models/auth/user_model.dart';
import '../../../utils/manage_token.dart';
import '../../widgets/custom_dialog.dart';

enum ProfileSegment { user, mitra }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? userProfile;
  UserMitraModel? mitraProfile;
  ProfileSegment currentSegment = ProfileSegment.user;
  final MapController _showedMapController = MapController(
    initPosition: GeoPoint(
      latitude: -6.917421657525377,
      longitude: 107.61912406584922,
    ),
  );

  @override
  void dispose() {
    _showedMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    userProfile = context.read<ProfileCubit>().userProfile;
    mitraProfile = context.read<ProfileCubit>().userMitra;

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
                  color: Colors.white,
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
                  if (state is ProfileError) {
                    _onStateError(context, state);
                  }
                  if (state is ProfileLoaded) {
                    userProfile = state.userProfile.user;
                    context.read<ProfileCubit>().userProfile =
                        state.userProfile.user;
                  }
                  if (state is ProfileSegmentChanged) {
                    context.read<ProfileCubit>().profileIsIdle();
                    currentSegment = state.segment;
                    if (state.segment == ProfileSegment.mitra) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mitraProfile != null) {
                          Future.delayed(Durations.long2, () {
                            _showedMapController.moveTo(
                              GeoPoint(
                                latitude: mitraProfile?.latitude ?? 0,
                                longitude: mitraProfile?.longitude ?? 0,
                              ),
                              animate: true,
                            );
                            _showedMapController.setZoom(stepZoom: 9);
                            _showedMapController.addMarker(
                              GeoPoint(
                                latitude: mitraProfile?.latitude ?? 0,
                                longitude: mitraProfile?.longitude ?? 0,
                              ),
                            );
                          });
                        }
                      });
                    }
                  }
                },
                builder: (context, state) {
                  if (userProfile == null) {
                    context.read<ProfileCubit>().fetchProfile();
                  }
                  if (state is ProfileLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(
                      top: (screenHeight / 30),
                      left: 20,
                      right: 20,
                    ),
                    child: RefreshIndicator(
                      triggerMode: RefreshIndicatorTriggerMode.onEdge,
                      onRefresh: () async {
                        context.read<ProfileCubit>().fetchProfile();
                      },
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Center(
                              child: _profileSummarySection(textTheme),
                            ),
                          ),
                          _pageSegmentBtn(context),
                          switch (currentSegment) {
                            ProfileSegment.user => SliverToBoxAdapter(
                                child: _profileSegment(context, textTheme),
                              ),
                            ProfileSegment.mitra => SliverToBoxAdapter(
                                child: _mitraSegment(textTheme, screenWidth),
                              ),
                          }
                        ],
                      ),
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

  Column _mitraSegment(TextTheme textTheme, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _namaUsahaText(textTheme),
        const SizedBox(height: 10),
        _lokasiUsahaMap(textTheme, screenWidth),
        const SizedBox(height: 20),
        _kategoriUsahaText(textTheme),
        const SizedBox(height: 10),
        _spesialisasiUsahaChip(textTheme),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 42,
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
              context.read<ProfileCubit>().userMitra != null
                  ? 'Ubah data'
                  : 'Isi data',
              style: textTheme.titleSmall?.copyWith(
                color: AppColors.darkTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => context.read<ProfileCubit>().userMitra != null
                ? context.pushNamed('editMitraProfilePage')
                : context
                            .read<ProfileCubit>()
                            .userProfile
                            ?.phoneNumberVerifiedAt !=
                        null
                    ? context.pushNamed('formDataMitraPage')
                    : CustomDialog.showAlertDialog(
                        context,
                        'Verifikasi Nomor!',
                        'Verifikasi nomor telpon terlebih dahulu',
                        null,
                      ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Text _spesialisasiUsahaChip(TextTheme textTheme) {
    return Text.rich(
      TextSpan(
        text: 'Spesialisasi Usaha\n',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          WidgetSpan(
            child: Wrap(
              spacing: 5,
              children: mitraProfile?.helpers != null &&
                      mitraProfile!.helpers!.isNotEmpty
                  ? mitraProfile!.helpers!.map((helper) {
                      return Chip(
                        label: Text(
                          helper.name,
                        ),
                      );
                    }).toList()
                  : [
                      Text(
                        'Anda mungkin belum memilih spesialisasi usaha anda',
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.lightTextColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
            ),
          )
        ],
      ),
    );
  }

  Text _kategoriUsahaText(TextTheme textTheme) {
    return Text.rich(
      TextSpan(
        text: 'Kategori Usaha\n',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: mitraProfile?.category ?? 'Anda belum mengisi data mitra',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.lightTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Text _lokasiUsahaMap(TextTheme textTheme, double screenWidth) {
    return Text.rich(
      TextSpan(
        text: 'Lokasi Usaha\n',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          WidgetSpan(
            child: LimitedBox(
              maxWidth: screenWidth,
              maxHeight: 250,
              child: OSMFlutter(
                controller: _showedMapController,
                osmOption: OSMOption(
                  zoomOption: ZoomOption(
                    stepZoom: 2,
                    initZoom: mitraProfile?.latitude != null ? 19 : 10,
                  ),
                  showZoomController: true,
                  showContributorBadgeForOSM: true,
                ),
                mapIsLoading: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text _namaUsahaText(TextTheme textTheme) {
    return Text.rich(
      TextSpan(
        text: 'Nama Usaha\n',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: mitraProfile?.name ?? 'Anda belum mengisi data mitra',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.lightTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileSegment(BuildContext context, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _fullnameText(textTheme),
        const SizedBox(height: 10),
        _usernameText(textTheme),
        const SizedBox(height: 10),
        _phoneNumberSection(context, textTheme),
        const SizedBox(height: 20),
        _editProfileBtn(textTheme),
        const SizedBox(height: 20),
        _keamananText(textTheme),
        const SizedBox(height: 10),
        _passwordSection(textTheme),
      ],
    );
  }

  SliverToBoxAdapter _pageSegmentBtn(BuildContext context) {
    return SliverToBoxAdapter(
      child: SegmentedButton<ProfileSegment>(
        style: SegmentedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: AppColors.lightTextColor,
          selectedBackgroundColor: AppColors.primary,
          selectedForegroundColor: AppColors.darkTextColor,
          shadowColor: Colors.black54,
        ),
        segments: const <ButtonSegment<ProfileSegment>>[
          ButtonSegment<ProfileSegment>(
            value: ProfileSegment.user,
            label: Text('Profile'),
          ),
          ButtonSegment<ProfileSegment>(
            value: ProfileSegment.mitra,
            label: Text('Usaha'),
          ),
        ],
        selected: <ProfileSegment>{currentSegment},
        onSelectionChanged: (segment) async {
          if (currentSegment != segment.first) {
            context.read<ProfileCubit>().changeSegment(segment.first);
            await Future.delayed(Durations.long2);
          }
        },
      ),
    );
  }

  Row _passwordSection(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _passwordText(textTheme),
        _changePasswordBtn(textTheme),
      ],
    );
  }

  SizedBox _changePasswordBtn(TextTheme textTheme) {
    return SizedBox(
      width: 90,
      height: 40,
      child: OutlinedButton(
        style: const ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(color: AppColors.hintTextColor),
          ),
        ),
        onPressed: () => context.pushNamed('changePasswordPage'),
        child: Text(
          'Ubah',
          style: textTheme.labelLarge?.copyWith(
            fontSize: 13,
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.w100,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Text _passwordText(TextTheme textTheme) {
    return Text.rich(
      TextSpan(
        text: 'Password\n',
        style: textTheme.titleMedium?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: '********',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.lightTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Text _keamananText(TextTheme textTheme) {
    return Text(
      'Keamanan',
      style: textTheme.titleLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  SizedBox _editProfileBtn(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 42,
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
          'Ubah data',
          style: textTheme.titleSmall?.copyWith(
            color: AppColors.darkTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => context.pushNamed('editUserProfilePage'),
      ),
    );
  }

  Row _phoneNumberSection(BuildContext context, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _phoneNumberText(textTheme),
        userProfile?.phoneNumberVerifiedAt != null
            ? _numberVerified(textTheme)
            : _numberNotVerified(context, textTheme),
      ],
    );
  }

  SizedBox _numberNotVerified(BuildContext context, TextTheme textTheme) {
    return SizedBox(
      width: 100,
      height: 40,
      child: OutlinedButton(
        onPressed: () {
          context.read<ProfileCubit>().fullname =
              userProfile!.fullName.toString();
          context.read<ProfileCubit>().username =
              userProfile!.username.toString();
          context.read<ProfileCubit>().phoneNumber =
              userProfile!.phoneNumber.toString();
          context.pushNamed('verifyPhoneNumberPage');
        },
        style: const ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(
              color: AppColors.primary,
            ),
          ),
        ),
        child: Text(
          'Verifikasi',
          style: textTheme.labelLarge?.copyWith(
            fontSize: 10,
            color: AppColors.primary,
            fontWeight: FontWeight.w100,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Row _numberVerified(TextTheme textTheme) {
    return Row(
      children: [
        Text(
          'Terverifikasi',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        const Icon(
          Icons.verified_user,
          color: Colors.greenAccent,
        ),
      ],
    );
  }

  Text _phoneNumberText(TextTheme textTheme) {
    return Text.rich(
      TextSpan(
        text: 'Nomor Telepon\n',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: userProfile?.phoneNumber ?? 'Reload untuk menampilkan data',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.lightTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Text _usernameText(TextTheme textTheme) {
    return Text.rich(
      TextSpan(
        text: 'Username\n',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: userProfile?.username ?? 'Reload untuk menampilkan data',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.lightTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Text _fullnameText(TextTheme textTheme) {
    return Text.rich(
      TextSpan(
        text: 'Nama Lengkap\n',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: userProfile?.fullName ?? 'Reload untuk menampilkan data',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.lightTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _onStateError(BuildContext context, ProfileError state) {
    CustomDialog.showAlertDialog(
      context,
      'Error saat memproses profile',
      state.errorMessage,
      state.errorMessage.toString().toLowerCase().contains('unauthorized')
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
          : IconButton.outlined(
              onPressed: () {
                context.pop();
                context.read<ProfileCubit>().fetchProfile();
              },
              icon: const Icon(Icons.refresh_outlined),
            ),
    );
    context.read<ProfileCubit>().profileIsIdle();
  }

  Column _profileSummarySection(TextTheme textTheme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 83,
          backgroundColor: AppColors.surface,
          child: CircleAvatar(
            radius: 80,
            backgroundImage: userProfile?.imageProfile != null
                ? CachedNetworkImageProvider(
                    userProfile?.imageProfile ??
                        'https://st2.depositphotos.com/1561359/12101/v/950/depositphotos_121012076-stock-illustration-blank-photo-icon.jpg',
                    maxWidth: 150,
                    maxHeight: 150,
                  )
                : const AssetImage('assets/images/man1.png'),
          ),
        ),
        const SizedBox(height: 10),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            switch (currentSegment) {
              case ProfileSegment.user:
                return Column(
                  children: [
                    Text(
                      userProfile?.fullName ?? 'Fullname',
                      style: textTheme.titleLarge?.copyWith(
                          color: AppColors.lightTextColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      userProfile?.username ?? 'Username',
                      style: textTheme.titleMedium?.copyWith(
                          color: AppColors.lightTextColor,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                );
              case ProfileSegment.mitra:
                return Text(
                  mitraProfile?.name ?? 'Nama Usaha',
                  style: textTheme.titleLarge?.copyWith(
                      color: AppColors.lightTextColor,
                      fontWeight: FontWeight.w600),
                );
            }
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.lightTextColor,
      title: Text(
        'Profile',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
