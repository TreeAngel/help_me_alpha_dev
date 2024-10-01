part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<dynamic> get props => [];
}

class FetchProfile extends ProfileEvent {}

class EditProfile extends ProfileEvent {
  final String fullname;
  final String username;
  final String phoneNumber;
  final XFile? imageProfile;

  const EditProfile({
    required this.fullname,
    required this.username,
    required this.phoneNumber,
    this.imageProfile,
  });

  @override
  List<dynamic> get props => [fullname, username, phoneNumber, imageProfile];
}

class ProfileIsIdle extends ProfileEvent {}
