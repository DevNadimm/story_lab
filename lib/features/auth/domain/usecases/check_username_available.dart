import 'package:fpdart/fpdart.dart';
import 'package:story_lab/core/error/failures.dart';
import 'package:story_lab/core/usecase/usecase.dart';
import 'package:story_lab/features/auth/domain/repository/auth_repository.dart';

class CheckUsernameAvailable implements UseCase<bool, String> {
  final AuthRepository authRepository;

  CheckUsernameAvailable(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(String username) async {
    return await authRepository.isUsernameTaken(username: username);
  }
}
