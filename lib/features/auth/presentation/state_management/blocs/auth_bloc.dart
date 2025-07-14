import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:story_lab/features/auth/domain/usecases/check_username_available.dart';
import 'package:story_lab/features/auth/domain/usecases/resend_email_verification.dart';
import 'package:story_lab/features/auth/domain/usecases/user_sign_in.dart';
import 'package:story_lab/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CheckUsernameAvailable _checkUsernameAvailable;
  final ResendEmailVerification _resendEmailVerification;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CheckUsernameAvailable checkUsernameAvailable,
    required ResendEmailVerification resendEmailVerification,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _checkUsernameAvailable = checkUsernameAvailable,
        _resendEmailVerification = resendEmailVerification,
        super(AuthInitial()) {
    on<AuthSignUp>(
      (event, emit) async {
        emit(AuthLoading());

        final res = await _userSignUp(
          UserSignUpParams(
            fullName: event.fullName,
            email: event.email,
            password: event.password,
          ),
        );

        res.fold(
          (failure) => emit(AuthFailure(errorMessage: failure.message)),
          (uid) => emit(AuthSuccess(userId: uid)),
        );
      },
    );

    on<AuthSignIn>(
      (event, emit) async {
        emit(AuthLoading());

        final res = await _userSignIn(UserSignInParams(
          email: event.email,
          password: event.password,
        ));

        res.fold(
          (failure) => emit(AuthFailure(errorMessage: failure.message)),
          (uid) => emit(AuthSuccess(userId: uid)),
        );
      },
    );

    on<CheckUsernameEvent>(
      (event, emit) async {
        final res = await _checkUsernameAvailable(event.username);

        res.fold(
          (failure) => emit(AuthFailure(errorMessage: failure.message)),
          (taken) {
            if (taken) {
              emit(UsernameTaken());
            } else {
              emit(UsernameAvailable());
            }
          },
        );
      },
    );

    on<ResendEmailVerificationRequested>(
      (event, emit) async {
        final res = await _resendEmailVerification(event.email);

        res.fold(
          (failure) => emit(AuthFailure(errorMessage: failure.message)),
          (success) => emit(EmailVerificationResent()),
        );
      },
    );
  }
}
