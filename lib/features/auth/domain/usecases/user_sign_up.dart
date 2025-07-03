import 'package:fpdart/fpdart.dart';
import 'package:story_lab/core/error/failures.dart';
import 'package:story_lab/core/usecase/usecase.dart';
import 'package:story_lab/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements UseCase<String, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, String>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String fullName;
  final String email;
  final String password;

  UserSignUpParams({
    required this.fullName,
    required this.email,
    required this.password,
  });
}
