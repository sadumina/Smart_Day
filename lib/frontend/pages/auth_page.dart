import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../backend/auth/auth_repository.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({required this.authRepository, super.key});

  final AuthRepository authRepository;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final response = _isSignUp
          ? await widget.authRepository.signUp(
              email: email,
              password: password,
            )
          : await widget.authRepository.signIn(
              email: email,
              password: password,
            );
      if (mounted && _isSignUp && response.session == null) {
        _showMessage('Check your email to confirm your account.');
      }
    } on AuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isSignUp ? 'Create account' : 'Sign in')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  child: Text(_isLoading
                      ? 'Please wait...'
                      : (_isSignUp ? 'Sign up' : 'Sign in')),
                ),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => setState(() {
                            _isSignUp = !_isSignUp;
                            _error = null;
                          }),
                  child: Text(_isSignUp
                      ? 'Already have an account? Sign in'
                      : 'Need an account? Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
