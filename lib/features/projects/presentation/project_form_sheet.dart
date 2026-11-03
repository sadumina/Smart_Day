import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/project.dart';
import '../providers/project_providers.dart';

class ProjectFormSheet extends ConsumerStatefulWidget {
  const ProjectFormSheet({super.key, this.project});

  final Project? project;

  @override
  ConsumerState<ProjectFormSheet> createState() => _ProjectFormSheetState();
}

class _ProjectFormSheetState extends ConsumerState<ProjectFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _colorController;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name);
    _colorController = TextEditingController(
      text: widget.project?.color ?? '#4F46E5',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final user = ref.read(projectRepositoryProvider).client.auth.currentUser;
    if (name.isEmpty || user == null) {
      setState(() => _error = 'Enter a project name before saving.');
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });
    final now = DateTime.now();
    final project =
        widget.project?.copyWith(
          name: name,
          color: _colorController.text.trim(),
          updatedAt: now,
        ) ??
        Project(
          id: const Uuid().v4(),
          userId: user.id,
          name: name,
          color: _colorController.text.trim(),
          createdAt: now,
          updatedAt: now,
        );

    try {
      final repository = ref.read(projectRepositoryProvider);
      if (widget.project == null) {
        await repository.create(project);
      } else {
        await repository.update(project);
      }
      ref.invalidate(projectsProvider);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.project == null ? 'Add project' : 'Edit project',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Project name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: 'Color',
                hintText: '#4F46E5',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: Colors.red.shade700)),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: Text(_isSaving ? 'Saving...' : 'Save project'),
            ),
          ],
        ),
      ),
    );
  }
}
