// lib/common/repos/flashcards_repo.dart

import '../models/flashcard.dart';

abstract class FlashcardsRepo {
  // --- GROUPS ---
  Future<List<FlashcardGroup>> getFlashcardGroups(String courseId);

  Future<void> addFlashcardGroup(FlashcardGroup group);

  // Added courseId back because Firestore needs it!
  Future<void> deleteFlashcardGroup(String courseId, String groupId);

  // --- CARDS ---
  // Added courseId because Firestore path structure needs it
  Future<List<Flashcard>> getFlashcards(String courseId, String groupId);

  Future<void> addFlashcard(Flashcard card);

  Future<void> deleteFlashcard(String courseId, String groupId, String cardId);
}