import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  final FirebaseFirestore _db;
  UserProfileService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required String uid,
    required String fullName,
    required String studentId,
    required String email,
    required String major,
    required String minor,
    required String department,
  }) async {
    await _db.collection('users').doc(uid).set({
      'fullName': fullName,
      'studentId': studentId,
      'email': email,
      'major': major,
      'minor': minor,
      'department': department,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
