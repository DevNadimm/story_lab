import 'package:fpdart/fpdart.dart';
import 'package:story_lab/core/error/exceptions.dart';
import 'package:story_lab/core/error/failures.dart';
import 'package:story_lab/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:story_lab/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;

  AuthRepositoryImpl(this.authRemoteDatasource);

  @override
  Future<Either<Failure, String>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final uid = await authRemoteDatasource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return right(uid);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> signUpWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final uid = await authRemoteDatasource.signUpWithEmailAndPassword(
        fullName: fullName,
        email: email,
        password: password,
      );
      
      return right(uid);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isUsernameTaken({required String username}) async {
    try {
      final isTaken = await authRemoteDatasource.isUsernameTaken(username: username);
      return right(isTaken);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> resendEmailVerification({required String email}) async {
    try {
      await authRemoteDatasource.resendEmailVerification(email: email);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
