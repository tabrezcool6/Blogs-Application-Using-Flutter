import 'package:blogs_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogs_app/core/theme/theme.dart';
import 'package:blogs_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogs_app/features/auth/presentation/pages/login_page.dart';
import 'package:blogs_app/features/blogs/presentation/pages/blogs_page.dart';
import 'package:blogs_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  // deafult method to call bindings and future methods
  WidgetsFlutterBinding.ensureInitialized();

  // initialize dependencies
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blogs Application using SOLID Principles and Clean Architecture',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BlogsPage();
          }

          return const LoginPage();
        },
      ),
    );
  }
}
