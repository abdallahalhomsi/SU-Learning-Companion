import '../models/resource.dart';

abstract class ResourcesRepo {
  Future<List<Resource>> getResourcesByCourse(String courseId);

  /// Real-time stream
  Stream<List<Resource>> watchResourcesByCourse(String courseId);

  Future<void> addResource(Resource r);
  Future<void> updateResource(Resource r);
  Future<void> deleteResource(String courseId, String resourceId);
}
