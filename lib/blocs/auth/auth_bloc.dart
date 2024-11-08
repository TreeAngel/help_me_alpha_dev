import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:help_me_mitra_alpha_ver/models/category_problem/category_model.dart';

import '../../cubits/check_bank_account/check_bank_account_cubit.dart';
import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/auth/auth_response_model.dart';
import '../../models/auth/login_model.dart';
import '../../models/auth/register_model.dart';
import '../../services/api/api_controller.dart';
import '../../services/api/api_helper.dart';
import '../../services/firebase/firebase_api.dart';
import '../../utils/manage_token.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final role = 'mitra';

  String fullName = '';
  String username = '';
  String password = '';
  String passwordConfirmation = '';
  String phoneNumber = '';
  bool isPasswordVisible = false;

  String mitraName = '';
  int categoryId = 0;
  String accountNumber = '';
  GeoPoint? mitraLocation;
  List<CategoryModel> helpersId = [];

  AuthBloc() : super(AuthInitial()) {
    on<FullNameChanged>(
      (event, emit) => fullName = event.fullName.trim(),
    );

    on<UsernameChanged>(
      (event, emit) => username = event.username.trim(),
    );

    on<PhoneNumberChanged>(
      (event, emit) => phoneNumber = event.phoneNumber.trim(),
    );

    on<PasswordChanged>(
      (event, emit) => password = event.password.trim(),
    );

    on<ConfirmPasswordChanged>(
      (event, emit) => passwordConfirmation = event.confirmPassword.trim(),
    );

    on<MitraNameChanged>(
      (event, emit) => mitraName = event.mitraName.trim(),
    );

    on<CategoryIdChanged>(
      (event, emit) => categoryId = event.categoryId,
    );

    on<AccountNumberChanged>(
      (event, emit) => accountNumber = event.accountNumber.trim(),
    );

    on<HelperIdAdded>((event, emit) {
      if (!helpersId.contains(event.helper)) {
        helpersId.add(event.helper);
        log(helpersId.join(', '));
        emit(HelperIdChanged());
      }
    });

    on<HelperIdRemoved>((event, emit) {
      if (helpersId.contains(event.helper)) {
        helpersId.remove(event.helper);
        log(helpersId.join(', '));
        emit(HelperIdChanged());
      }
    });

    on<MitraLocationPicked>((event, emit) {
      mitraLocation = event.location;
      emit(MitraLocationChanged());
    });

    on<TogglePasswordVisibility>((event, emit) {
      isPasswordVisible = !isPasswordVisible;
      emit(PasswordToggled());
    });

    on<SignInSubmitted>(_onSignInSubmitted);

    on<SignOutSubmitted>(_onSignOutSubmitted);

    on<SignUpUserSubmitted>(_onSignUpUserSubmitted);

    on<SignUpMitraSubmitted>(_onSignUpMitraSubmitted);

    on<ForgetPasswordSubmitted>(_onForgetPasswordSubmitted);

    on<AuthIsIdle>((event, emit) => emit(AuthIdle()));

    on<ResetAuthState>((event, emit) {
      fullName = '';
      username = '';
      password = '';
      passwordConfirmation = '';
      phoneNumber = '';
      isPasswordVisible = false;
      mitraName = '';
      categoryId = 0;
      accountNumber = '';
      helpersId = [];
      emit(AuthInitial());
    });
  }

  FutureOr<void> _onSignUpMitraSubmitted(
    SignUpMitraSubmitted event,
    emit,
  ) async {
    emit(AuthLoading());
    if (mitraName.isEmpty) {
      emit(const SignUpMitraError(message: 'Isi nama usaha anda'));
    } else if (accountNumber.isEmpty) {
      emit(const SignUpMitraError(message: 'Isi dengan nomor rekening anda'));
    } else if (event.bankAccountState is! AccountNumberExist) {
      emit(const SignUpMitraError(message: 'Nomor rekening tidak valid'));
    } else if (categoryId == 0) {
      emit(const SignUpMitraError(
          message: 'Isi bagian mana yang ingin anda isi'));
    } else if (helpersId.isEmpty) {
      emit(const SignUpMitraError(message: 'Pilih keahlian anda'));
    } else if (mitraLocation == null) {
      emit(const SignUpMitraError(message: 'Tolong bagikan lokasi anda'));
    } else {
      List<int> helperIds = [];
      for (var value in helpersId) {
        helperIds.add(value.id);
      }
      final mitra = RegisterMitraModel(
        name: mitraName,
        lat: mitraLocation!.latitude,
        long: mitraLocation!.longitude,
        categoryId: categoryId,
        accountNumber: accountNumber,
        helpersId: helperIds,
      );
      final response = await ApiHelper.authRegisterMitra(mitra);
      if (response is ApiErrorResponseModel) {
        String? message = response.error?.error ?? response.error?.message;
        if (message == null || message.isEmpty) {
          message = response.toString();
        }
        emit(SignUpMitraError(message: message.toString()));
      } else {
        emit(SignUpMitraLoaded(message: response.message.toString()));
      }
    }
  }

  FutureOr<void> _onForgetPasswordSubmitted(event, emit) async {
    emit(AuthLoading());
    if (phoneNumber.isEmpty) {
      emit(const ForgetPasswordError(message: 'Isi nomor telpon'));
    } else if (!phoneNumber.startsWith('08')) {
      emit(const ForgetPasswordError(
          message: 'Isi dengan nomor telpon yang valid'));
    } else {
      final response = await ApiHelper.forgotPassword(phoneNumber);
      if (response.error != null) {
        var message = response.error?.message ?? response.error?.error;
        message ??= 'Nomor yang anda masukan tidak terdaftar';
        emit(ForgetPasswordLoaded(message: message.toString()));
      } else {
        emit(const ForgetPasswordError(message: 'Unknown error occured'));
      }
    }
  }

  Future<void> _onSignOutSubmitted(
    SignOutSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final signOutResponse = await ApiHelper.authLogout();
    if (signOutResponse is ApiErrorResponseModel) {
      final message =
          signOutResponse.error?.message ?? signOutResponse.error?.error;
      if (message!.trim().toLowerCase().contains('unauthorized')) {
        emit(
          AuthError(message: message.toString()),
        );
      }
    } else {
      signOutResponse as AuthResponseModel;
      ApiController.token = null;
      FirebaseMessagingApi.fcmToken = null;
      ManageAuthToken.deleteToken();
      ManageFCMToken.deleteToken();
      await DefaultCacheManager().emptyCache();
      emit(SignOutLoaded(
        message: signOutResponse.message ?? 'Failed to load message',
      ));
    }
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (username.isEmpty) {
      emit(
        const AuthError(
          message: 'Isi username',
        ),
      );
    } else if (password.length < 8) {
      emit(
        const AuthError(
          message: 'Password minimal 8 karakter',
        ),
      );
    } else {
      emit(AuthLoading());
      late LoginModel loginRequest;
      String? fcmToken = await ManageFCMToken.readToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        fcmToken = await FirebaseMessagingApi.getFCMToken();
      }
      loginRequest = LoginModel(
        username: username,
        password: password,
        fcmToken: fcmToken,
      );
      final signInResponse = await ApiHelper.authLogin(loginRequest);
      if (signInResponse is AuthResponseModel) {
        final authMessage = signInResponse.message.toString();
        final authToken = signInResponse.token;
        if (authToken != null) {
          ApiController.token = authToken;
          FirebaseMessagingApi.fcmToken = fcmToken;
          ManageAuthToken.writeToken();
          ManageFCMToken.writeToken(fcmToken);
          emit(
            SignInLoaded(
              message: authMessage.toString(),
              token: authToken,
            ),
          );
        }
      } else if (signInResponse is ApiErrorResponseModel) {
        String? message =
            signInResponse.error?.error ?? signInResponse.error?.message;
        if (message.toString().trim().toLowerCase().contains('invalid') ||
            message.toString().trim().toLowerCase().contains('unauthorized')) {
          message = 'Username atau password salah';
        }
        emit(AuthError(message: message.toString()));
      }
    }
  }

  Future<void> _onSignUpUserSubmitted(
    SignUpUserSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (fullName.isEmpty) {
      emit(
        const AuthError(message: 'Isi nama lengkap'),
      );
    } else if (phoneNumber.isEmpty) {
      emit(
        const AuthError(message: 'Isi nomor telepon'),
      );
    } else if (!phoneNumber.startsWith('08')) {
      emit(
        const AuthError(message: 'Isi dengan nomor telpon yang valid'),
      );
    } else if (username.isEmpty) {
      emit(
        const AuthError(message: 'Isi username'),
      );
    } else if (password.isEmpty || password.length < 8) {
      emit(
        const AuthError(message: 'Password minimal 8 karakter'),
      );
    } else if (passwordConfirmation.isEmpty) {
      emit(
        const AuthError(message: 'Isi konfirmasi password'),
      );
    } else if (passwordConfirmation != password) {
      emit(
        const AuthError(message: 'Konfirmasi password salah'),
      );
    } else {
      emit(AuthLoading());
      String? fcmToken = await ManageFCMToken.readToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        fcmToken = await FirebaseMessagingApi.getFCMToken();
      } else {
        emit(
          const AuthError(message: 'Gagal memuat FCM token'),
        );
        return;
      }
      final signUpModel = RegisterUserModel(
        fullName: fullName,
        username: username,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phoneNumber: phoneNumber,
        role: role,
        fcmToken: fcmToken,
      );
      final signUpResponse = await ApiHelper.authRegisterUser(signUpModel);
      if (signUpResponse is AuthResponseModel) {
        final authMessage = signUpResponse.message.toString();
        final authToken = signUpResponse.token;
        if (authToken != null) {
          ApiController.token = authToken;
          FirebaseMessagingApi.fcmToken = fcmToken;
          ManageAuthToken.writeToken();
          ManageFCMToken.writeToken(fcmToken);
          emit(
            SignUpUserLoaded(
              message: authMessage.toString(),
              token: authToken,
            ),
          );
        }
      } else if (signUpResponse is ApiErrorResponseModel) {
        String? message =
            signUpResponse.error?.error ?? signUpResponse.error?.message;
        if (message == null || message.isEmpty) {
          message = signUpResponse.toString();
        }
        emit(AuthError(message: message.toString()));
      }
    }
  }
}
