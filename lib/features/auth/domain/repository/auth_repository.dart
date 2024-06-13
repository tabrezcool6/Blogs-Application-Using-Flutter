import 'dart:async';

import 'package:blogs_app/core/error/failures.dart';
import 'package:blogs_app/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

// TODO : STEP 1 - Domain Layer
// Create a Repository or Auth Class
// Here, this interface class force other classes which implements them to must have these two functions
abstract interface class AuthRepository {
  //
  // the outcome or the result of the signup class can be a succuess or a failure. To display error it is enclosed by the failure class
  // Either is the default method provided by fp_dart package to return SUCCESS or FAILURE outcome
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
}
