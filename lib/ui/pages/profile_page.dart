import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/profile_bloc/profile_bloc.dart';
import '../../configs/app_colors.dart';
import '../../models/user_model.dart';
import '../../services/api/api_controller.dart';
import '../../utils/manage_auth_token.dart';
import '../../utils/show_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? profile;

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
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(500, 250),
                    topRight: Radius.elliptical(500, 250),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listener: _profileBlocListener,
                builder: (context, state) {
                  if (state is ProfileInitial || profile == null) {
                    context.read<ProfileBloc>().add(FetchProfile());
                  }
                  if (state is ProfileLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(
                      top: (screenHeight / 20),
                      left: 20,
                      right: 20,
                    ),
                    child: RefreshIndicator(
                      triggerMode: RefreshIndicatorTriggerMode.onEdge,
                      onRefresh: () async {
                        context.read<ProfileBloc>().add(FetchProfile());
                      },
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Center(
                              child: _profileSummarySection(textTheme),
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 20)),
                          SliverToBoxAdapter(child: _fullnameText(textTheme)),
                          const SliverToBoxAdapter(child: SizedBox(height: 10)),
                          SliverToBoxAdapter(child: _usernameText(textTheme)),
                          const SliverToBoxAdapter(child: SizedBox(height: 10)),
                          SliverToBoxAdapter(
                              child: _phoneNumberSection(textTheme)),
                          const SliverToBoxAdapter(child: SizedBox(height: 20)),
                          SliverToBoxAdapter(child: _editProfileBtn(textTheme)),
                          const SliverToBoxAdapter(child: SizedBox(height: 20)),
                          SliverToBoxAdapter(child: _keamananText(textTheme)),
                          const SliverToBoxAdapter(child: SizedBox(height: 10)),
                          SliverToBoxAdapter(
                              child: _passwordSection(textTheme)),
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

  Row _passwordSection(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _passwordText(textTheme),
        _passwordBtn(textTheme),
      ],
    );
  }

  SizedBox _passwordBtn(TextTheme textTheme) {
    return SizedBox(
      width: 90,
      height: 40,
      child: OutlinedButton(
        style: ButtonStyle(
          side: const WidgetStatePropertyAll(
            BorderSide(
              color: AppColors.surface,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: () {}, // TODO: Implement edit password
        child: Text(
          'Ubah',
          style: textTheme.labelLarge?.copyWith(
            fontSize: 13,
            color: AppColors.darkTextColor,
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
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: '********',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.darkTextColor,
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
        color: AppColors.darkTextColor,
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
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {}, // TODO: Implement edit profile
      ),
    );
  }

  Row _phoneNumberSection(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _phoneNumberText(textTheme),
        profile?.phoneNumberVerifiedAt != null
            ? _numberVerified()
            : _numberNotVerified(textTheme),
      ],
    );
  }

  SizedBox _numberNotVerified(TextTheme textTheme) {
    return SizedBox(
      width: 90,
      height: 40,
      child: TextButton(
        onPressed: () {}, // TODO: Implement number verification
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
          'Verifikasi',
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

  Icon _numberVerified() {
    return const Icon(
      Icons.verified_user,
      color: Colors.greenAccent,
    );
  }

  Text _phoneNumberText(TextTheme textTheme) {
    return Text.rich(
      TextSpan(
        text: 'Nomor Telepon\n',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: profile?.phoneNumber ?? 'Reload untuk menampilkan data',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.darkTextColor,
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
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: profile?.username ?? 'Reload untuk menampilkan data',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.darkTextColor,
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
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: profile?.fullName ?? 'Reload untuk menampilkan data',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.darkTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _profileBlocListener(context, state) {
    if (state is ProfileError) {
      _onStateError(context, state);
    }
    if (state is ProfileLoaded) {
      profile = state.data.user;
    }
    if (state is ProfileEdited) _onProfileEdited(context, state);
  }

  void _onProfileEdited(BuildContext context, ProfileEdited state) {
    {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowDialog.showAlertDialog(
          context,
          'Berhasil!',
          state.message,
          null,
        );
        profile = state.data.user;
        context.read<ProfileBloc>().add(ProfileIsIdle());
      });
    }
  }

  void _onStateError(BuildContext context, ProfileError state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowDialog.showAlertDialog(
        context,
        'Error saat memproses profile',
        state.errorMessage,
        state.errorMessage.toString().toLowerCase().contains('unauthorized')
            ? OutlinedButton.icon(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ManageAuthToken.deleteToken();
                    context.read<AuthBloc>().add(RetryAuthState());
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
                  context.read<ProfileBloc>().add(FetchProfile());
                },
                icon: const Icon(Icons.refresh_outlined),
              ),
      );
      context.read<ProfileBloc>().add(ProfileIsIdle());
    });
  }

  Column _profileSummarySection(TextTheme textTheme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 83,
          backgroundColor: AppColors.surface,
          child: CircleAvatar(
            radius: 80,
            backgroundImage: profile?.imageProfile != null
                ? CachedNetworkImageProvider(
                    '${ApiController.temporaryUrl}/${profile!.imageProfile}',
                    maxWidth: 150,
                    maxHeight: 150,
                  )
                : const AssetImage('assets/images/man1.png'),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          profile?.fullName ?? 'Fullname',
          style: textTheme.titleLarge?.copyWith(
              color: AppColors.darkTextColor, fontWeight: FontWeight.w600),
        ),
        // const SizedBox(height: 10),
        Text(
          profile?.username ?? 'Username',
          style: textTheme.titleMedium?.copyWith(
              color: AppColors.darkTextColor, fontWeight: FontWeight.normal),
        ),
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
