import 'package:blogs_app/core/error/exceptions.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthSupabaseDataSource {
  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<String> login({
    required String email,
    required String password,
  });
}

class AuthSupabaseDataSourceImplementation implements AuthSupabaseDataSource {
  final SupabaseClient supabaseClient;
  AuthSupabaseDataSourceImplementation(this.supabaseClient);

  @override
  Future<String> login({required String email, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {"name": name},
      );

      if (response.user == null) {
        throw ServerExceptions('User is null');
      }

      return response.user!.id;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
