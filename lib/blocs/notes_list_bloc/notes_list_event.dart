part of 'notes_list_bloc.dart';

abstract class NotesListEvent extends Equatable {
  const NotesListEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NotesListEvent {}

class SearchNotes extends NotesListEvent {
  final String query;

  const SearchNotes(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByCategory extends NotesListEvent {
  final String? category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class DeleteNote extends NotesListEvent {
  final int noteId;

  const DeleteNote(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

class RefreshNotes extends NotesListEvent {}