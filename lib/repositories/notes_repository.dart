import 'package:hive/hive.dart';
import '../models/note.dart';

class NotesRepository {
  final Box<Map> notesBox;

  NotesRepository(this.notesBox);

  // Save a new note
  Future<Note> saveNote(Note note) async {
    final id = await notesBox.add(note.toMap());
    final savedNote = note.copyWith(id: id);
    await notesBox.put(id, savedNote.toMap());
    return savedNote;
  }

  // Update an existing note
  Future<void> updateNote(Note note) async {
    if (note.id != null) {
      final updatedNote = note.copyWith(updatedAt: DateTime.now());
      await notesBox.put(note.id, updatedNote.toMap());
    }
  }

  // Get all notes
  List<Note> getAllNotes() {
    return notesBox.values
        .map((map) => Note.fromMap(Map<String, dynamic>.from(map)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Search notes by title or content
  List<Note> searchNotes(String query) {
    if (query.isEmpty) return getAllNotes();
    
    final lowerQuery = query.toLowerCase();
    return notesBox.values
        .map((map) => Note.fromMap(Map<String, dynamic>.from(map)))
        .where((note) =>
            note.title.toLowerCase().contains(lowerQuery) ||
            note.content.toLowerCase().contains(lowerQuery) ||
            note.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Get notes by category
  List<Note> getNotesByCategory(String? category) {
    if (category == null || category.isEmpty) return getAllNotes();
    
    return notesBox.values
        .map((map) => Note.fromMap(Map<String, dynamic>.from(map)))
        .where((note) => note.category == category)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Get all unique categories
  List<String> getAllCategories() {
    final categories = notesBox.values
        .map((map) => Note.fromMap(Map<String, dynamic>.from(map)))
        .where((note) => note.category != null && note.category!.isNotEmpty)
        .map((note) => note.category!)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  // Get all unique tags
  List<String> getAllTags() {
    final tags = <String>{};
    for (var map in notesBox.values) {
      final note = Note.fromMap(Map<String, dynamic>.from(map));
      tags.addAll(note.tags);
    }
    final tagList = tags.toList();
    tagList.sort();
    return tagList;
  }

  // Delete a note by ID
  Future<void> deleteNote(int id) async {
    await notesBox.delete(id);
  }

  // Get note by ID
  Note? getNoteById(int id) {
    final map = notesBox.get(id);
    if (map != null) {
      return Note.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }
}