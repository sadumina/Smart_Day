import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../backend/auth/auth_repository.dart';
import '../core/theme/app_theme.dart';
import 'pages/auth_page.dart';
import 'pages/profile_page.dart';

class MissingConfigurationApp extends StatelessWidget {
  const MissingConfigurationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Supabase is not configured.\n\n'
              'Run with SUPABASE_URL and SUPABASE_ANON_KEY.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    final authRepository = AuthRepository(client);

    return MaterialApp(
      title: 'Smart Work',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: StreamBuilder<AuthState>(
        stream: authRepository.authStateChanges,
        builder: (context, snapshot) {
          final session =
              snapshot.data?.session ?? authRepository.currentSession;
          return session == null
              ? AuthPage(authRepository: authRepository)
              : ProfilePage(authRepository: authRepository);
        },
      ),
    );
  }
}
