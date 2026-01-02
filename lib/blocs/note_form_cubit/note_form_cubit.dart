import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/note.dart';
import '../../repositories/notes_repository.dart';

part 'note_form_state.dart';

class NoteFormCubit extends Cubit<NoteFormState> {
  final NotesRepository notesRepository;

  NoteFormCubit(this.notesRepository, {Note? initialNote})
      : super(NoteFormState(
          note: initialNote ??
              Note(
                title: '',
                content: '',
                createdAt: DateTime.now(),
              ),
          isEditing: initialNote != null,
        ));

  void updateTitle(String title) {
    emit(state.copyWith(
      note: state.note.copyWith(title: title),
    ));
  }

  void updateContent(String content) {
    emit(state.copyWith(
      note: state.note.copyWith(content: content),
    ));
  }

  void updateCategory(String? category) {
    emit(state.copyWith(
      note: state.note.copyWith(category: category),
    ));
  }

  void addTag(String tag) {
    if (tag.isNotEmpty && !state.note.tags.contains(tag)) {
      final updatedTags = List<String>.from(state.note.tags)..add(tag);
      emit(state.copyWith(
        note: state.note.copyWith(tags: updatedTags),
      ));
    }
  }

  void removeTag(String tag) {
    final updatedTags = List<String>.from(state.note.tags)..remove(tag);
    emit(state.copyWith(
      note: state.note.copyWith(tags: updatedTags),
    ));
  }

  Future<bool> saveNote() async {
    if (state.note.title.isEmpty) {
      emit(state.copyWith(errorMessage: 'Title cannot be empty'));
      return false;
    }

    try {
      emit(state.copyWith(isSaving: true));

      if (state.isEditing) {
        await notesRepository.updateNote(state.note);
      } else {
        final savedNote = await notesRepository.saveNote(state.note);
        emit(state.copyWith(note: savedNote));
      }

      emit(state.copyWith(isSaving: false, isSaved: true));
      return true;
    } catch (e) {
      emit(state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save note: ${e.toString()}',
      ));
      return false;
    }
  }

  void reset() {
    emit(NoteFormState(
      note: Note(
        title: '',
        content: '',
        createdAt: DateTime.now(),
      ),
      isEditing: false,
    ));
  }
}