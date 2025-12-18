// lib/common/repos/firestore_flashcards_repo.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/models/flashcard.dart';
import 'flashcards_repo.dart';



/// This repository handles the storage of user-specific flashcards.
/// Data is nested under `users/{uid}/courses/...` to ensure that flashcards

class FirestoreFlashcardsRepo implements FlashcardsRepo {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  FirestoreFlashcardsRepo({
    FirebaseFirestore? db,
    FirebaseAuth? auth,
  })  : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Retrieves the current authenticated user's ID.
  /// Throws an exception if the user is not logged in.
  String get _uid {
    final u = _auth.currentUser;
    if (u == null) throw Exception('Not logged in');
    return u.uid;
  }

  // --- COLLECTION HELPERS ---

  /// Helper to get the reference to the flashcard groups collection.
  /// Path: users/{uid}/courses/{courseId}/flashcards/v1/groups
  CollectionReference<Map<String, dynamic>> _groupsCol(String courseId) {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('courses')
        .doc(courseId)
        .collection('flashcards')
        .doc('v1') // Versioning document to allow future schema changes
        .collection('groups');
  }

  /// Helper to get the reference to a specific group's cards.
  CollectionReference<Map<String, dynamic>> _cardsCol({
    required String courseId,
    required String groupId,
  }) {
    return _groupsCol(courseId).doc(groupId).collection('cards');
  }

  // --- METHODS ---

  @override
  Future<List<FlashcardGroup>> getFlashcardGroups(String courseId) async {
    final snap = await _groupsCol(courseId)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs.map((doc) {
      final d = doc.data();
      return FlashcardGroup.fromMap(d, doc.id);
    }).toList();
  }

  @override
  Future<void> addFlashcardGroup(FlashcardGroup group) async {
    final data = group.toMap();
    // Enforce server-side ownership by injecting the current UID
    data['userId'] = _uid;

    // Use .set() with the ID if provided, otherwise Firestore auto-generates it.
    await _groupsCol(group.courseId)
        .doc(group.id.isEmpty ? null : group.id)
        .set(data);
  }

  @override
  Future<void> deleteFlashcardGroup(String courseId, String groupId) async {
    // 1. Fetch all cards within the group
    final cardsSnap = await _cardsCol(courseId: courseId, groupId: groupId).get();

    // 2. Initialize a WriteBatch to perform atomic deletion
    final batch = _db.batch();

    // 3. Queue all sub-cards for deletion
    for (final doc in cardsSnap.docs) {
      batch.delete(doc.reference);
    }

    // 4. Queue the group document itself
    batch.delete(_groupsCol(courseId).doc(groupId));

    // 5. Commit the batch (all or nothing)
    await batch.commit();
  }

  @override
  Future<List<Flashcard>> getFlashcards(String courseId, String groupId) async {
    final snap = await _cardsCol(courseId: courseId, groupId: groupId)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs.map((doc) {
      final d = doc.data();
      return Flashcard.fromMap(d, doc.id);
    }).toList();
  }

  @override
  Future<void> addFlashcard(Flashcard card) async {
    final data = card.toMap();
    data['userId'] = _uid;

    await _cardsCol(courseId: card.courseId, groupId: card.groupId)
        .doc(card.id.isEmpty ? null : card.id)
        .set(data);
  }

  @override
  Future<void> deleteFlashcard(String courseId, String groupId, String cardId) async {
    await _cardsCol(courseId: courseId, groupId: groupId).doc(cardId).delete();
  }
}