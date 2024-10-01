part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileIdle extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final DataUser data;

  const ProfileLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

final class ProfileError extends ProfileState {
  final String errorMessage;

  const ProfileError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class ProfileEdited extends ProfileState {
  final String message;
  final DataUser data;

  const ProfileEdited({required this.message, required this.data});

  @override
  List<Object> get props => [message, data];
}
