import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:help_me_mitra_alpha_ver/services/firebase/firebase_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/api_error_response/message_error_model.dart';
import '../../models/auth_response_model.dart';
import '../../models/login_model.dart';
import '../../services/api/api_controller.dart';
// import '../../services/firebase/firebase_api.dart';
import '../../utils/manage_auth_token.dart';
import '../../utils/secure_storage.dart';
import '../../models/register_model.dart';
import '../../services/api/api_helper.dart';

import 'dart:math';
import 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiController apiController;

  var fullName = '';
  var username = '';
  var password = '';
  var passwordConfirmation = '';
  var phoneNumber = '';
  final role = 'mitra';
  XFile? profilePicture;
  var isPasswordVisible = false;
  var rememberMe = false;

  var mitraName = '';
  var location = '';
  var mitraType = '';

  AuthBloc({required this.apiController}) : super(const AuthState()) {
    on<FullNameChanged>((event, emit) {
      fullName = event.fullName;
      emit(state.copyWith(fullName: event.fullName));
    });

    on<UsernameChanged>((event, emit) {
      username = event.username;
      emit(state.copyWith(username: event.username));
    });

    on<PhoneNumberChanged>((event, emit) {
      phoneNumber = event.phoneNumber;
      emit(state.copyWith(phoneNumber: event.phoneNumber));
    });

    on<PasswordChanged>((event, emit) {
      password = event.password;
      emit(state.copyWith(password: event.password));
    });

    on<ConfirmPasswordChanged>((event, emit) {
      passwordConfirmation = event.confirmPassword;
      emit(state.copyWith(passwordConfirmation: event.confirmPassword));
    });

    on<ProfileImageChanged>((event, emit) {
      profilePicture = event.image;
      emit(state.copyWith(profilePicture: event.image));
    });

    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });

    on<ToggleRememberMe>((event, emit) {
      rememberMe = !state.rememberMe;
      emit(state.copyWith(rememberMe: !state.rememberMe));
    });

    on<MitraTypeChanged>((event, emit) {
      mitraType = event.mitraType;
      emit(state.copyWith(mitraType: event.mitraType));
    });


    on<SignInSubmitted>(_onSignInSubmitted);

    on<SignOutSubmitted>(_onSignOutSubmitted);

    on<SignUpSubmitted>(_onSignUpSubmitted);

    on<ResetAuthState>((event, emit) {
      // fullName = '';
      // username = '';
      // password = '';
      // passwordConfirmation = '';
      // phoneNumber = '';
      // profilePicture = null;
      emit(AuthInitial());
    });

    // on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);

  }

Future<void> _onSignOutSubmitted(
  SignOutSubmitted event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoading());
  
  final fcmToken = 'qwertyuiopasdfgh';
  final signOutResponse = await ApiHelper.authLogout(fcmToken: fcmToken);
  
  if (signOutResponse.error != null) {
    final message =
      signOutResponse.error?.message ?? signOutResponse.error?.error;
    emit(SignOutLoaded(
      message: message.toString(),
    ));
  } else {
    emit(
      const AuthError(
        errorMessage: MessageErrorModel(
          message: 'Unknown error occurred',
        ),
      ),
    );
  }
}

Future<void> _onSignInSubmitted(
  SignInSubmitted event,
  Emitter<AuthState> emit,
) async {
  // Ambil username dan password dari event atau state
  username = username;
  password = password;

  // Ambil token FCM secara dinamis
  final fcmToken = await FirebaseApi().initNotification();

  // Validasi input
  if (username.isEmpty) {
    emit(
      const AuthError(
        errorMessage: MessageErrorModel(
          message: 'Isi username',
        ),
      ),
    );
  } else if (password.length < 8) {
    emit(
      const AuthError(
        errorMessage: MessageErrorModel(
          message: 'Password minimal 8 karakter',
        ),
      ),
    );
  } else {
    // Emit loading state
    emit(AuthLoading());

    // Buat login model dengan FCM token
    final loginModel = LoginModel(
      username: username,
      password: password,
      fcmToken: fcmToken, // Pastikan token sudah diterima
    );

    // Panggil API untuk login
    final signInResponse = await ApiHelper.authLogin(loginModel);

    // Handling response dari API
    if (signInResponse is AuthResponseModel) {
      final authMessage = signInResponse.message.toString();
      final authToken = signInResponse.token;

      if (authToken != null) {
        // Simpan token untuk API selanjutnya
        ApiController.token = authToken;

        // Simpan token jika 'rememberMe' diaktifkan
        rememberMe == true ? ManageAuthToken.writeToken() : null;

        if (fcmToken == null) {
          emit(const AuthError(
            errorMessage: MessageErrorModel(
              message: 'Gagal mendapatkan FCM token, coba lagi',
            ),
          ));
          return;
        }

        emit(
          SignInLoaded(
            message: authMessage,
            token: authToken,
            fcmToken: fcmToken, // Pastikan token tidak null
          ),
        );

      }
    } else if (signInResponse is ApiErrorResponseModel) {
      final error = signInResponse.error;

      if (error != null) {
        emit(AuthError(errorMessage: error));
      } else {
        emit(
          const AuthError(
            errorMessage: MessageErrorModel(
              message: 'Unknown error occurred',
            ),
          ),
        );
      }
    }
  }
}


// FUNGSI SIGN IN DENGAN FAKE TOKEN
//   Future<void> _onSignInSubmitted(
//     SignInSubmitted event,
//     Emitter<AuthState> emit,
//   ) async {
//     // username = state.username;
//     // password = state.password;
//     final fcmToken = 'qwertyuiopasdfgh';
//     if (username.isEmpty) {
//       emit(
//         const AuthError(
//           errorMessage: MessageErrorModel(
//             message: 'Isi username',
//           ),
//         ),
//       );
//     } else if (password.length < 8) {
//       emit(
//         const AuthError(
//           errorMessage: MessageErrorModel(
//             message: 'Password minimal 8 karakter',
//           ),
//         ),
//       );
//     } else {
//       emit(AuthLoading());
//       final loginModel = LoginModel(
//         username: username,
//         password: password,
//         fcmToken: fcmToken,
//       );
//       final signInResponse = await ApiHelper.authLogin(loginModel);
//       if (signInResponse is AuthResponseModel) {
//         final authMessage = signInResponse.message.toString();
//         final authToken = signInResponse.token;
//         if (authToken != null) {
//           ApiController.token = authToken;
//           rememberMe == true ? ManageAuthToken.writeToken() : null;
//           emit(
//             SignInLoaded(
//               message: authMessage.toString(),
//               token: authToken,
//               fcmToken: fcmToken,
//             ),
//           );
//         }
//       } else if (signInResponse is ApiErrorResponseModel) {
//         final error = signInResponse.error;
//         if (error != null) {
//           emit(AuthError(errorMessage: error));
//         } else {
//           emit(
//             const AuthError(
//               errorMessage: MessageErrorModel(
//                 message: 'Unknown error occured',
//               ),
//             ),
//           );
//         }
//       }
//     }
//   }

  
// FUNGSI SIGN UP DENGAN FAKE TOKEN
  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final fcmToken = 'qwertyuiopasdfgh';

    if (fullName.isEmpty) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(
            message: 'Isi fullname',
          ),
        ),
      );
    } else if (phoneNumber.isEmpty) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(
            message: 'Isi nomor telepon',
          ),
        ),
      );
    } else if (username.isEmpty) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(
            message: 'Isi username',
          ),
        ),
      );
    } else if (password.length < 8) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(
            message: 'Password minimal 8 karakter',
          ),
        ),
      );
    } else if (password != passwordConfirmation) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(
            message: 'Konfirmasi password tidak cocok',
          ),
        ),
      );
    } else {
      emit(AuthLoading());
      
      final signUpModel = RegisterModel(
        fullName: fullName,
        username: username,
        phoneNumber: phoneNumber,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
        fcmToken: fcmToken,
      );

      final signUpResponse = await ApiHelper.authRegister(signUpModel);
      if (signUpResponse is AuthResponseModel) {
        final authMessage = signUpResponse.message.toString();
        final authToken = signUpResponse.token;
        if (authToken != null) {
          ApiController.token = authToken;
          emit(
            SignUpLoaded(
              message: authMessage.toString(),
              token: authToken,
            ),
          );
        }
      } else if (signUpResponse is ApiErrorResponseModel) {
        final error = signUpResponse.error;
        if (error != null) {
          emit(AuthError(errorMessage: error));
        } else {
          emit(
            const AuthError(
              errorMessage: MessageErrorModel(
                message: 'Unknown error occurred',
              ),
            ),
          );
        }
      }
    }
  }
}

  //  Future<void> _onSignUpSubmitted(
  //   SignUpSubmitted event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   if (fullName.isEmpty) {
  //     emit(
  //       const AuthError(
  //         errorMessage: MessageErrorModel(message: 'Isi nama lengkap'),
  //       ),
  //     );
  //   } else if (phoneNumber.isEmpty) {
  //     emit(
  //       const AuthError(
  //         errorMessage: MessageErrorModel(message: 'Isi nomor telepon'),
  //       ),
  //     );
  //   } else if (!phoneNumber.startsWith('08')) {
  //     emit(
  //       const AuthError(
  //         errorMessage:
  //             MessageErrorModel(message: 'Isi dengan nomor telpon yang valid'),
  //       ),
  //     );
  //   } else if (username.isEmpty) {
  //     emit(
  //       const AuthError(
  //         errorMessage: MessageErrorModel(message: 'Isi username'),
  //       ),
  //     );
  //   } else if (password.isEmpty) {
  //     emit(
  //       const AuthError(
  //         errorMessage:
  //             MessageErrorModel(message: 'Password minimal 8 karakter'),
  //       ),
  //     );
  //   } else if (passwordConfirmation.isEmpty) {
  //     emit(
  //       const AuthError(
  //         errorMessage: MessageErrorModel(message: 'Isi konfirmasi password'),
  //       ),
  //     );
  //   } else if (passwordConfirmation != password) {
  //     emit(
  //       const AuthError(
  //         errorMessage: MessageErrorModel(message: 'Konfirmasi password salah'),
  //       ),
  //     );
  //   } else {
  //     emit(AuthLoading());
  //     String? fcmToken = await ManageFCMToken.readToken();
  //     if (fcmToken == null || fcmToken.isEmpty) {
  //       fcmToken = await FirebaseMessagingApi.getFCMToken();
  //     } else {
  //       emit(
  //         const AuthError(
  //             errorMessage: MessageErrorModel(error: 'Gagal memuat FCM token')),
  //       );
  //       return;
  //     }
  //     final signUpModel = RegisterModel(
  //       fullName: fullName,
  //       username: username,
  //       password: password,
  //       passwordConfirmation: passwordConfirmation,
  //       phoneNumber: phoneNumber,
  //       role: role,
  //       fcmToken: fcmToken,
  //     );
  //     final signUpResponse = await ApiHelper.authRegister(signUpModel);
  //     if (signUpResponse is AuthResponseModel) {
  //       final authMessage = signUpResponse.message.toString();
  //       final authToken = signUpResponse.token;
  //       if (authToken != null) {
  //         ApiController.token = authToken;
  //         FirebaseMessagingApi.fcmToken = fcmToken;
  //         emit(
  //           SignUpLoaded(
  //             message: authMessage.toString(),
  //             token: authToken,
  //           ),
  //         );
  //       }
  //     } else if (signUpResponse is ApiErrorResponseModel) {
  //       final error = signUpResponse.error;
  //       if (error != null) {
  //         emit(AuthError(errorMessage: error));
  //       } else {
  //         emit(
  //           const AuthError(
  //             errorMessage: MessageErrorModel(message: 'Unknown error occured'),
  //           ),
  //         );
  //       }
  //     }
  //   }
  // }

//   Future<void> _onSignUpSubmitted(
//     SignUpSubmitted event,
//     Emitter<AuthState> emit,
//   ) async {
//     if (fullName.isEmpty ||
//         username.isEmpty ||
//         password.isEmpty ||
//         passwordConfirmation.isEmpty ||
//         phoneNumber.isEmpty ||
//         password.length < 8 ||
//         passwordConfirmation != password) {
//       emit(
//         const AuthError(
//           errorMessage:
//               MessageErrorModel(message: 'Isi semua data dengan benar'),
//         ),
//       );
//     } else {
//       fullName = fullName.trim();
//       username = username.trim();
//       password = password.trim();
//       passwordConfirmation = passwordConfirmation.trim();
//       phoneNumber = '+62${phoneNumber.trim()}';
//       emit(AuthLoading());
//       final signUpModel = RegisterModel(
//         fullName: fullName,
//         username: username,
//         password: password,
//         passwordConfirmation: passwordConfirmation,
//         phoneNumber: phoneNumber,
//         role: role,
//       );
//       final signUpResponse = await ApiHelper.authRegister(signUpModel);
//       if (signUpResponse is AuthResponseModel) {
//         final authMessage = signUpResponse.message.toString();
//         final authToken = signUpResponse.token;
//         if (authToken != null) {
//           ApiController.token = authToken;
//           emit(
//             SignUpLoaded(
//               message: authMessage.toString(),
//               token: authToken,
//             ),
//           );
//           rememberMe == true ? ManageAuthToken.writeToken() : null;
//         }
//       } else if (signUpResponse is ApiErrorResponseModel) {
//         final error = signUpResponse.error;
//         if (error != null) {
//           emit(AuthError(errorMessage: error));
//         } else {
//           emit(
//             const AuthError(
//               errorMessage: MessageErrorModel(message: 'Unknown error occured'),
//             ),
//           );
//         }
//       }
//     }
//   }