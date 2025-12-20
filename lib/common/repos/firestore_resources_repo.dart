// lib/common/repos/firestore_resources_repo.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/resource.dart';
import 'resources_repo.dart';

class FirestoreResourcesRepo implements ResourcesRepo {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  FirestoreResourcesRepo({
    FirebaseFirestore? db,
    FirebaseAuth? auth,
  })  : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) throw Exception('Not logged in');
    return u.uid;
  }

  CollectionReference<Map<String, dynamic>> _resourcesRef(String courseId) {
    return _db
        .collection('courses')
        .doc(courseId)
        .collection('resources');
  }

  @override
  Future<List<Resource>> getResourcesByCourse(String courseId) async {
    final snap = await _resourcesRef(courseId)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs.map((d) {
      final data = d.data();
      return Resource.fromMap(data, d.id);
    }).toList();
  }

  // ✅ Added: real-time stream
  @override
  Stream<List<Resource>> watchResourcesByCourse(String courseId) {
    return _resourcesRef(courseId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((d) => Resource.fromMap(d.data(), d.id))
          .toList();
    });
  }

  @override
  Future<void> addResource(Resource r) async {
    final data = r.toMap();

    // Enforce server-side ownership by using the authenticated UID
    data['createdBy'] = _uid;

    if (r.id.isEmpty) {
      // Let Firestore generate a unique ID if none is provided
      await _resourcesRef(r.courseId).add(data);
    } else {
      await _resourcesRef(r.courseId).doc(r.id).set(data);
    }
  }

  @override
  Future<void> updateResource(Resource r) async {
    await _resourcesRef(r.courseId).doc(r.id).update(r.toMap());
  }

  @override
  Future<void> deleteResource(String courseId, String resourceId) async {
    await _resourcesRef(courseId).doc(resourceId).delete();
  }
}
