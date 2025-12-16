import '../models/resource.dart';

abstract class ResourcesRepo {
  Future<List<Resource>> getResourcesByCourse(String courseId);
  Future<void> addResource(Resource r);
  Future<void> updateResource(Resource r);
  Future<void> deleteResource(String courseId, String resourceId);
}
