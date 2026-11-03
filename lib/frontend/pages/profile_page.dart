import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../backend/auth/auth_repository.dart';
import '../../backend/profiles/profile_repository.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.authRepository, super.key});

  final AuthRepository authRepository;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  late final ProfileRepository _profileRepository;
  bool _isLoading = true;
  String? _error;

  String get _userId => widget.authRepository.currentUser!.id;

  @override
  void initState() {
    super.initState();
    _profileRepository = ProfileRepository(Supabase.instance.client);
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      _nameController.text =
          await _profileRepository.readDisplayName(_userId) ?? '';
    } on PostgrestException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _openEditProfile() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          authRepository: widget.authRepository,
          profileRepository: _profileRepository,
        ),
      ),
    );
    if (mounted) _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My profile'),
        actions: [
          IconButton(
            onPressed: widget.authRepository.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Authenticated user',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.authRepository.currentUser?.email ?? ''),
                      const SizedBox(height: 20),
                      Text(
                        _nameController.text.isEmpty
                            ? 'No profile saved yet.'
                            : 'Display name: ${_nameController.text}',
                      ),
                      const SizedBox(height: 20),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(_error!, style: const TextStyle(color: Colors.red)),
                      ],
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: _openEditProfile,
                        child: const Text('Edit profile'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
