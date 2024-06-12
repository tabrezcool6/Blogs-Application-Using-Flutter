import 'package:blogs_app/core/keys/app_keys.dart';
import 'package:blogs_app/core/theme/theme.dart';
import 'package:blogs_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // deafult method to call bindings and future methods
  WidgetsFlutterBinding.ensureInitialized();

// initializing the SUPABASE Database and also Server
// to do so we require a "Project URL" and a "Anon Key" which is provided by the project created in the supabase
  final subapase = await Supabase.initialize(
    url: Keys.supabaseProjectUrl,
    anonKey: Keys.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blogs Application using SOLID Principles and Clean Architecture',
      theme: AppTheme.darkThemeMode,
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
