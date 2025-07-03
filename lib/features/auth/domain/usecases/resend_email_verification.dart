import 'package:fpdart/fpdart.dart';
import 'package:story_lab/core/error/failures.dart';
import 'package:story_lab/core/usecase/usecase.dart';
import 'package:story_lab/features/auth/domain/repository/auth_repository.dart';

class ResendEmailVerification implements UseCase<void, String> {
  final AuthRepository authRepository;

  ResendEmailVerification(this.authRepository);

  @override
  Future<Either<Failure, void>> call(String email) async {
    return await authRepository.resendEmailVerification(email: email);
  }
}
