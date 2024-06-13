import 'package:blogs_app/core/error/exceptions.dart';
import 'package:blogs_app/core/error/failures.dart';
import 'package:blogs_app/features/auth/data/datasources/auth_supabase_data_source.dart';
import 'package:blogs_app/core/common/entities/user.dart';
import 'package:blogs_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

// TODO : STEP 6 - Implementation of Auth Repository of Domain Layer in Data Layer
//
class AuthRepositoryImplementation implements AuthRepository {
  // asking "AuthSupabaseDataSource" from a constructor
  // We are not initializing "AuthSupabaseDataSource" here beacause by doing so, it creates a dependancy between impl class and "AuthSupabaseDataSource" which we don't want
  // so that if we change "AuthSupabaseDataSource" in future, we just get that "DataSource" from a cunstructor but not initializing the whole stuff again
  // This is here what called as "Depemdemcy Injection",
  final AuthSupabaseDataSource authSupabaseDataSource;
  AuthRepositoryImplementation(this.authSupabaseDataSource);

  // "AuthRepositoryImplementation" sign in class which is implemented from the "AuthRepository" class
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authSupabaseDataSource.login(
        email: email,
        password: password,
      );
      return right(user);

      // Auth Expcetion error handling
    } on supabase.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerExceptions catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // "AuthRepositoryImplementation" sign up class which is implemented from the "AuthRepository" class
  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // passing parameters to the signup class
      final user = await authSupabaseDataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
      // fp_dart standard procedure or syntax
      // if result is success, use success param within right
      return right(user);

      // Auth Expcetion error handling
    } on supabase.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerExceptions catch (e) {
      // if result is failure, use failure param within left
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await authSupabaseDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User is not logged in'));
      }

      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
}

///
/// Advanced Functiom for code optimization to be implemnted in future
/*
  Future<Either<Failure, User>> _authRepoImplCommon(
      Future<User> Function() function) async {
    try {
      // passing parameters to the signup class
      final user = await function();
      // fp_dart standard procedure or syntax
      // if result is success, use success param within right
      return right(user);
    } on ServerExceptions catch (e) {
      // if result is failure, use failure param within left
      return left(Failure(e.message));
    }
  }
   */
