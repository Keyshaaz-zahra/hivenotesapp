import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/note_form_cubit/note_form_cubit.dart';
import '../repositories/notes_repository.dart';

class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({super.key});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<NoteFormCubit>();
    _titleController.text = cubit.state.note.title;
    _contentController.text = cubit.state.note.content;
    _categoryController.text = cubit.state.note.category ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormCubit, NoteFormState>(
      listener: (context, state) {
        if (state.isSaved) {
          Navigator.pop(context);
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<NoteFormCubit, NoteFormState>(
            builder: (context, state) {
              return Text(state.isEditing ? 'Edit Note' : 'Create New Note');
            },
          ),
          actions: [
            BlocBuilder<NoteFormCubit, NoteFormState>(
              builder: (context, state) {
                if (state.isSaving) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return IconButton(
                  onPressed: () async {
                    final success = await context.read<NoteFormCubit>().saveNote();
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Note saved successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.save),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) {
                  context.read<NoteFormCubit>().updateTitle(value);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  hintText: 'Category (optional)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.category),
                  suffixIcon: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (category) {
                      _categoryController.text = category;
                      context.read<NoteFormCubit>().updateCategory(category);
                    },
                    itemBuilder: (context) {
                      final categories = context.read<NotesRepository>().getAllCategories();
                      return categories.map((category) {
                        return PopupMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList();
                    },
                  ),
                ),
                onChanged: (value) {
                  context.read<NoteFormCubit>().updateCategory(value.isEmpty ? null : value);
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<NoteFormCubit, NoteFormState>(
                builder: (context, state) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...state.note.tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          onDeleted: () {
                            context.read<NoteFormCubit>().removeTag(tag);
                          },
                        );
                      }),
                      ActionChip(
                        label: const Text('+ Add Tag'),
                        onPressed: () {
                          _showAddTagDialog(context);
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Write your note here...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                minLines: 15,
                onChanged: (value) {
                  context.read<NoteFormCubit>().updateContent(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTagDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: _tagController,
          decoration: const InputDecoration(
            hintText: 'Enter tag name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              context.read<NoteFormCubit>().addTag(value);
              _tagController.clear();
              Navigator.pop(dialogContext);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_tagController.text.isNotEmpty) {
                context.read<NoteFormCubit>().addTag(_tagController.text);
                _tagController.clear();
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}