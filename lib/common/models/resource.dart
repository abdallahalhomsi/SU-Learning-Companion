// lib/common/models/resource.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Resource {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String link;
  final String createdBy; // Stores the UID of the creator for ownership checks
  final DateTime createdAt;

  Resource({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.link,
    required this.createdBy,
    required this.createdAt,
  });

  // Serializes the object for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'title': title,
      'description': description,
      'link': link,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Factory method to deserialize Firestore data
  static Resource fromMap(Map<String, dynamic> map, String id) {
    final ts = map['createdAt'];
    final createdAt = ts is Timestamp
        ? ts.toDate()
        : (ts is String ? DateTime.tryParse(ts) ?? DateTime.now() : DateTime.now());

    return Resource(
      id: id,
      courseId: (map['courseId'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      link: (map['link'] ?? '') as String,
      createdBy: (map['createdBy'] ?? '') as String,
      createdAt: createdAt,
    );
  }
}
