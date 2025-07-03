part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String fullName;
  final String email;
  final String password;

  AuthSignUp({
    required this.fullName,
    required this.email,
    required this.password,
  });
}

final class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthSignIn({
    required this.email,
    required this.password,
  });
}

class CheckUsernameEvent extends AuthEvent {
  final String username;

  CheckUsernameEvent(this.username);
}

class CheckEmailVerificationStatus extends AuthEvent {}

class ResendEmailVerificationRequested extends AuthEvent {
  final String email;

  ResendEmailVerificationRequested({required this.email});
}
