import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/resource.dart';
import 'resources_repo.dart';

class FirestoreResourcesRepo implements ResourcesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _itemsRef(String courseId) =>
      _db.collection('courseResources').doc(courseId).collection('items');

  @override
  Future<List<Resource>> getResourcesByCourse(String courseId) async {
    final snap = await _itemsRef(courseId)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs.map((d) {
      final data = d.data();
      return Resource.fromMap(data, d.id);
    }).toList();
  }

  @override
  Future<void> addResource(Resource r) async {
    await _itemsRef(r.courseId).doc(r.id).set(r.toMap());
  }

  @override
  Future<void> updateResource(Resource r) async {
    await _itemsRef(r.courseId).doc(r.id).update(r.toMap());
  }

  @override
  Future<void> deleteResource(String courseId, String resourceId) async {
    await _itemsRef(courseId).doc(resourceId).delete();
  }
}
