// lib/common/repos/flashcards_repo.dart

import '../models/flashcard.dart';

abstract class FlashcardsRepo {
  // --- GROUPS ---
  Future<List<FlashcardGroup>> getFlashcardGroups(String courseId);

  // ✅ Added (real-time updates requirement)
  Stream<List<FlashcardGroup>> watchFlashcardGroups(String courseId);

  Future<void> addFlashcardGroup(FlashcardGroup group);

  Future<void> deleteFlashcardGroup(String courseId, String groupId);

  // --- CARDS ---
  Future<List<Flashcard>> getFlashcards(String courseId, String groupId);

  // ✅ Added (real-time updates requirement)
  Stream<List<Flashcard>> watchFlashcards(String courseId, String groupId);

  Future<void> addFlashcard(Flashcard card);

  Future<void> deleteFlashcard(String courseId, String groupId, String cardId);
}
