import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:story_lab/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;

  AuthBloc({
    required UserSignUp userSignUp,
  })  : _userSignUp = userSignUp,
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
  }
}
