// This abstract class defines the contract for a repository that manages resources.
// It provides methods for retrieving, adding, updating, and removing resources.
import '../models/resource.dart';

abstract class ResourcesRepo {
  Future<List<Resource>> getResourcesByCourse(String courseId);
  Future<Resource> getResourceById(String id);
  Future<void> addResource(Resource resource);
  Future<void> updateResource(Resource resource);
  Future<void> deleteResource(String id);
}