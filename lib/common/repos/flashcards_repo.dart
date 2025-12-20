// lib/common/repos/flashcards_repo.dart

import '../models/flashcard.dart';

abstract class FlashcardsRepo {

  Future<List<FlashcardGroup>> getFlashcardGroups(String courseId);


  Stream<List<FlashcardGroup>> watchFlashcardGroups(String courseId);

  Future<void> addFlashcardGroup(FlashcardGroup group);

  Future<void> deleteFlashcardGroup(String courseId, String groupId);


  Future<List<Flashcard>> getFlashcards(String courseId, String groupId);


  Stream<List<Flashcard>> watchFlashcards(String courseId, String groupId);

  Future<void> addFlashcard(Flashcard card);

  Future<void> deleteFlashcard(String courseId, String groupId, String cardId);
}
