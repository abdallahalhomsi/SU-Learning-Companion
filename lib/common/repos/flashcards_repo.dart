// lib/common/repos/flashcards_repo.dart
import '../models/flashcard.dart';

abstract class FlashcardsRepo {
  Future<List<FlashcardGroup>> getGroupsForCourse(String courseId);

  Future<void> addGroup(FlashcardGroup group);

  Future<void> removeGroup({
    required String courseId,
    required String groupId,
  });

  Future<List<Flashcard>> getCards({
    required String courseId,
    required String groupId,
  });

  Future<void> addCard(Flashcard card);

  Future<void> removeCard({
    required String courseId,
    required String groupId,
    required String cardId,
  });
}
