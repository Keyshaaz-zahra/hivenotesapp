part of 'notes_list_bloc.dart';

abstract class NotesListState extends Equatable {
  const NotesListState();

  @override
  List<Object?> get props => [];
}

class NotesListLoading extends NotesListState {}

class NotesListLoaded extends NotesListState {
  final List<Note> notes;
  final List<String> categories;
  final List<String> tags;
  final String? currentCategory;
  final String? searchQuery;

  const NotesListLoaded({
    required this.notes,
    this.categories = const [],
    this.tags = const [],
    this.currentCategory,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [notes, categories, tags, currentCategory, searchQuery];

  NotesListLoaded copyWith({
    List<Note>? notes,
    List<String>? categories,
    List<String>? tags,
    String? currentCategory,
    String? searchQuery,
  }) {
    return NotesListLoaded(
      notes: notes ?? this.notes,
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
      currentCategory: currentCategory ?? this.currentCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class NotesListError extends NotesListState {
  final String message;

  const NotesListError(this.message);

  @override
  List<Object?> get props => [message];
}