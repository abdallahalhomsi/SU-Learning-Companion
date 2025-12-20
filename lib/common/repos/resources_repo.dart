// lib/common/repos/resources_repo.dart
import '../models/resource.dart';

abstract class ResourcesRepo {
  Future<List<Resource>> getResourcesByCourse(String courseId);

  // ✅ Added (real-time updates requirement)
  Stream<List<Resource>> watchResourcesByCourse(String courseId);

  Future<void> addResource(Resource r);
  Future<void> updateResource(Resource r);
  Future<void> deleteResource(String courseId, String resourceId);
}
