import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/notes_list_bloc/notes_list_bloc.dart';
import '../blocs/note_form_cubit/note_form_cubit.dart';
import '../blocs/theme_cubit/theme_cubit.dart';
import '../repositories/notes_repository.dart';
import '../widgets/note_card.dart';
import 'note_form_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeCubit>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (category) {
              setState(() {
                _selectedCategory = category == 'All' ? null : category;
              });
              context.read<NotesListBloc>().add(FilterByCategory(_selectedCategory));
            },
            itemBuilder: (context) {
              final state = context.read<NotesListBloc>().state;
              if (state is NotesListLoaded) {
                return [
                  const PopupMenuItem(
                    value: 'All',
                    child: Text('All Categories'),
                  ),
                  ...state.categories.map(
                    (category) => PopupMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  ),
                ];
              }
              return [];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<NotesListBloc>().add(LoadNotes());
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                context.read<NotesListBloc>().add(SearchNotes(value));
              },
            ),
          ),
          if (_selectedCategory != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Chip(
                label: Text('Category: $_selectedCategory'),
                onDeleted: () {
                  setState(() {
                    _selectedCategory = null;
                  });
                  context.read<NotesListBloc>().add(LoadNotes());
                },
              ),
            ),
          Expanded(
            child: BlocBuilder<NotesListBloc, NotesListState>(
              builder: (context, state) {
                if (state is NotesListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotesListLoaded) {
                  if (state.notes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.note_add,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No notes yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap + to create your first note',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.notes.length,
                    itemBuilder: (context, index) {
                      final note = state.notes[index];
                      return NoteCard(
                        note: note,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => NoteFormCubit(
                                  context.read<NotesRepository>(),
                                  initialNote: note,
                                ),
                                child: const NoteFormScreen(),
                              ),
                            ),
                          ).then((_) {
                            context.read<NotesListBloc>().add(RefreshNotes());
                          });
                        },
                        onDelete: () {
                          _showDeleteDialog(context, note.id!);
                        },
                      );
                    },
                  );
                } else if (state is NotesListError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const Center(child: Text('Unknown state'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => NoteFormCubit(
                  context.read<NotesRepository>(),
                ),
                child: const NoteFormScreen(),
              ),
            ),
          ).then((_) {
            context.read<NotesListBloc>().add(RefreshNotes());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int noteId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NotesListBloc>().add(DeleteNote(noteId));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}