import 'package:fpdart/fpdart.dart';
import 'package:story_lab/core/error/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signUpWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, bool>> isUsernameTaken({
    required String username,
  });

  Future<Either<Failure, bool>> isEmailVerified();

  Future<Either<Failure, void>> resendEmailVerification({
    required String email,
  });
}
