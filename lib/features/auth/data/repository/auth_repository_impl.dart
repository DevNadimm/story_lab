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
  }) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
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
      print("[❌ ERROR] ${e.message.toString()}");
      return left(Failure(message: e.message));
    }
  }
}
