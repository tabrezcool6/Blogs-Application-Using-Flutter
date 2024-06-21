import 'package:blogs_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogs_app/core/keys/app_keys.dart';
import 'package:blogs_app/features/auth/data/datasources/auth_supabase_data_source.dart';
import 'package:blogs_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blogs_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blogs_app/features/auth/domain/usecases/current_user.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blogs_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogs_app/features/blogs/data/datasource/blog_remote_data_source.dart';
import 'package:blogs_app/features/blogs/data/repository/blog_repository_impl.dart';
import 'package:blogs_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:blogs_app/features/blogs/domain/usecases/upload_blog.dart';
import 'package:blogs_app/features/blogs/presentation/bloc/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// initialize Service Locator globally
// This is the variable where we register all our dependicies to getIt
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // initiailize Auth Dependencies
  _initAuth();

  // initiailize Blog Dependencies
  _initBlog();

  // initializing the SUPABASE Database and also Server
  // to do so we require a "Project URL" and a "Anon Key" which is provided by the project created in the supabase
  final subapase = await Supabase.initialize(
    url: Keys.supabaseProjectUrl,
    anonKey: Keys.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => subapase.client);

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  // registering "AuthSupabaseDataSourceImplementation" Dependency
  serviceLocator
    ..registerFactory<AuthSupabaseDataSource>(
      () => AuthSupabaseDataSourceImplementation(
        serviceLocator(),
      ),
    )

    // registering "AuthRepositoryImplementation" Dependency
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImplementation(
        serviceLocator(),
      ),
    )

    // registering "UserSignUp" UseCase Dependency
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )

    // registering "UserSignIn" UseCase Dependency
    ..registerFactory(
      () => UserSignIn(
        serviceLocator(),
      ),
    )

    // registering "CurrentUser" UseCase Dependency
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )

    // registering "AuthBloc" Dependency
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    // registering "BlogSupabaseDataSourceImplementation" Dependency
    ..registerFactory<BlogSupabaseDataSource>(
      () => BlogSupabaseDataSourceImplementation(
        serviceLocator(),
      ),
    )

    // registering "BlogRepositoryImplementation" Dependency
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImplementation(
        serviceLocator(),
      ),
    )

    // registering "UploadBlog" Dependency
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )

    // registering "BlogBloc" Dependency
    ..registerLazySingleton(
      () => BlogBloc(
        serviceLocator(),
      ),
    );
}




/// AuthBloc=>UserSignUp=>AuthRepoImpl=>AuthSupabaseImpl=>SupabaseClient
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