import 'package:blogs_app/core/error/exceptions.dart';
import 'package:blogs_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:fpdart/fpdart.dart';

// TODO : STEP 3 - Data layer
// creating a interface for the datasource
// so that when ever we shift to other database, only this funtion must bear the changes and not other
// this interface retunrs a STRING
abstract interface class AuthSupabaseDataSource {
  //
  Session? get getCurrentUserSession;

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  Future<void> signOut();
}

// TODO : STEP 4
// creating a general implements class which implements above "DATA SOURCE" class
// So that that it must contain the above two methods
class AuthSupabaseDataSourceImplementation implements AuthSupabaseDataSource {
  // asking "SUPABASECLIENT" from a constructor
  // We are not initializing supabase client here beacause by doing so, it creates a dependancy between impl class and supabase which we don't want
  // so that if we change database in future, we just get that database client from a cunstructor but not initializing the whole stuff again
  final SupabaseClient supabaseClient;
  AuthSupabaseDataSourceImplementation(this.supabaseClient);

  //
  @override
  Session? get getCurrentUserSession => supabaseClient.auth.currentSession;

  // User sign in method using supabase server
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerExceptions('User is null');
      }

      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerExceptions(e.message);
    } on ServerExceptions catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  // User signUp method using supabase server
  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // supabase signup call
      // passing all the parameters to the server
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {"name": name},
      );

      // if server response is null, throw exception
      if (response.user == null) {
        throw ServerExceptions('User is null');
      }

      // return USER ID on success server connection
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      // throw any other exception
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (getCurrentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', getCurrentUserSession!.user.id);

        return UserModel.fromJson(userData.first);
      }

      return null;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
