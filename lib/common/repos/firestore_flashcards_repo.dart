// lib/common/repos/firestore_flashcards_repo.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/models/flashcard.dart';
import 'flashcards_repo.dart';

class FirestoreFlashcardsRepo implements FlashcardsRepo {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  FirestoreFlashcardsRepo({
    FirebaseFirestore? db,
    FirebaseAuth? auth,
  })  : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) throw Exception('Not logged in');
    return u.uid;
  }

  CollectionReference<Map<String, dynamic>> _groupsCol(String courseId) {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('courses')
        .doc(courseId)
        .collection('flashcards')
        .doc('v1')
        .collection('groups');
  }

  CollectionReference<Map<String, dynamic>> _cardsCol({
    required String courseId,
    required String groupId,
  }) {
    return _groupsCol(courseId).doc(groupId).collection('cards');
  }

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

  // ✅ Added (real-time updates requirement)
  @override
  Stream<List<FlashcardGroup>> watchFlashcardGroups(String courseId) {
    return _groupsCol(courseId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final d = doc.data();
        return FlashcardGroup.fromMap(d, doc.id);
      }).toList();
    });
  }

  @override
  Future<void> addFlashcardGroup(FlashcardGroup group) async {
    final data = group.toMap();

    // Keep your existing field
    data['userId'] = _uid;
    // ✅ Added: createdBy alias to match requirement naming (without removing userId)
    data['createdBy'] = _uid;

    // ✅ Minimal fix: doc(null) is invalid -> if empty, use add()
    if (group.id.trim().isEmpty) {
      await _groupsCol(group.courseId).add(data);
    } else {
      await _groupsCol(group.courseId).doc(group.id).set(data);
    }
  }

  @override
  Future<void> deleteFlashcardGroup(String courseId, String groupId) async {
    final cardsSnap = await _cardsCol(courseId: courseId, groupId: groupId).get();

    final batch = _db.batch();

    for (final doc in cardsSnap.docs) {
      batch.delete(doc.reference);
    }

    batch.delete(_groupsCol(courseId).doc(groupId));

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

  // ✅ Added (real-time updates requirement)
  @override
  Stream<List<Flashcard>> watchFlashcards(String courseId, String groupId) {
    return _cardsCol(courseId: courseId, groupId: groupId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final d = doc.data();
        return Flashcard.fromMap(d, doc.id);
      }).toList();
    });
  }

  @override
  Future<void> addFlashcard(Flashcard card) async {
    final data = card.toMap();

    // Keep your existing field
    data['userId'] = _uid;
    // ✅ Added: createdBy alias to match requirement naming (without removing userId)
    data['createdBy'] = _uid;

    // ✅ Minimal fix: doc(null) invalid -> add() when empty
    if (card.id.trim().isEmpty) {
      await _cardsCol(courseId: card.courseId, groupId: card.groupId).add(data);
    } else {
      await _cardsCol(courseId: card.courseId, groupId: card.groupId)
          .doc(card.id)
          .set(data);
    }
  }

  @override
  Future<void> deleteFlashcard(String courseId, String groupId, String cardId) async {
    await _cardsCol(courseId: courseId, groupId: groupId).doc(cardId).delete();
  }
}
