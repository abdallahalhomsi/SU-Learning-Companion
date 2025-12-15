// lib/common/repos/firestore_flashcards_repo.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/flashcard.dart';
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

  FlashcardGroup _groupFromDoc(
      String courseId,
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final d = doc.data() ?? {};
    final ts = d['createdAt'];
    DateTime createdAt = DateTime.now();
    if (ts is Timestamp) createdAt = ts.toDate();

    return FlashcardGroup(
      id: doc.id,
      courseId: courseId,
      title: (d['title'] ?? '').toString(),
      difficulty: (d['difficulty'] ?? 'Easy').toString(),
      createdAt: createdAt,
    );
  }

  Flashcard _cardFromDoc({
    required String courseId,
    required String groupId,
    required DocumentSnapshot<Map<String, dynamic>> doc,
  }) {
    final d = doc.data() ?? {};
    final ts = d['createdAt'];
    DateTime createdAt = DateTime.now();
    if (ts is Timestamp) createdAt = ts.toDate();

    return Flashcard(
      id: doc.id,
      courseId: courseId,
      groupId: groupId,
      question: (d['question'] ?? '').toString(),
      solution: (d['solution'] ?? '').toString(),
      difficulty: (d['difficulty'] ?? 'Easy').toString(),
      createdAt: createdAt,
    );
  }

  @override
  Future<List<FlashcardGroup>> getGroupsForCourse(String courseId) async {
    final snap = await _groupsCol(courseId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => _groupFromDoc(courseId, d)).toList();
  }

  @override
  Future<void> addGroup(FlashcardGroup group) async {
    await _groupsCol(group.courseId).doc(group.id).set({
      'title': group.title,
      'difficulty': group.difficulty,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeGroup({
    required String courseId,
    required String groupId,
  }) async {
    // delete group + all cards under it (small dataset assumption)
    final cardsSnap = await _cardsCol(courseId: courseId, groupId: groupId).get();
    final batch = _db.batch();

    for (final doc in cardsSnap.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_groupsCol(courseId).doc(groupId));

    await batch.commit();
  }

  @override
  Future<List<Flashcard>> getCards({
    required String courseId,
    required String groupId,
  }) async {
    final snap = await _cardsCol(courseId: courseId, groupId: groupId)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs
        .map((d) => _cardFromDoc(courseId: courseId, groupId: groupId, doc: d))
        .toList();
  }

  @override
  Future<void> addCard(Flashcard card) async {
    await _cardsCol(courseId: card.courseId, groupId: card.groupId)
        .doc(card.id)
        .set({
      'question': card.question,
      'solution': card.solution,
      'difficulty': card.difficulty,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeCard({
    required String courseId,
    required String groupId,
    required String cardId,
  }) async {
    await _cardsCol(courseId: courseId, groupId: groupId).doc(cardId).delete();
  }
}
