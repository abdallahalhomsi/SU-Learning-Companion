import 'dart:async';
import 'package:flutter/material.dart';
import '../models/notes.dart';
import '../repos/notes_repo.dart';


// This provider manages the state of user notes.
// It listens to Firestore in real-time through NotesRepo
// and exposes the notes list to the UI.


// - Hold notes data in memory
// - Listen to Firestore changes (real-time)
// - Handle loading and error states
// - Provide CRUD methods for notes
//

class NotesProvider extends ChangeNotifier {
  final NotesRepo _repo;

  NotesProvider(this._repo);

  // In-memory list of notes for the logged-in user
  List<Note> _notes = [];

  // Used to show loading indicators in the UI
  bool _loading = false;

  // Stores error messages (if any) from Firestore operations
  String? _error;

  // Firestore stream subscription
  StreamSubscription<List<Note>>? _subscription;

  /// Public getters (read-only for UI)
  List<Note> get notes => _notes;
  bool get isLoading => _loading;
  String? get error => _error;

  /// Start listening to notes for a specific user.
  /// This should be called after the user logs in.
  void start(String userId) {
    _loading = true;
    _error = null;
    notifyListeners();

    // Cancel any previous Firestore listener
    _subscription?.cancel();

    // Listen to Firestore notes stream
    _subscription = _repo.watchNotes(userId).listen(
          (data) {
        // Update local state when Firestore data changes
        _notes = data;
        _loading = false;
        notifyListeners();
      },
      onError: (e) {
        // Handle Firestore errors
        _loading = false;
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  /// Stop listening to Firestore.
  /// Called when the user logs out.
  void stop() {
    _subscription?.cancel();
    _subscription = null;
    _notes = [];
    _loading = false;
    _error = null;
    notifyListeners();
  }

  /// Create a new note for the logged-in user
  Future<void> addNote(
      String userId, {
        required String title,
        required String content,
      }) async {
    try {
      await _repo.addNote(
        userId,
        title: title,
        content: content,
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Update an existing note
  Future<void> updateNote(String userId, Note note) async {
    try {
      await _repo.updateNote(userId, note);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Delete a note by ID
  Future<void> deleteNote(String userId, String noteId) async {
    try {
      await _repo.deleteNote(userId, noteId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
