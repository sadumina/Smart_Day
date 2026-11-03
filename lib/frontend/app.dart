import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../backend/auth/auth_repository.dart';
import '../backend/config/supabase_config.dart';
import '../core/theme/app_theme.dart';
import 'pages/auth_page.dart';
import 'productivity_shell.dart';

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

class SupabaseBootstrapApp extends StatefulWidget {
  const SupabaseBootstrapApp({super.key});

  @override
  State<SupabaseBootstrapApp> createState() => _SupabaseBootstrapAppState();
}

class _SupabaseBootstrapAppState extends State<SupabaseBootstrapApp> {
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = SupabaseConfig.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Unable to connect to Supabase.\n\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return const MyApp();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    final authRepository = AuthRepository(client);

    return ProviderScope(
      child: MaterialApp(
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
                : ProductivityShell(authRepository: authRepository);
          },
        ),
      ),
    );
  }
}
