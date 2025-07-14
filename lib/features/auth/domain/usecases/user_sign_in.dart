import 'package:fpdart/fpdart.dart';
import 'package:story_lab/core/error/failures.dart';
import 'package:story_lab/core/usecase/usecase.dart';
import 'package:story_lab/features/auth/domain/repository/auth_repository.dart';

class UserSignIn implements UseCase<String, UserSignInParams> {
  final AuthRepository authRepository;

  UserSignIn(this.authRepository);

  @override
  Future<Either<Failure, String>> call(UserSignInParams params) async {
    return await authRepository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password,
  });
}
