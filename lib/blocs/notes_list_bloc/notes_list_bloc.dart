import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/note.dart';
import '../../repositories/notes_repository.dart';

part 'notes_list_event.dart';
part 'notes_list_state.dart';

class NotesListBloc extends Bloc<NotesListEvent, NotesListState> {
  final NotesRepository notesRepository;

  NotesListBloc(this.notesRepository) : super(NotesListLoading()) {
    on<LoadNotes>(_onLoadNotes);
    on<SearchNotes>(_onSearchNotes);
    on<FilterByCategory>(_onFilterByCategory);
    on<DeleteNote>(_onDeleteNote);
    on<RefreshNotes>(_onRefreshNotes);
  }

  void _onLoadNotes(LoadNotes event, Emitter<NotesListState> emit) {
    try {
      final notes = notesRepository.getAllNotes();
      final categories = notesRepository.getAllCategories();
      final tags = notesRepository.getAllTags();
      
      emit(NotesListLoaded(
        notes: notes,
        categories: categories,
        tags: tags,
      ));
    } catch (e) {
      emit(NotesListError('Failed to load notes: ${e.toString()}'));
    }
  }

  void _onSearchNotes(SearchNotes event, Emitter<NotesListState> emit) {
    try {
      final notes = notesRepository.searchNotes(event.query);
      final categories = notesRepository.getAllCategories();
      final tags = notesRepository.getAllTags();
      
      emit(NotesListLoaded(
        notes: notes,
        categories: categories,
        tags: tags,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(NotesListError('Failed to search notes: ${e.toString()}'));
    }
  }

  void _onFilterByCategory(FilterByCategory event, Emitter<NotesListState> emit) {
    try {
      final notes = notesRepository.getNotesByCategory(event.category);
      final categories = notesRepository.getAllCategories();
      final tags = notesRepository.getAllTags();
      
      emit(NotesListLoaded(
        notes: notes,
        categories: categories,
        tags: tags,
        currentCategory: event.category,
      ));
    } catch (e) {
      emit(NotesListError('Failed to filter notes: ${e.toString()}'));
    }
  }

  void _onDeleteNote(DeleteNote event, Emitter<NotesListState> emit) async {
    try {
      await notesRepository.deleteNote(event.noteId);
      
      // Reload notes after deletion
      final notes = notesRepository.getAllNotes();
      final categories = notesRepository.getAllCategories();
      final tags = notesRepository.getAllTags();
      
      emit(NotesListLoaded(
        notes: notes,
        categories: categories,
        tags: tags,
      ));
    } catch (e) {
      emit(NotesListError('Failed to delete note: ${e.toString()}'));
    }
  }

  void _onRefreshNotes(RefreshNotes event, Emitter<NotesListState> emit) {
    add(LoadNotes());
  }
}