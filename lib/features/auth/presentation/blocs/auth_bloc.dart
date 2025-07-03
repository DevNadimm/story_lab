import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:story_lab/features/auth/domain/usecases/check_username_available.dart';
import 'package:story_lab/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final CheckUsernameAvailable _checkUsernameAvailable;

  AuthBloc({
    required UserSignUp userSignUp,
    required CheckUsernameAvailable checkUsernameAvailable,
  })  : _userSignUp = userSignUp,
        _checkUsernameAvailable = checkUsernameAvailable,
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
  }
}
