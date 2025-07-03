import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:story_lab/features/auth/domain/usecases/check_email_verified.dart';
import 'package:story_lab/features/auth/domain/usecases/check_username_available.dart';
import 'package:story_lab/features/auth/domain/usecases/resend_email_verification.dart';
import 'package:story_lab/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final CheckUsernameAvailable _checkUsernameAvailable;
  final CheckEmailVerified _checkEmailVerified;
  final ResendEmailVerification _resendEmailVerification;

  AuthBloc({
    required UserSignUp userSignUp,
    required CheckUsernameAvailable checkUsernameAvailable,
    required CheckEmailVerified checkEmailVerified,
    required ResendEmailVerification resendEmailVerification,
  })  : _userSignUp = userSignUp,
        _checkUsernameAvailable = checkUsernameAvailable,
        _checkEmailVerified = checkEmailVerified,
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

    on<CheckEmailVerificationStatus>(
          (event, emit) async {
        final res = await _checkEmailVerified(());

        res.fold(
              (failure) => emit(AuthFailure(errorMessage: failure.message)),
              (isVerified) {
            if (isVerified) {
              emit(EmailVerified());
            } else {
              emit(EmailNotVerified());
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
