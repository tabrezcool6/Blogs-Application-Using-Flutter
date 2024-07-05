import 'package:blogs_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogs_app/core/common/services/connection_checker.dart';
import 'package:blogs_app/core/keys/app_keys.dart';
import 'package:blogs_app/features/auth/data/datasources/auth_supabase_data_source.dart';
import 'package:blogs_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blogs_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blogs_app/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_in_usecase.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_out_usecase.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:blogs_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogs_app/features/blogs/data/datasource/blog_local_data_source.dart';
import 'package:blogs_app/features/blogs/data/datasource/blog_supabase_data_source.dart';
import 'package:blogs_app/features/blogs/data/repository/blog_repository_impl.dart';
import 'package:blogs_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:blogs_app/features/blogs/domain/usecases/delete_blog_usecase.dart';
import 'package:blogs_app/features/blogs/domain/usecases/fetch_blogs_usecase.dart';
import 'package:blogs_app/features/blogs/domain/usecases/update_blogs_usecase.dart';
import 'package:blogs_app/features/blogs/domain/usecases/upload_blog_usecase.dart';
import 'package:blogs_app/features/blogs/presentation/bloc/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
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

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => subapase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  // internet connection checker
  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImplementation(
      serviceLocator(),
    ),
  );
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

    // registering "UserSignOut UseCase Dependency
    ..registerFactory(
      () => UserSignOut(
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
        userSignOut: serviceLocator(),
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

    // registering "BlogLocalDataSourceImplementation" Dependency
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImplementation(
        serviceLocator(),
      ),
    )

    // registering "BlogRepositoryImplementation" Dependency
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImplementation(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )

    // registering "UploadBlog" Dependency
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )

    // registering "FetchBlog" Dependency
    ..registerFactory(
      () => FetchBlogs(
        serviceLocator(),
      ),
    )

    // registering "UploadBlog" Dependency
    ..registerFactory(
      () => UpdateBlogs(
        serviceLocator(),
      ),
    )

    // registering "Delete Blog" Dependency
    ..registerFactory(
      () => DeleteBlog(
        serviceLocator(),
      ),
    )

    // registering "BlogBloc" Dependency
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        fetchBlogs: serviceLocator(),
        updateBlogs: serviceLocator(),
        deleteBlog: serviceLocator(),
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
