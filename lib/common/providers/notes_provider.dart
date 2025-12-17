import 'dart:async';
import 'package:flutter/material.dart';
import '../models/notes.dart';
import '../repos/notes_repo.dart';

class NotesProvider extends ChangeNotifier {
  final NotesRepo _repo;
  NotesProvider(this._repo);

  List<Note> _notes = [];
  bool _loading = false;
  String? _error;

  StreamSubscription<List<Note>>? _sub;

  List<Note> get notes => _notes;
  bool get isLoading => _loading;
  String? get error => _error;

  void start(String uid) {
    _loading = true;
    _error = null;
    notifyListeners();

    _sub?.cancel();
    _sub = _repo.watchNotes(uid).listen(
          (data) {
        _notes = data;
        _loading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _loading = false;
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
    _notes = [];
    _loading = false;
    _error = null;
    notifyListeners();
  }

  Future<void> addNote(String uid, {required String title, required String content}) async {
    try {
      await _repo.addNote(uid, title: title, content: content);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateNote(String uid, Note note) async {
    try {
      await _repo.updateNote(uid, note);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteNote(String uid, String noteId) async {
    try {
      await _repo.deleteNote(uid, noteId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
