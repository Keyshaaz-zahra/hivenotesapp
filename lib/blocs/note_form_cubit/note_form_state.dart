part of 'note_form_cubit.dart';

class NoteFormState extends Equatable {
  final Note note;
  final bool isEditing;
  final bool isSaving;
  final bool isSaved;
  final String? errorMessage;

  const NoteFormState({
    required this.note,
    this.isEditing = false,
    this.isSaving = false,
    this.isSaved = false,
    this.errorMessage,
  });

  NoteFormState copyWith({
    Note? note,
    bool? isEditing,
    bool? isSaving,
    bool? isSaved,
    String? errorMessage,
  }) {
    return NoteFormState(
      note: note ?? this.note,
      isEditing: isEditing ?? this.isEditing,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [note, isEditing, isSaving, isSaved, errorMessage];
}