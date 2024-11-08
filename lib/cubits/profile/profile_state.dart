part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileIdle extends ProfileState {}

final class ProfileSegmentChanged extends ProfileState {
  final ProfileSegment segment;

  const ProfileSegmentChanged({required this.segment});

  @override
  List<Object?> get props => [segment];
}

final class ProfileDisposed extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final DataUser userProfile;

  const ProfileLoaded({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

final class MitraLoaded extends ProfileState {
  final UserMitraModel mitra;

  const MitraLoaded({required this.mitra});

  @override
  List<Object> get props => [mitra];
}

final class ProfileError extends ProfileState {
  final String errorMessage;

  const ProfileError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class UserProfileEdited extends ProfileState {
  final String message;
  final UserModel data;

  const UserProfileEdited({required this.message, required this.data});

  @override
  List<Object> get props => [message, data];
}

final class MitraProfileEdited extends ProfileState {
  final String message;
  final UserMitraModel data;

  const MitraProfileEdited({required this.message, required this.data});

  @override
  List<Object> get props => [message, data];
}

final class EditProfileError extends ProfileState {
  final String message;

  const EditProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class EditPasswordLoaded extends ProfileState {
  final String message;

  const EditPasswordLoaded({required this.message});

  @override
  List<Object> get props => [message];
}

final class EditPasswordError extends ProfileState {
  final String errorMessage;

  const EditPasswordError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class ImagePicked extends ProfileState {
  final XFile? pickedImage;

  const ImagePicked({required this.pickedImage});

  @override
  List<Object?> get props => [pickedImage];
}

final class OTPRequested extends ProfileState {
  final String message;

  const OTPRequested({required this.message});

  @override
  List<Object?> get props => [message];
}

final class OTPError extends ProfileState {
  final String errorMessage;

  const OTPError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class OTPLoading extends ProfileState {}

final class OTPVerified extends ProfileState {
  final String message;

  const OTPVerified({required this.message});

  @override
  List<Object?> get props => [message];
}

final class MitraLocationUpdated extends ProfileState {
  final GeoPoint newLocation;

  const MitraLocationUpdated({required this.newLocation});

  @override
  List<Object?> get props => [newLocation];
}

final class HelpersChanged extends ProfileState {
  final CategoryModel helper;

  const HelpersChanged({required this.helper});

  @override
  List<Object?> get props => [helper];
}
