part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final String userId;

  AuthSuccess({required this.userId});
}

final class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure({required this.errorMessage});
}

class UsernameAvailable extends AuthState {}

class UsernameTaken extends AuthState {}

class EmailVerificationChecking extends AuthState {}

class EmailVerified extends AuthState {}

class EmailNotVerified extends AuthState {}

class EmailVerificationResent extends AuthState {}
