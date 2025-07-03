import 'package:fpdart/fpdart.dart';
import 'package:story_lab/core/error/failures.dart';
import 'package:story_lab/core/usecase/usecase.dart';
import 'package:story_lab/features/auth/domain/repository/auth_repository.dart';

class CheckEmailVerified implements UseCase<bool, void> {
  final AuthRepository authRepository;

  CheckEmailVerified(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(void params) async {
    return await authRepository.isEmailVerified();
  }
}
