import 'package:blogs_app/core/error/exceptions.dart';
import 'package:blogs_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:fpdart/fpdart.dart';

// TODO : STEP 3 - Data layer
// creating a interface for the datasource
// so that when ever we shift to other database, only this funtion must bear the changes and not other
// this interface retunrs a STRING
abstract interface class AuthSupabaseDataSource {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<String> login({
    required String email,
    required String password,
  });
}

// TODO: STEP 4
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
  Future<String> login({required String email, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  // User signUp method in supabase server
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
    } catch (e) {
      // throw any other exception
      throw ServerExceptions(e.toString());
    }
  }
}
