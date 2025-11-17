import '../models/resource.dart';

abstract class ResourcesRepo {
  Future<List<Resource>> getResourcesByCourse(String courseId);
  Future<Resource> getResourceById(String id);
  Future<void> addResource(Resource resource);
  Future<void> updateResource(Resource resource);
  Future<void> deleteResource(String id);
}