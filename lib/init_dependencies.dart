import 'package:blogs_app/core/keys/app_keys.dart';
import 'package:blogs_app/features/auth/data/datasources/auth_supabase_data_source.dart';
import 'package:blogs_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blogs_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blogs_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// initialize Service Locator globally
// This is the variable where we register all our dependicies to getIt
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // initiailize Auth Dependencies
  _initAuth();

  // initializing the SUPABASE Database and also Server
  // to do so we require a "Project URL" and a "Anon Key" which is provided by the project created in the supabase
  final subapase = await Supabase.initialize(
    url: Keys.supabaseProjectUrl,
    anonKey: Keys.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => subapase.client);
}

void _initAuth() {
  // registering "AuthSupabaseDataSourceImplementation" Dependency
  serviceLocator.registerFactory<AuthSupabaseDataSource>(
    () => AuthSupabaseDataSourceImplementation(
      serviceLocator(),
    ),
  );

  // registering "AuthRepositoryImplementation" Dependency
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImplementation(
      serviceLocator(),
    ),
  );

  // registering "UserSignUp" Dependency
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );

  // registering "UserSignIn" Dependency
  serviceLocator.registerFactory(
    () => UserSignIn(
      serviceLocator(),
    ),
  );

  // registering "UserSignUp" Dependency
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userSignIn: serviceLocator(),
    ),
  );
}

// AuthBloc=>UserSignUp=>AuthRepoImpl=>AuthSupabaseImpl=>SupabaseClient
/*


void initAuth() {
  // registering "AuthSupabaseDataSourceImplementation" Dependency
  serviceLocator.registerFactory<AuthSupabaseDataSource>(
    () => AuthSupabaseDataSourceImplementation(
      serviceLocator<SupabaseClient>(),
    ),
  );

  // registering "AuthRepositoryImplementation" Dependency
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImplementation(
      serviceLocator<AuthSupabaseDataSourceImplementation>(),
    ),
  );

  // registering "UserSignUp" Dependency
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator<AuthRepository>(),
    ),
  );

  // registering "UserSignUp" Dependency
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator<UserSignUp>(),
    ),
  );
}


 */