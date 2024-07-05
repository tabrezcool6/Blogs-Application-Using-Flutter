import 'package:blogs_app/core/error/failures.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/core/common/entities/user.dart';
import 'package:blogs_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

// TODO : STEP 8 - User Sign Up usecase

class UserSignUp implements UseCase<User, UserSignUpParams> {
  // accessing "Auth Repository" a constructor
  // thats beacuse we donot want "User Sign Up" Use case to have a dependency on the "Auth Repository"
  final AuthRepository authRepository;
  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    // calling signup function written in the repository
    return await authRepository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

// TODO : STEP 9 - create signup parameters class
class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
