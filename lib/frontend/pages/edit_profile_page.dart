import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../backend/auth/auth_repository.dart';
import '../../backend/profiles/profile_repository.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    required this.authRepository,
    required this.profileRepository,
    super.key,
  });

  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  String get _userId => widget.authRepository.currentUser!.id;

  @override
  void initState() {
    super.initState();
    _readProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _readProfile() async {
    try {
      _nameController.text =
          await widget.profileRepository.readDisplayName(_userId) ?? '';
    } on PostgrestException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    final displayName = _nameController.text.trim();
    if (displayName.isEmpty) {
      setState(() => _error = 'Enter a display name.');
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });
    try {
      await widget.profileRepository.save(
        userId: _userId,
        displayName: displayName,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully.')),
        );
        Navigator.of(context).pop();
      }
    } on PostgrestException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteProfile() async {
    try {
      await widget.profileRepository.delete(_userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile deleted successfully.')),
        );
        Navigator.of(context).pop();
      }
    } on PostgrestException catch (error) {
      if (mounted) setState(() => _error = error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
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
                      Text(widget.authRepository.currentUser?.email ?? ''),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _nameController,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Display name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(_error!,
                            style: TextStyle(color: Colors.red.shade700)),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          child: Text(_isSaving ? 'Saving...' : 'Save profile'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _deleteProfile,
                          child: const Text('Delete profile'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
