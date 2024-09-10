import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_me_client_alpha_ver/models/login_model.dart';
import 'package:help_me_client_alpha_ver/services/api_helper.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final ApiHelper apiHelper;

  SignInBloc({required this.apiHelper}) : super(const SignInState()) {
    on<UsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });

    on<SignInSubmitted>(_onSignInSubmitted);
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoading());
    try {
      final loginModel = LoginModel(
        username: state.username,
        password: state.password,
      );
      final authResponse = await ApiHelper.authLogin(loginModel);
      emit(
        SignInLoaded(
          message: authResponse.message.toString(),
          token: authResponse.token.toString(),
        ),
      );
    } catch (e) {
      emit(SignInError(errorMessage: e.toString()));
    }
  }
}
